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

метадата
[general]
name=DistanceCalculator
description=Плагин для расчета расстояния между двумя точками
version=0.1
qgisMinimumVersion=3.22
author=Ваше имя
email=ваш_email@example.com
category=Spatial Analysis

[python]
type=python

  инит
  def classFactory(iface):
    from .main import DistanceCalculator
    return DistanceCalculator(iface)

 маин
      from PyQt5 import QtWidgets
from qgis.core import QgsProject, QgsFeature
from qgis.gui import QgsMapToolEmitPoint
from qgis.PyQt.QtCore import Qt

class DistanceCalculator:
    def __init__(self, iface):
        self.iface = iface
        self.canvas = self.iface.mapCanvas()
        self.dlg = DistanceCalculatorDialog()
        self.points = []

        # Обработчики событий
        self.dlg.buttonCalculate.clicked.connect(self.calculate_distance)
        self.dlg.buttonSelect.clicked.connect(self.select_points)

    def show(self):
        self.dlg.show()
        self.dlg.raise_()
        self.dlg.activateWindow()

    def select_points(self):
        self.points = []
        self.tool = QgsMapToolEmitPoint(self.canvas)
        self.tool.canvasClicked.connect(self.add_point)
        self.canvas.setMapTool(self.tool)

    def add_point(self, point):
        self.points.append(point)
        if len(self.points) == 2:
            self.canvas.unsetMapTool(self.tool)

    def calculate_distance(self):
        if len(self.points) != 2:
            QtWidgets.QMessageBox.warning(self.dlg, "Ошибка", "Пожалуйста, выберите две точки.")
            return

        distance = self.points[0].distance(self.points[1])
        self.dlg.labelResult.setText(f"Расстояние: {distance:.2f} метров")

class DistanceCalculatorDialog(QtWidgets.QDialog):
    def __init__(self):
        super().__init__()
        self.setWindowTitle("Калькулятор расстояния")
        self.setGeometry(100, 100, 300, 150)

        # Элементы интерфейса
        self.buttonCalculate = QtWidgets.QPushButton("Расчитать расстояние", self)
        self.buttonCalculate.setGeometry(50, 70, 200, 30)

        self.buttonSelect = QtWidgets.QPushButton("Выбрать точки", self)
        self.buttonSelect.setGeometry(50, 30, 200, 30)

        self.labelResult = QtWidgets.QLabel("Расстояние: ", self)
        self.labelResult.setGeometry(50, 110, 200, 30)

ресоурс кср
 <RCC>
  <qresource prefix="/your_plugin">
  </qresource>
</RCC>


ресорс пай через баш
  pyrcc5 resources.qrc -o resources.py
