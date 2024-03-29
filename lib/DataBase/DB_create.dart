import 'dart:async';
import 'dart:io';
import 'package:flutter/foundation.dart';
import 'package:path_provider/path_provider.dart';
import 'package:sqflite/sqflite.dart' as sql;

class SQLHelper  {

  static int flag = 0;

  static sql.Database? _database;

  Future<sql.Database?> get database async {
     if (_database != null) {
       return _database;
     }
     _database = await db();
     return _database;
   }

  FutureOr<sql.Database> db() async {
    final Directory dir = await getApplicationDocumentsDirectory();
    final String path = '${dir.path}/mobile.sqlite';
    return await sql.openDatabase(path, version: 1, onCreate: (sql.Database database, int version) async {
      await database.execute("""CREATE TABLE types(
        id INTEGER PRIMARY KEY AUTOINCREMENT NOT NULL,
        name TEXT NOT NULL,
        profit INTEGER NOT NULL,
        createdAt TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP
      )
      """);
      await database.execute("""CREATE TABLE categories(
        id INTEGER PRIMARY KEY AUTOINCREMENT NOT NULL,
        name TEXT NOT NULL,
        type INTEGER REFERENCES types (id) NOT NULL,
        createdAt TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP
        )
      """);
      await database.execute("""CREATE TABLE transactions(
        id INTEGER PRIMARY KEY AUTOINCREMENT NOT NULL,
        name TEXT NOT NULL,
        count REAL NOT NULL,
        category INTEGER REFERENCES types (id) NOT NULL,
        createdAt TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP
        )
      """);
    });
  }

  //ТИПЫ ----- ТИПЫ ----- ТИПЫ ----- ТИПЫ ----- ТИПЫ ----- ТИПЫ ----- ТИПЫ ----- ТИПЫ ----- ТИПЫ

// Создание нового объекта (журнал)
  Future<int> createItemType(String name, int profit) async {
 //   await SQLHelper.db;
 //    await DB();
    final data = {'name': name, 'profit': profit};
    final sql.Database? db = await database;
    return db!.insert('types', data, conflictAlgorithm: sql.ConflictAlgorithm.replace);
  }

  // Прочитать все элементы (журнал)
  Future<List<Map<String, dynamic>>?> getItemsType() async {
    // await DB();
    final sql.Database? db = await database;
    return db!.query('types', orderBy: "id");
  }

  // Прочитать элемент по id
  // Не используется, на всякий случай здесь
  Future<List<Map<String, dynamic>>?> getItemType(int id) async {
    final sql.Database? db = await database;
    return await db!.query('types', where: "id = ?", whereArgs: [id], limit: 1);
  }

  // Обновление объекта по id
  Future<int?> updateItemType(int id, String name, int profit) async {
    final sql.Database? db = await database;
    final data = {
      'name': name,
      'profit': profit,
      'createdAt': DateTime.now().toString()
    };
    return await db?.update('types', data, where: "id = ?", whereArgs: [id]);
  }

  // Удалить по id
  Future<void> deleteItemType(int id) async {
    final sql.Database? db = await database;
    try {
      await db?.delete("types", where: "id = ?", whereArgs: [id]);
    } catch (err) {
      debugPrint("Something went wrong when deleting an item: $err");
    }
  }

  Future<List<Map<String, dynamic>>?> getItemNamesType() async {
    final sql.Database? db = await database;
    //return _database?.query('types', orderBy: "id");
    return db?.rawQuery('SELECT name, id FROM types');
  }

  // КАТЕГОРИИ ----- КАТЕГОРИИ ----- КАТЕГОРИИ ----- КАТЕГОРИИ ----- КАТЕГОРИИ ----- КАТЕГОРИИ ----- КАТЕГОРИИ

  // Создание нового объекта (журнал)
  Future<int?> createItemCategories(String name, int type) async {
    final sql.Database? db = await database;
    final data = {'name': name, 'type': type};
    return await db?.insert('categories', data, conflictAlgorithm: sql.ConflictAlgorithm.replace);;
  }

  // Прочитать все элементы (журнал)
  Future<List<Map<String, dynamic>>?> getItemsCategories() async {
    final sql.Database? db = await database;
    return await db?.query('categories', orderBy: "id");;
  }

  // Прочитать элемент по id
  // Не используется, на всякий случай здесь
  Future<Future<List<Map<String, Object?>>>?> getItemCategories(int id) async {
    final sql.Database? db = await database;
    return db?.query('categories', where: "id = ?", whereArgs: [id], limit: 1);
  }

  // Обновление объекта по id
  Future<int?> updateItemCategories(int id, String name, int type) async {
    final sql.Database? db = await database;
    final data = {
      'name': name,
      'type': type,
      'createdAt': DateTime.now().toString()
    };
    return await db?.update('categories', data, where: "id = ?", whereArgs: [id]);;
  }

  // Удалить по id
  Future<void> deleteItemCategories(int id) async {
    final sql.Database? db = await database;
    try {
      await db?.delete("categories", where: "id = ?", whereArgs: [id]);
    } catch (err) {
      debugPrint("Something went wrong when deleting an item: $err");
    }
  }

  Future<List<Map<String, dynamic>>?> getItemNamesCategory() async {
    final sql.Database? db = await database;
    //return _database?.query('types', orderBy: "id");
    return db?.rawQuery('SELECT name, id FROM categories');
  }

  Future<String> getTypeOfCategory(int id) async {
    final sql.Database? db = await database;
    final helperType = await db?.rawQuery('SELECT name FROM types WHERE id = ?', [id]);
    if (helperType != null) {
      return helperType[0]['name'].toString();
    }
    return Future.value('');
  }


// ТРАНЗАКЦИИ ----- ТРАНЗАКЦИИ ----- ТРАНЗАКЦИИ ----- ТРАНЗАКЦИИ ----- ТРАНЗАКЦИИ ----- ТРАНЗАКЦИИ ----- ТРАНЗАКЦИИ ----- ТРАНЗАКЦИИ

// Создание нового объекта (журнал)
  Future<int?> createItemTransaction(String name, int category, double count) async {
    final sql.Database? db = await database;
    final data = {'name': name, 'category': category, 'count': count};
    return await db?.insert('transactions', data, conflictAlgorithm: sql.ConflictAlgorithm.replace);;
  }

  // Прочитать все элементы (журнал)
  Future<List<Map<String, dynamic>>?> getItemsTransaction() async {
    final sql.Database? db = await database;
    return await db?.query('transactions', orderBy: "id");
  }

  // Прочитать элемент по id
  // Не используется, на всякий случай здесь
  Future<Future<List<Map<String, Object?>>>?> getItemTransaction(int id) async {
    final sql.Database? db = await database;
    return db?.query('transactions', where: "id = ?", whereArgs: [id], limit: 1);
  }

  // Обновление объекта по id
  Future<int?> updateItemTransaction(int id, String name, int category, double count) async {
    final sql.Database? db = await database;
    final data = {
      'name': name,
      'category': category,
      'count': count,
      'createdAt': DateTime.now().toString()
    };
    return await db?.update('transactions', data, where: "id = ?", whereArgs: [id]);;
  }

  // Удалить по id
  Future<void> deleteItemTransaction(int id) async {
    final sql.Database? db = await database;
    try {
      await db?.delete("transactions", where: "id = ?", whereArgs: [id]);
    } catch (err) {
      debugPrint("Something went wrong when deleting an item: $err");
    }
  }

  Future<String> getCategoryOfTransaction(int id) async {
    final sql.Database? db = await database;
    final helperType = await db?.rawQuery('SELECT name FROM categories WHERE id = ?', [id]);
    if (helperType != null) {
      return helperType[0]['name'].toString();
    }
    return Future.value('');
  }

  Future<String> getNameCategoryFromId(int id) async {
    final sql.Database? db = await database;
    final helper = await db?.rawQuery('SELECT name FROM categories WHERE id = ?', [id]);
    if (helper != null) {
      return helper[0]['name'].toString();
    }
    return Future.value('');
  }

  // PDF ----- PDF ----- PDF ----- PDF ----- PDF ----- PDF ----- PDF ----- PDF ----- PDF ----- PDF ----- PDF ----- PDF ----- PDF ----- PDF ----- PDF ----- PDF

  Future<String> getStringForPDF() async {
    final sql.Database? db = await database;
    String assHelper = '${await db?.rawQuery('SELECT name, count, createdAt FROM transactions')}';
    late String ass = ' ';
    for( int i = 0; i < assHelper.length; i++){
      if (assHelper[i] == '}') {
        ass += '\n';
      }
      else if (assHelper[i] == '{' || assHelper[i] == ',' || assHelper[i] == '[' || assHelper[i] == ']') {
        continue;
      }
      else {
        ass = ass + assHelper[i];
      }
    }
    return ass;
  }

}