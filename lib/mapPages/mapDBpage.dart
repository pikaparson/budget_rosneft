import 'dart:typed_data';
import 'package:budget_rosneft/MapDataBase/Map_DB_create.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
class MapDB extends StatefulWidget {
  const MapDB({super.key});

  @override
  State<MapDB> createState() => _MapDBState();
}

class _MapDBState extends State<MapDB> {
  //String text = '';
  Future<String> createText() async {
    return '${await SQLHelperMap().getPolygonItemsAsString()}';
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.blueGrey[400],
      appBar: AppBar(
        title: const Text('База данных полигонов'),
        backgroundColor: Colors.blueGrey[700],
        centerTitle: true,
      ),
      body: Center(
        child: FutureBuilder( //Text('${createText()}', style: TextStyle(fontSize: 15),)//
            future: createText(),
            builder: (BuildContext context, AsyncSnapshot snapshot) {
              return Text('${snapshot.data}');
            }
        ),
      ),
    );
  }
}
