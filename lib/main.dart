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


import os
from PyQt5.QtCore import QCoreApplication
from PyQt5.QtWidgets import QAction, QMessageBox
from qgis.core import QgsProject, QgsPointXY, QgsGeometry
from qgis.gui import QgsMapToolEmitPoint
from .distance_calculator_dialog import DistanceCalculatorDialog


class DistanceCalculator:
    def __init__(self, iface):
        self.iface = iface
        self.plugin_dir = os.path.dirname(__file__)
        self.toolbar = self.iface.addToolBar('DistanceCalculator')
        self.toolbar.setObjectName('DistanceCalculator')

        self.action = QAction('Calculate Distance', self.iface.mainWindow())
        self.action.triggered.connect(self.run)
        self.toolbar.addAction(self.action)

        self.canvas = self.iface.mapCanvas()
        self.tool = QgsMapToolEmitPoint(self.canvas)
        self.tool.canvasClicked.connect(self.display_point)

        self.points = []

    def initGui(self):
        pass

    def display_point(self, point, button):
        if len(self.points) < 2:
            self.points.append(point)
        if len(self.points) == 2:
            QMessageBox.information(self.iface.mainWindow(), 'Info', "Two points selected")

    def run(self):
        self.points = []
        self.canvas.setMapTool(self.tool)
        self.dialog = DistanceCalculatorDialog()
        self.dialog.calculateButton.clicked.connect(self.calculate_distance)
        self.dialog.show()

    def calculate_distance(self):
        if len(self.points) != 2:
            QMessageBox.warning(self.iface.mainWindow(), 'Error', 'Please select exactly two points.')
            return

        point1 = QgsPointXY(self.points[0].x(), self.points[0].y())
        point2 = QgsPointXY(self.points[1].x(), self.points[1].y())

        distance = point1.distance(point2)
        self.dialog.resultLabel.setText(f'Distance: {distance:.2f} units')

    def unload(self):
        self.toolbar.removeAction(self.action)


def classFactory(iface):
    return DistanceCalculator(iface)
 
