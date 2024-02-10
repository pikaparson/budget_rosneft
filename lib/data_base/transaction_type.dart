import 'package:flutter/foundation.dart';
import 'package:sqflite/sqflite.dart' as sql;

//создание таблицы
class SQLHelper {
  static Future<void> createTables(sql.Database database) async {
    await database.execute("""CREATE TABLE types(
        id INTEGER PRIMARY KEY AUTOINCREMENT NOT NULL,
        name TEXT,
        profit INTEGER,
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
  static Future<int> createItem(String name, int profit) async {
    final db = await SQLHelper.db();
    final data = {'name': name, 'profit': profit};
    final id = await db.insert('types', data,
        conflictAlgorithm: sql.ConflictAlgorithm.replace);
    return id;
  }

  // Прочитать все элементы (журнал)
  static Future<List<Map<String, dynamic>>> getItems() async {
    final db = await SQLHelper.db();
    return db.query('types', orderBy: "id");
  }

  // Прочитать элемент по id
  // Не используется, на всякий случай здесь
  static Future<List<Map<String, dynamic>>> getItem(int id) async {
    final db = await SQLHelper.db();
    return db.query('types', where: "id = ?", whereArgs: [id], limit: 1);
  }

  // Обновление объекта по id
  static Future<int> updateItem(int id, String name, int profit) async {
    final db = await SQLHelper.db();
    final data = {
      'name': name,
      'profit': profit,
      'createdAt': DateTime.now().toString()
    };
    final result = await db.update('types', data, where: "id = ?", whereArgs: [id]);
    return result;
  }

  // Удалить по id
  static Future<void> deleteItem(int id) async {
    final db = await SQLHelper.db();
    try {
      await db.delete("types", where: "id = ?", whereArgs: [id]);
    } catch (err) {
      debugPrint("Something went wrong when deleting an item: $err");
    }
  }
}