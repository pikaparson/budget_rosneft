import 'package:budget_rosneft/DataBase/returnPDF.dart';
import 'package:budget_rosneft/pages/exchangerate.dart';
import 'package:flutter/material.dart';

import 'package:budget_rosneft/pages/main_screen.dart';

import 'package:budget_rosneft/menuPages/types.dart';
import 'package:budget_rosneft/menuPages/categories.dart';
import 'package:budget_rosneft/pages/transactions.dart';

import 'mapPages/mapDBpage.dart';
import 'menuPages/map.dart';

void main() async {
  runApp(MaterialApp(
    // Удалить баннер отладки
    debugShowCheckedModeBanner: false,
    title: 'Семейный бюджет',
    theme: ThemeData(
      primaryColor: Colors.blueAccent,
    ),
    initialRoute: '/',
    routes: {
      '/': (context) => MainScreen(),
      '/types': (context) => Types(),
      '/categories': (context) => Categories(),
      '/statistics' : (context) => Statistics(),
      '/returnPDF' : (context) => returnPDF(),
      '/exchangerate': (context) => ExchangeRate(),
      '/mapLesson': (context) => MapLesson(),
      '/mapDB': (context) => MapDB(),
    },
  ));
}


from PyQt5 import uic
from PyQt5.QtWidgets import QDialog, QPushButton, QLabel

FORM_CLASS, _ = uic.loadUiType(os.path.join(os.path.dirname(__file__), 'distance_calculator_dialog_base.ui'))


class DistanceCalculatorDialog(QDialog, FORM_CLASS):
    def __init__(self, parent=None):
        super(DistanceCalculatorDialog, self).__init__(parent)
        self.setupUi(self)
        self.calculateButton = self.findChild(QPushButton, 'calculateButton')
        self.resultLabel = self.findChild(QLabel, 'resultLabel')
