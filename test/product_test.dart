import 'package:flutter_test/flutter_test.dart';
import 'package:moje_zakupki/category_enum.dart';
import 'package:moje_zakupki/product.dart';
import 'package:moje_zakupki/shop.dart';

void main() {
  test('Product should have a reference to shop that it belongs to', () {
    Shop shop = Shop(name: 'Selgros');

    Product product = Product(name: 'Kakao', category: Category.candy, shop: shop);

    expect(product.shopId.toString(), shop.id.toString());
  });
}