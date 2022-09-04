import 'package:moje_zakupki/category_enum.dart';
import 'package:uuid/uuid.dart';

import 'shop.dart';
class Product {

  final String id = const Uuid().v4();
  String name;
  Category category;
  int pieces;
  late final String shopId;

  Product({required this.name, required this.category,this.pieces = 1,required Shop shop}) {
    shopId = shop.id;
  }

  static int compare(Product a, Product b) {
    return a.name.compareTo(b.name);
  }

  static List<Product> generateProductsFor(Shop shop) {
    return [
      Product(name: 'Masło', category: Category.dairy, shop: shop),
      Product(name: 'Jogurt', category: Category.dairy, shop: shop),
      Product(name: 'Rum', category: Category.alcohol, shop: shop),
      Product(name: 'Łopatka', category: Category.meat, shop: shop),
      Product(name: 'Pierś', category: Category.meat, shop: shop),
      Product(name: 'Pomidor', category: Category.vegetables, shop: shop),
      Product(name: 'Marchew', category: Category.vegetables, shop: shop),
      Product(name: 'Cukinia', category: Category.vegetables, shop: shop),
      Product(name: 'Bakłażan', category: Category.vegetables, shop: shop),
      Product(name: 'Pietruszka', category: Category.vegetables, shop: shop),
      Product(name: 'Jabłko', category: Category.vegetables, shop: shop),
      Product(name: 'Gruszka', category: Category.vegetables, shop: shop),
      Product(name: 'Słuchawki', category: Category.electronic, shop: shop),
    ];
  }
}