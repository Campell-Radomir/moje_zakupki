import 'package:moje_zakupki/db/app_database.dart';
import 'package:moje_zakupki/product.dart';
import 'package:moje_zakupki/shop.dart';
import 'package:sqflite/sqflite.dart';

class ProductDao {

  static const String tableName = 'products';
  final AppDatabase _database = AppDatabase.instance;

  Future<List<Product>> findAllByShop(Shop shop) async {
    final db = await _database.database;


    var result = await db.query(tableName, where: 'shopId = ?', whereArgs: [shop.id]);

    return result.map((json) => Product.fromMap(json)).toList();
  }

  Future<void> save(Product product) async {
    final db = await _database.database;

    await db.insert(tableName, 
        product.toMap(), 
        conflictAlgorithm: ConflictAlgorithm.replace
    );
  }
  
  Future<void> delete(Product product) async {
    final db = await _database.database;

    await db.delete(tableName, where: 'id = ?', whereArgs: [product.id]);
  }
}