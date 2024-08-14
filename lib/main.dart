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




from qgis.PyQt.QtCore import *
from qgis.PyQt.QtWidgets import *
from qgis.core import *
from qgis.utils import iface

class DistanceCalculatorPlugin:

    def __init__(self, iface):
        self.iface = iface
        self.action = QAction("Calculate Distance", self.iface.mainWindow())
        self.action.triggered.connect(self.run)

    def initGui(self):
        self.iface.addPluginToMenu("Calculate Distance", self.action)
        self.iface.addToolBarIcon(self.action)

    def unload(self):
        self.iface.removePluginMenu("Calculate Distance", self.action)
        self.iface.removeToolBarIcon(self.action)
    
    def run(self):
        self.dialog = DistanceCalculatorDialog(self.iface)
        self.dialog.show()

class DistanceCalculatorDialog(QDialog):

    def __init__(self, iface):
        QDialog.__init__(self)
        self.iface = iface
        self.setWindowTitle("Calculate Distance")
        self.setGeometry(100, 100, 300, 100)

        self.layerComboBox1 = QComboBox()
        self.layerComboBox2 = QComboBox()
        self.pointComboBox1 = QComboBox()
        self.pointComboBox2 = QComboBox()
        
        self.calculateButton = QPushButton("Calculate Distance")
        self.calculateButton.clicked.connect(self.calculate_distance)

        layout = QVBoxLayout()
        layout.addWidget(QLabel("Select layer for first point:"))
        layout.addWidget(self.layerComboBox1)
        layout.addWidget(QLabel("Select first point:"))
        layout.addWidget(self.pointComboBox1)
        layout.addWidget(QLabel("Select layer for second point:"))
        layout.addWidget(self.layerComboBox2)
        layout.addWidget(QLabel("Select second point:"))
        layout.addWidget(self.pointComboBox2)
        layout.addWidget(self.calculateButton)
        
        self.setLayout(layout)

        self.populate_layers()
        self.layerComboBox1.currentIndexChanged.connect(self.populate_points1)
        self.layerComboBox2.currentIndexChanged.connect(self.populate_points2)
    
    def populate_layers(self):
        layers = [layer for layer in QgsProject.instance().mapLayers().values() if isinstance(layer, QgsVectorLayer) and layer.geometryType() == QgsWkbTypes.PointGeometry]
        for layer in layers:
            self.layerComboBox1.addItem(layer.name(), layer)
            self.layerComboBox2.addItem(layer.name(), layer)
        
    def populate_points1(self):
        self.pointComboBox1.clear()
        layer = self.layerComboBox1.currentData()
        if layer:
            features = layer.getFeatures()
            for feature in features:
                self.pointComboBox1.addItem(str(feature.id()), feature.geometry().asPoint())
    
    def populate_points2(self):
        self.pointComboBox2.clear()
        layer = self.layerComboBox2.currentData()
        if layer:
            features = layer.getFeatures()
            for feature in features:
                self.pointComboBox2.addItem(str(feature.id()), feature.geometry().asPoint())
    
    def calculate_distance(self):
        point1 = self.pointComboBox1.currentData()
        point2 = self.pointComboBox2.currentData()
        if point1 and point2:
            distance = point1.distance(point2)
            QMessageBox.information(self, "Distance", f"Distance: {distance:.2f} meters")
        else:
            QMessageBox.warning(self, "Error", "Please select both points")

def classFactory(iface):
    return DistanceCalculatorPlugin(iface)
