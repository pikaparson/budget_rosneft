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
from qgis.core import QgsPointXY, QgsWkbTypes, QgsProject, QgsFeature
from qgis.utils import iface
from qgis.gui import QgsMapToolEmitPoint
from PyQt5.QtWidgets import QAction, QDialog, QVBoxLayout, QLabel, QPushButton
from PyQt5.QtGui import QIcon
from PyQt5.uic import loadUi


class DistanceCalculatorPlugin:
    def __init__(self, iface):
        self.iface = iface
        self.canvas = iface.mapCanvas()
        self.plugin_dir = os.path.dirname(__file__)
        self.first_point = None
        self.second_point = None
        self.mapTool = None
        self.dialog = None

    def initGui(self):
        icon_path = os.path.join(self.plugin_dir, 'icon.png')
        self.action = QAction(QIcon(icon_path), 'Calculate Distance', self.iface.mainWindow())
        self.action.triggered.connect(self.run)
        self.iface.addToolBarIcon(self.action)
        self.iface.addPluginToMenu('Calculate Distance', self.action)

    def unload(self):
        self.iface.removeToolBarIcon(self.action)
        self.iface.removePluginMenu('Calculate Distance', self.action)

    def run(self):
        # Создаем и показываем диалог
        self.dialog = DistanceCalculatorDialog(self.iface)
        self.dialog.selectFirstPointButton.clicked.connect(self.select_first_point)
        self.dialog.selectSecondPointButton.clicked.connect(self.select_second_point)
        self.dialog.show()

    def select_first_point(self):
        self.mapTool = QgsMapToolEmitPoint(self.canvas)
        self.canvas.setMapTool(self.mapTool)
        self.mapTool.canvasClicked.connect(self.set_first_point)

    def set_first_point(self, point):
        self.first_point = point
        self.dialog.firstPointLabel.setText(f'First Point: {point.x()}, {point.y()}')
        self.reset_map_tool()

    def select_second_point(self):
        self.mapTool = QgsMapToolEmitPoint(self.canvas)
        self.canvas.setMapTool(self.mapTool)
        self.mapTool.canvasClicked.connect(self.set_second_point)

    def set_second_point(self, point):
        self.second_point = point
        self.dialog.secondPointLabel.setText(f'Second Point: {point.x()}, {point.y()}')
        self.reset_map_tool()
        self.calculate_distance()

    def calculate_distance(self):
        if self.first_point and self.second_point:
            distance = self.first_point.distance(self.second_point)
            self.dialog.resultLabel.setText(f'Distance: {distance} map units')

    def reset_map_tool(self):
        self.canvas.unsetMapTool(self.mapTool)
        self.mapTool.deleteLater()
        self.mapTool = None


class DistanceCalculatorDialog(QDialog):
    def __init__(self, iface, parent=None):
        super().__init__(parent)
        self.iface = iface
        self.setWindowTitle('Distance Calculator')
        self.setGeometry(100, 100, 200, 150)

        layout = QVBoxLayout()

        self.firstPointLabel = QLabel('First Point: Not Set')
        layout.addWidget(self.firstPointLabel)

        self.selectFirstPointButton = QPushButton('Select First Point')
        layout.addWidget(self.selectFirstPointButton)

        self.secondPointLabel = QLabel('Second Point: Not Set')
        layout.addWidget(self.secondPointLabel)

        self.selectSecondPointButton = QPushButton('Select Second Point')
        layout.addWidget(self.selectSecondPointButton)

        self.resultLabel = QLabel('Distance: N/A')
        layout.addWidget(self.resultLabel)

        self.setLayout(layout)
