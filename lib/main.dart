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


инит 
  
def classFactory(iface):
    from .plugin import DistanceCalculatorPlugin
    return DistanceCalculatorPlugin(iface)
плагин
      import os
from qgis.core import QgsPointXY, QgsWkbTypes, QgsProject
from qgis.utils import iface
from PyQt5.QtWidgets import QAction, QMessageBox, QFileDialog, QDialog
from PyQt5.QtGui import QIcon
from PyQt5.uic import loadUi

class DistanceCalculatorPlugin:
    def __init__(self, iface):
        self.iface = iface
        self.canvas = iface.mapCanvas()
        self.plugin_dir = os.path.dirname(__file__)
        self.first_point = None
        self.second_point = None
        
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
        self.dlg = DistanceCalculatorDialog(self.iface)
        self.dlg.show()
форма диалога
<ui version="4.0">
 <class>DistanceCalculatorDialog</class>
 <widget class="QDialog" name="DistanceCalculatorDialog">
  <property name="geometry">
   <rect>
    <x>0</x>
    <y>0</y>
    <width>400</width>
    <height>200</height>
   </rect>
  </property>
  <property name="windowTitle">
   <string>Distance Calculator</string>
  </property>
  <layout class="QVBoxLayout" name="verticalLayout">
   <item>
    <widget class="QPushButton" name="selectFirstPointButton">
     <property name="text">
      <string>Select First Point</string>
     </property>
    </widget>
   </item>
   <item>
    <widget class="QPushButton" name="selectSecondPointButton">
     <property name="text">
      <string>Select Second Point</string>
     </property>
    </widget>
   </item>
   <item>
    <widget class="QPushButton" name="calculateButton">
     <property name="text">
      <string>Calculate Distance</string>
     </property>
    </widget>
   </item>
   <item>
    <widget class="QLabel" name="resultLabel">
     <property name="text">
      <string>Result: </string>
     </property>
    </widget>
   </item>
  </layout>
 </widget>
 <resources/>
 <connections/>
</ui>

файл
 from PyQt5 import QtWidgets, uic
from qgis.gui import QgsMapToolEmitPoint
from qgis.core import QgsPointXY, QgsProject, QgsCoordinateReferenceSystem, QgsCoordinateTransform, QgsGeometry

FORM_CLASS, _ = loadUiType(os.path.join(
    os.path.dirname(__file__), 'ui_form.ui'))


class DistanceCalculatorDialog(QtWidgets.QDialog, FORM_CLASS):
    def __init__(self, iface, parent=None):
        super(DistanceCalculatorDialog, self).__init__(parent)
        self.iface = iface
        self.canvas = iface.mapCanvas()
        self.setupUi(self)
        self.selectFirstPointButton.clicked.connect(self.select_first_point)
        self.selectSecondPointButton.clicked.connect(self.select_second_point)
        self.calculateButton.clicked.connect(self.calculate_distance)
        
        self.first_point_tool = QgsMapToolEmitPoint(self.canvas)
        self.second_point_tool = QgsMapToolEmitPoint(self.canvas)
        self.first_point = None
        self.second_point = None
        
    def select_first_point(self):
        self.canvas.setMapTool(self.first_point_tool)
        self.first_point_tool.canvasClicked.connect(self.set_first_point)
        
    def set_first_point(self, point, button):
        self.first_point = point
        
    def select_second_point(self):
        self.canvas.setMapTool(self.second_point_tool)
        self.second_point_tool.canvasClicked.connect(self.set_second_point)
        
    def set_second_point(self, point, button):
        self.second_point = point
    
    def calculate_distance(self):
        if not self.first_point or not self.second_point:
            QMessageBox.warning(self, 'Warning', 'Please select both points first.')
            return
        
        distance = self.calculate_geographic_distance(self.first_point, self.second_point)
        self.resultLabel.setText(f'Result: {distance:.2f} meters')
    
    def calculate_geographic_distance(self, point1, point2):
        layer = self.iface.activeLayer()
        crs_layer = layer.crs()
        crs_dest = QgsCoordinateReferenceSystem(4326)  # WGS 84
        
        transform_context = QgsProject.instance().transformContext()
        xform = QgsCoordinateTransform(crs_layer, crs_dest, transform_context)
        
        point1_geo = xform.transform(point1)
        point2_geo = xform.transform(point2)
        
        return QgsGeometry().fromPointXY(QgsPointXY(point1_geo)).distance(QgsGeometry().fromPointXY(QgsPointXY(point2_geo)))
