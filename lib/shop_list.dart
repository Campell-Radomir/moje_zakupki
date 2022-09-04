import 'package:flutter/material.dart';
import 'package:moje_zakupki/add_shop_form.dart';
import 'package:moje_zakupki/db/shop_dao.dart';
import 'package:moje_zakupki/shop_products.dart';

import 'shop.dart';

class ShopList extends StatefulWidget {
  const ShopList({Key? key}) : super(key: key);

  @override
  State<ShopList> createState() => _ShopListState();
}

class _ShopListState extends State<ShopList> {

  final ShopDao shopDao = ShopDao();
  Future<List<Shop>> getShopList() async {
    return shopDao.findAll();
  }

  _routeToAddShop() {
    Navigator.of(context).push(
        MaterialPageRoute(builder: (context) =>
            const AddShopForm(),)
    ).whenComplete(() => setState(() {}));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: CustomScrollView(
        slivers: [
          const SliverAppBar(floating: true,
          title: Text("Moje zakupki"),),
          SliverList(
              delegate: SliverChildListDelegate([
            Center(
                child: FutureBuilder<List<Shop>>(
              future: getShopList(),
              builder: (context, snapshot) {
                return ConnectionState.waiting == snapshot.connectionState
                    ? const CircularProgressIndicator()
                    : GridView.count(
                        crossAxisCount: 2,
                        primary: false,
                        shrinkWrap: true,
                        children: List.generate(
                            snapshot.data!.length,
                            (index) => Center(
                                    child: ShopCard(
                                  shop: snapshot.data![index],
                                ))));
              },
            ))
          ]))
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: _routeToAddShop,
        tooltip: 'Dodaj',
        child: const Icon(Icons.add),
      ),
    );
  }
}

class ShopCard extends StatelessWidget {
  const ShopCard({
    Key? key,
    required this.shop,
  }) : super(key: key);

  final Shop shop;

  _routeToShopProductList(BuildContext context) {
    Navigator.of(context).push(
      MaterialPageRoute(builder: (context) => ShopProducts(shop: shop),)
    );
  }

  @override
  Widget build(BuildContext context) {
    return InkWell(
      child: DecoratedBox(
        decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(10),
            color: shop.backgroundColor),
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Text(
            shop.name,
            style:
                TextStyle(fontSize: 20, height: 2, color: shop.foregroundColor),
          ),
        ),
      ),
      onTap: () => _routeToShopProductList(context),
    );
  }
}
