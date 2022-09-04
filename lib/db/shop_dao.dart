import 'package:moje_zakupki/db/app_database.dart';
import 'package:moje_zakupki/shop.dart';
import 'package:sqflite/sqflite.dart';

class ShopDao {
  static const String tableName = 'shops';

  final AppDatabase _database = AppDatabase.instance;

  Future<List<Shop>> findAll() async {
    final db = await _database.database;

    var result = await db.query(tableName);

    return result.map((json) => Shop.fromMap(json)).toList();
  }

  Future<void> save(Shop shop) async {
    final db = await _database.database;

    await db.insert(tableName,
        shop.toMap(),
        conflictAlgorithm: ConflictAlgorithm.replace);
  }

  Future<void> delete(Shop shop) async {
    final db = await _database.database;

    await db.delete(tableName, where: 'id = ?', whereArgs: [shop.id]);
  }
}
