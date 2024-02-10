import 'package:flutter/foundation.dart';
import 'package:sqflite/sqflite.dart' as sql;

//создание таблицы
class SQLHelperCategory {
  static Future<void> createTables(sql.Database database) async {
    await database.execute("""CREATE TABLE categories(
        id INTEGER PRIMARY KEY AUTOINCREMENT NOT NULL,
        name TEXT,
        type INTEGER REFERENCES types (id),
        createdAt TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP
        )
      """);
  }

  static Future<sql.Database> db() async {
    return sql.openDatabase(
      'budget.db',
      version: 1,
      onCreate: (sql.Database database, int version) async {
        await createTables(database);
      },
    );
  }

  // Создание нового объекта (журнал)
  static Future<int> createItem(String name, int type) async {
    final db = await SQLHelperCategory.db();
    final data = {'name': name, 'type': type};
    final id = await db.insert('categories', data,
        conflictAlgorithm: sql.ConflictAlgorithm.replace);
    await db.close();
    return id;
  }

  // Прочитать все элементы (журнал)
  static Future<List<Map<String, dynamic>>> getItems() async {
    final db = await SQLHelperCategory.db();
    final dbHelper = db.query('categories', orderBy: "id");
    await db.close();
    return dbHelper;
  }

  // Прочитать элемент по id
  // Не используется, на всякий случай здесь
  static Future<List<Map<String, dynamic>>> getItem(int id) async {
    final db = await SQLHelperCategory.db();
    final dbHelper = db.query('categories', where: "id = ?", whereArgs: [id], limit: 1);
    await db.close();
    return dbHelper;
  }

  // Обновление объекта по id
  static Future<int> updateItem(int id, String name, int type) async {
    final db = await SQLHelperCategory.db();
    final data = {
      'name': name,
      'type': type,
      'createdAt': DateTime.now().toString()
    };
    final result = await db.update('categories', data, where: "id = ?", whereArgs: [id]);
    await db.close();
    return result;
  }

  // Удалить по id
  static Future<void> deleteItem(int id) async {
    final db = await SQLHelperCategory.db();
    try {
      await db.delete("categories", where: "id = ?", whereArgs: [id]);
      await db.close();
    } catch (err) {
      debugPrint("Something went wrong when deleting an item: $err");
      await db.close();
    }
  }
}