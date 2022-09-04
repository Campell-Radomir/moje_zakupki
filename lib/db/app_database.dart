import 'dart:async';

import 'package:moje_zakupki/db/product_dao.dart';
import 'package:moje_zakupki/db/shop_dao.dart';
import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';

class AppDatabase {
  static final AppDatabase instance = AppDatabase._init();

  static Database? _database;

  AppDatabase._init();

  Future<Database> get database async =>
      _database ??= await _initDB('moje_zakupki.db');


  Future<Database> _initDB(String filePath) async {
    return await openDatabase(join(await getDatabasesPath(), filePath),
        version: 1, onCreate: _createDB);
  }

  Future close() async {
    final db = await instance.database;

    db.close();
  }

  Future<FutureOr<void>> _createDB(Database db, int version) async {
    const idType = 'TEXT PRIMARY KEY';
    await db.execute('''
    CREATE TABLE IF NOT EXISTS ${ShopDao.tableName} (
    _id $idType,
    name TEXT NOT NULL,
    priority INTEGER NOT NULL,
    backgroundColor INTEGER NOT NULL,
    foregroundColor INTEGER NOT NULL
    );
    ''');

    await db.execute('''
    CREATE TABLE IF NOT EXISTS ${ProductDao.tableName} (
    _id $idType,
    name TEXT NOT NULL,
    category TEXT NOT NULL,
    pieces INTEGER NOT NULL,
    shopId TEXT NOT NULL,
    FOREIGN KEY(shopId) REFERENCES ${ShopDao.tableName}(id)
    );
    ''');

  }
}
