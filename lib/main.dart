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


плагин
  from qgis.PyQt.QtCore import *
from qgis.PyQt.QtWidgets import *
from qgis.core import *
from qgis.utils import iface
import math

class DistanceCalculatorPlugin:

    def __init__(self, iface):
        self.iface = iface
        self.action = QAction("Calculate Distance", self.iface.mainWindow())
        self.action.triggered.connect(self.run)
        self.selectedPoints = []

    def initGui(self):
        self.iface.addPluginToMenu("Calculate Distance", self.action)
        self.iface.addToolBarIcon(self.action)

    def unload(self):
        self.iface.removePluginMenu("Calculate Distance", self.action)
        self.iface.removeToolBarIcon(self.action)
    
    def run(self):
        self.dialog = DistanceCalculatorDialog(self.iface, self)
        self.dialog.show()

class DistanceCalculatorDialog(QDialog):

    def __init__(self, iface, plugin):
        QDialog.__init__(self)
        self.iface = iface
        self.plugin = plugin
        self.setWindowTitle("Calculate Distance")
        self.setGeometry(100, 100, 400, 200)

        self.layerComboBox1 = QComboBox()
        self.layerComboBox2 = QComboBox()
        self.load_layers()

        self.selectButton1 = QPushButton("Select First Point")
        self.selectButton2 = QPushButton("Select Second Point")
        self.calculateButton = QPushButton("Calculate Distance")
        self.calculateButton.setEnabled(False)

        self.selectButton1.clicked.connect(lambda: self.select_point(1))
        self.selectButton2.clicked.connect(lambda: self.select_point(2))
        self.calculateButton.clicked.connect(self.calculate_distance)

        layout = QVBoxLayout()
        layout.addWidget(QLabel("Select layer for first point:"))
        layout.addWidget(self.layerComboBox1)
        layout.addWidget(self.selectButton1)
        layout.addWidget(QLabel("Select layer for second point (can be the same):"))
        layout.addWidget(self.layerComboBox2)
        layout.addWidget(self.selectButton2)
        layout.addWidget(self.calculateButton)
        self.setLayout(layout)
    
    def load_layers(self):
        self.layerComboBox1.clear()
        self.layerComboBox2.clear()
        layers = QgsProject.instance().mapLayers().values()
        for layer in layers:
            if layer.type() == QgsMapLayer.VectorLayer and layer.geometryType() == QgsWkbTypes.PointGeometry:
                self.layerComboBox1.addItem(layer.name(), layer)
                self.layerComboBox2.addItem(layer.name(), layer)
    
    def select_point(self, point_number):
        layer = self.layerComboBox1.currentData() if point_number == 1 else self.layerComboBox2.currentData()
        
        if layer:
            self.iface.setActiveLayer(layer)
            self.iface.mapCanvas().setMapTool(self.iface.mapCanvas().mapToolSelect())
            self.iface.mapCanvas().mapToolSelect().selectionChanged.connect(lambda: self.point_selected(point_number))
    
    def point_selected(self, point_number):
        layer = self.layerComboBox1.currentData() if point_number == 1 else self.layerComboBox2.currentData()
        selected_features = layer.selectedFeatures()

        if len(selected_features) > 0:
            point = selected_features[0].geometry().asPoint()
            if point_number > len(self.plugin.selectedPoints):
                self.plugin.selectedPoints.append(point)
            else:
                self.plugin.selectedPoints[point_number - 1] = point
            
            if len(self.plugin.selectedPoints) == 2:
                self.calculateButton.setEnabled(True)
            
            self.iface.mapCanvas().mapToolSelect().selectionChanged.disconnect()

    def calculate_distance(self):
        if len(self.plugin.selectedPoints) == 2:
            point1 = self.plugin.selectedPoints[0]
            point2 = self.plugin.selectedPoints[1]
            distance = math.sqrt(math.pow(point2.x() - point1.x(), 2) + math.pow(point2.y() - point1.y(), 2))
            QMessageBox.information(self, "Distance", f"The distance between the points is {distance} units.")



инит

              def name():
    return "Distance Calculator"

def description():
    return "Plugin to calculate distance between two points in different layers"

def version():
    return "1.0"

def qgisMinimumVersion():
    return "3.0"

def classFactory(iface):
    from .distance_calculator import DistanceCalculatorPlugin
    return DistanceCalculatorPlugin(iface)
