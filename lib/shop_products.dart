
import 'package:flutter/material.dart';
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
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: CustomScrollView(
        slivers: [
          const SliverAppBar(
            floating: true,
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
                                products: snapshot.data![category] ?? []);
                          }),
                        );
                },
              ),
            ),
          ]))
        ],
      ),
    );
  }

  Future<Map<Category, List<Product>>> getProducts() async {
    await Future.delayed(const Duration(seconds: 2));

    return groupBy(Product.generateProductsFor(widget.shop));
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
}

class CategoryProducts extends StatefulWidget {
  const CategoryProducts(
      {Key? key, required this.category, required this.products})
      : super(key: key);

  final Category category;
  final List<Product> products;

  @override
  State<CategoryProducts> createState() => _CategoryProductsState();
}

class _CategoryProductsState extends State<CategoryProducts> {
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
          ),
        );
      }),
    );
  }
}
