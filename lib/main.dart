import 'package:flutter/material.dart';
import 'package:budget_rosneft/pages/main_screen.dart';
import 'package:budget_rosneft/menuPages/types.dart';

void main() => runApp(MaterialApp(
  theme: ThemeData(
    primaryColor: Colors.blueAccent,
  ),
  initialRoute: '/',
  routes: {
    '/': (context) => MainScreen(),
    '/types': (context) => Types(),
   // '/categories': (context) => Categories(),
   // '/exchangerate': (context) => ExchangeRate(),

  },
));