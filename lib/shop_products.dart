import 'package:flutter/material.dart';
import 'package:moje_zakupki/add_product_form.dart';
import 'package:moje_zakupki/db/product_dao.dart';
import 'package:moje_zakupki/product.dart';

import 'category_enum.dart';
import 'shop.dart';

class ShopProducts extends StatefulWidget {
  const ShopProducts({Key? key, required this.shop}) : super(key: key);

  final Shop shop;

  @override
  State<ShopProducts> createState() => _ShopProductsState();
}

class _ShopProductsState extends State<ShopProducts> {
  final ProductDao productDao = ProductDao();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: CustomScrollView(
        slivers: [
          SliverAppBar(
            floating: true,
            title: Text(widget.shop.name),
          ),
          SliverList(
              delegate: SliverChildListDelegate([
            Center(
              child: FutureBuilder<Map<Category, List<Product>>>(
                future: getProducts(),
                builder: (context, snapshot) {
                  return ConnectionState.waiting == snapshot.connectionState
                      ? const Padding(
                          padding: EdgeInsets.all(100.0),
                          child: CircularProgressIndicator(),
                        )
                      : ListView(
                          primary: false,
                          shrinkWrap: true,
                          padding: EdgeInsets.zero,
                          children:
                              List.generate(snapshot.data!.length, (index) {
                            Category category =
                                snapshot.data!.keys.elementAt(index);
                            return CategoryProducts(
                                category: category,
                                products: snapshot.data![category] ?? [],
                              deleteCallback: () => setState(() {}),
                              undoDeleteCallback: () => setState(() {}),
                            );
                          }),
                        );
                },
              ),
            ),
          ]))
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: _routeToAddProduct,
        tooltip: 'Dodaj',
        child: const Icon(Icons.add),
      ),
    );
  }

  Future<Map<Category, List<Product>>> getProducts() async {
    return groupBy(await productDao.findAllByShop(widget.shop));
  }

  Map<Category, List<Product>> groupBy(List<Product> products) {
    Map<Category, List<Product>> map = {};
    for (var product in products) {
      (map[product.category] ??= []).add(product);
    }

    for (var element in map.keys) {
      map[element]?.sort((a, b) => Product.compare(a, b));
    }

    return map;
  }

  void _routeToAddProduct() {
    Navigator.of(context).push(MaterialPageRoute(
      builder: (context) => AddProductForm(shop: widget.shop),
    )).whenComplete(() => setState(() {}));
  }
}

class CategoryProducts extends StatefulWidget {
  const CategoryProducts(
      {Key? key, required this.category, required this.products,
        required this.deleteCallback, required this.undoDeleteCallback})
      : super(key: key);

  final Category category;
  final List<Product> products;
  final Function deleteCallback;
  final Function undoDeleteCallback;

  @override
  State<CategoryProducts> createState() => _CategoryProductsState();
}

class _CategoryProductsState extends State<CategoryProducts> {
  final ProductDao _productDao = ProductDao();

  @override
  Widget build(BuildContext context) {
    if (widget.products.isEmpty) return Container();
    var hslColor = HSLColor.fromColor(widget.category.color);
    return ExpansionTile(
      title: Text(widget.category.displayName),
      backgroundColor: widget.category.color,
      collapsedBackgroundColor: widget.category.color,
      textColor: Colors.black,
      iconColor: Colors.black,
      children: List.generate(widget.products.length, (index) {
        var product = widget.products[index];
        return Container(
          color: index % 2 == 0
              ? hslColor
                  .withLightness((hslColor.lightness + 0.05).clamp(0, 1))
                  .toColor()
              : hslColor
                  .withLightness((hslColor.lightness + 0.2).clamp(0, 1))
                  .toColor(),
          child: ListTile(
            title: Text(product.name),
            subtitle: Text('Sztuk: ${product.pieces}'),
            onLongPress: () => _deleteProduct(product),
          ),
        );
      }),
    );
  }

  _deleteProduct(Product product) async {
    await _productDao.delete(product);

    if(!mounted) return;
    widget.deleteCallback();
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(
      content: Text('Usunięto ${product.name}'),
      action: SnackBarAction(
        label: 'Undo',
        onPressed: () async {
          await _productDao.save(product);
          widget.undoDeleteCallback();
        },
      ),
    ));
  }
}
