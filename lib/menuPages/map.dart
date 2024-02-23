import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:latlong2/latlong.dart';
import 'package:url_launcher/url_launcher.dart';

class MapLesson extends StatefulWidget {
  // This widget is the root of your application.
  const MapLesson({super.key,});
  @override
  State<MapLesson> createState() => _MapLessonState();
}

class _MapLessonState extends State<MapLesson> {

  @override
  Widget build(BuildContext context) {
    // виджет FlutterMap, который является виджетом карты
    return Scaffold(
      appBar: AppBar(
        title: Text('Карта'),
        backgroundColor: Colors.blueGrey[400],
        centerTitle: true,
      ),
      body: FlutterMap(
        //Устанавливает параметры карты, такие как начальный центр и начальный масштаб
        options: const MapOptions(
          initialCenter:  LatLng(56.285, 84.42),
          initialZoom: 10,
        ),
        children: <Widget>[
          //Виджет, который отображает черепицы карты.
          TileLayer(
            //URL-шаблон для загрузки черепиц.
            urlTemplate: 'https://tile.openstreetmap.org/{z}/{x}/{y}.png',
            //Имя пакета приложения, которое будет использоваться в пользовательском агенте.
            userAgentPackageName: 'com.example.app',
          ),
          //Имя пакета приложения, которое будет использоваться в пользовательском агенте.
          RichAttributionWidget(
            //Список атрибуций, которые будут отображаться
            attributions: [
              TextSourceAttribution(
                'OpenStreetMap contributors',
                onTap: () => launchUrl(Uri.parse('https://openstreetmap.org/copyright')),
              ),
            ],
          ),
          // Виджет, который отображает полигоны на карте.
          PolygonLayer(
            //Список полигонов, которые будут отображаться.
            polygons: [
              //Виджет, который представляет собой полигон.
              Polygon (
                //Список точек, которые определяют полигон.
                points: [LatLng(56.75, 84.95), LatLng(56.75, 84.915), LatLng(56.789, 84.92)],
                color: Colors.orange,
                //Флаг, указывающий, следует ли заполнять полигон
                isFilled: true,
              ),
            ],
          ),
          //Виджет, который отображает полилинии на карте.
          PolylineLayer(
            // cписок
            polylines: [
              //виджет
              Polyline(
                points: [ LatLng(56.79, 84.9), LatLng(56.82, 84.96), LatLng(56.79, 84.955)],
                color:Colors.orange,
              ),
            ],
          ),
          //отображает круги на карте.
          CircleLayer(
            circles: [
              //Виджет, который представляет собой маркер круга.
              CircleMarker(
                point: LatLng(56.83, 84.95),
                color: Colors.orange,
                radius: 500,
                useRadiusInMeter: true,
              ),
            ],
          ),

          PolygonLayer(
            polygons: [
              Polygon (
                points: [LatLng(56.62, 84.72), LatLng(56.58, 84.72), LatLng(56.55, 84.68)],
                color: Colors.blue,
                isFilled: true,
              ),
            ],
          ),
          PolylineLayer(
            polylines: [
              Polyline(
                points: [ LatLng(56.591, 84.73), LatLng(56.6, 84.74), LatLng(56.595, 84.75)],
                color: Colors.blue,
              ),
            ],
          ),
          CircleLayer(
            circles: [
              CircleMarker(
                point: LatLng(56.6, 84.7),
                color: Colors.blue,
                radius: 300,
                useRadiusInMeter: true,
              ),
            ],
          ),
          PolygonLayer(
            polygons: [
              Polygon (
                points: [LatLng(56.28, 84.41), LatLng(56.27, 84.419), LatLng(56.289, 84.42)],
                color: Colors.green,
                isFilled: true,
              ),
            ],
          ),
          PolylineLayer(
            polylines: [
              Polyline(
                points: [ LatLng(56.291, 84.43), LatLng(56.3, 84.44), LatLng(56.295, 84.45)],
                color: Colors.green,
              ),
            ],
          ),
          CircleLayer(
            circles: [
              CircleMarker(
                point: LatLng(56.3, 84.4),
                color: Colors.green,
                radius: 200,
                useRadiusInMeter: true,
              ),],
          ),
        ],
      ),
        floatingActionButton: Padding(
          padding: const EdgeInsets.only(bottom: 70.0, left: 10),
            child: FloatingActionButton(
             child: Text('Перейти в БД'),
              onPressed: () {
                Navigator.pushNamedAndRemoveUntil(context, '/mapDB', (route) => true);
              },
              backgroundColor: Colors.white,
          ),
        ),
        floatingActionButtonLocation: FloatingActionButtonLocation.startDocked,
      );
  }
}