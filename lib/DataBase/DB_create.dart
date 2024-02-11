import 'dart:async';
import 'dart:io';

import 'package:flutter/foundation.dart';
import 'package:path/path.dart';
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

   static Future<void> DB() async {
     if (_database == null) {
       _database = await db();
     }
 }

  static FutureOr<sql.Database> db() async {
    final Directory dir = await getApplicationDocumentsDirectory();
    final String path = '${dir.path}/mobile.sqlite';
    return await sql.openDatabase(path, version: 1, onCreate: (sql.Database database, int version) async {
      await database.execute("""CREATE TABLE types(
        id INTEGER PRIMARY KEY AUTOINCREMENT NOT NULL,
        name TEXT,
        profit INTEGER,
        createdAt TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP
      )
      """);
      await database.execute("""CREATE TABLE categories(
        id INTEGER PRIMARY KEY AUTOINCREMENT NOT NULL,
        name TEXT,
        type INTEGER REFERENCES types (id),
        createdAt TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP
        )
      """);
    });
  }

  static FutureOr<void> createTables() async {
    await _database?.execute("""CREATE TABLE types(
        id INTEGER PRIMARY KEY AUTOINCREMENT NOT NULL,
        name TEXT,
        profit INTEGER,
        createdAt TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP
      )
      """);
    await _database?.execute("""CREATE TABLE categories(
        id INTEGER PRIMARY KEY AUTOINCREMENT NOT NULL,
        name TEXT,
        type INTEGER REFERENCES types (id),
        createdAt TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP
        )
      """);
  }

  //ТИПЫ ----- ТИПЫ ----- ТИПЫ ----- ТИПЫ ----- ТИПЫ ----- ТИПЫ ----- ТИПЫ ----- ТИПЫ ----- ТИПЫ

// Создание нового объекта (журнал)
  static Future<int?> createItem(String name, int profit) async {
 //   await SQLHelper.db;
    await DB();
    final data = {'name': name, 'profit': profit};
    final id = await _database?.insert('types', data, conflictAlgorithm: sql.ConflictAlgorithm.replace);
    return id;
  }

  // Прочитать все элементы (журнал)
  static Future<List<Map<String, dynamic>>?> getItems() async {
 //   await SQLHelper.db;
    await DB();
 //   await _database?.database;
    return _database?.query('types', orderBy: "id");
  }

  // Прочитать элемент по id
  // Не используется, на всякий случай здесь
  static Future<List<Map<String, dynamic>>?> getItem(int id) async {
 //   await SQLHelper.db;
 //   await _database?.database;
    await DB();
    return _database?.query('types', where: "id = ?", whereArgs: [id], limit: 1);
  }

  // Обновление объекта по id
  static Future<int?> updateItem(int id, String name, int profit) async {
  //  await SQLHelper.db;
  //  await _database?.database;
    await DB();
    final data = {
      'name': name,
      'profit': profit,
      'createdAt': DateTime.now().toString()
    };
    return _database?.update('types', data, where: "id = ?", whereArgs: [id]);;
  }

  // Удалить по id
  static Future<void> deleteItem(int id) async {
  //  await SQLHelper.db;
 //   await _database?.database;
    await DB();
    try {
      await _database?.delete("types", where: "id = ?", whereArgs: [id]);
    } catch (err) {
      debugPrint("Something went wrong when deleting an item: $err");
    }
  }

}
