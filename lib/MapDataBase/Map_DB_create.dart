import 'dart:async';
import 'dart:io';
import 'package:path_provider/path_provider.dart';
import 'package:sqflite/sqflite.dart' as sql;

class SQLHelperMap  {
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
    final String path = '${dir.path}/map.sqlite';
    return await sql.openDatabase(path, version: 1, onCreate: (sql.Database database, int version) async {
      await database.execute("""CREATE TABLE poligons(
        id INTEGER PRIMARY KEY AUTOINCREMENT NOT NULL,
        name TEXT NOT NULL,
        coordinates TEXT NOT NULL,
        color TEXT NOT NULL
      )
      """);
      await database.insert('poligons',
          {'name': 'CircleLayer', 'coordinates': '56.3, 84.4', 'color': 'Зеленый'},
          conflictAlgorithm: sql.ConflictAlgorithm.replace);
    });
  }

  Future<void> createItemPoligon(String name, String coordinates, String color) async {
    final data = {'name': name, 'coordinates': coordinates, 'color': color};
    final sql.Database? db = await database;
    await db!.insert('poligons', data, conflictAlgorithm: sql.ConflictAlgorithm.replace);
  }

  Future<String> getPolygonItemsAsString() async {
    final sql.Database? db = await database;

    String stringHelper = '${await db?.rawQuery('SELECT id, name, coordinates, color FROM poligons')}';
    late String string = ' ';
    for( int i = 0; i < stringHelper.length; i++){
      if (stringHelper[i] == '}') {
        string += '\n';
      }
      else if (stringHelper[i] == '{' || stringHelper[i] == ',' || stringHelper[i] == '[' || stringHelper[i] == ']') {
        continue;
      }
      else {
        string = string + stringHelper[i];
      }
    }
    return string;
  }

}