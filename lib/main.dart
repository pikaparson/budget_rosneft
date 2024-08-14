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


__init__.py:def classFactory(iface):
from .DISTANCE_CALCULATOR import DistanceCalculatorPlugin
return DistanceCalculatorPlugin(iface)
DISTANCE_CALCULATOR.py:from qgis.core import QgsProject, QgsPointXY, QgsFeature
from qgis.gui import QgsMapCanvas
from qgis.PyQt.QtWidgets import QAction, QMessageBox
from .DISTANCE_CALCULATOR_dialog import DistanceCalculatorDialog
class DistanceCalculatorPlugin:
def __init__(self, iface):
self.iface = iface
self.canvas = iface.mapCanvas()
self.dlg = None
def initGui(self):
icon_path = ':/plugins/distance_calculator/icon.png'
self.action = QAction('Calculate Distance', self.iface.mainWindow())
self.action.triggered.connect(self.run)
self.iface.addToolBarIcon(self.action)
self.iface.addPluginToMenu('Distance Calculator', self.action)
def unload(self):
self.iface.removePluginMenu('Distance Calculator', self.action)
self.iface.removeToolBarIcon(self.action)
def run(self):
if self.dlg is None:
  self.dlg = DistanceCalculatorDialog()
  self.dlg.calculateButton.clicked.connect(self.calculate_distance)
self.dlg.show()
self.dlg.exec_()
def calculate_distance(self):
selected_features = self.get_selected_features()
if len(selected_features) != 2:
QMessageBox.warning(self.dlg, "Ошибка", "Пожалуйста, выберите ровно две точки.")
return
point1 = selected_features[0].geometry().asPoint()
point2 = selected_features[1].geometry().asPoint()
distance = point1.distance(point2)
self.dlg.resultLabel.setText(f"Расстояние: {distance:.2f} метров")
def get_selected_features(self):
        layers = QgsProject.instance().mapLayers().values()
        selected_features = []
        for layer in layers:
            if layer.selectedFeatureCount() > 0:
                selected_features.extend(layer.selectedFeatures())
        return selected_features

DISTANCE_CALCULATOR_dialog.py
from qgis.PyQt import QtWidgets, uic
import os

FORM_CLASS, _ = uic.loadUiType(os.path.join(
    os.path.dirname(__file__), 'DISTANCE_CALCULATOR_dialog_base.ui'))

class DistanceCalculatorDialog(QtWidgets.QDialog, FORM_CLASS):
    def __init__(self, parent=None):
        super(DistanceCalculatorDialog, self).__init__(parent)
        self.setupUi(self)

DISTANCE_CALCULATOR_dialog_base.ui
<?xml version="1.0" encoding="UTF-8"?>
<ui version="4.0">
    <class>DistanceCalculatorDialogBase</class>
    <widget class="QDialog" name="DistanceCalculatorDialogBase">
        <property name="geometry">
            <rect>
                <x>0</x>
                <y>0</y>
                <width>400</width>
                <height>300</height>
            </rect>
        </property>
        <property name="windowTitle">
            <string>Distance Calculator</string>
        </property>
        <layout class="QVBoxLayout" name="verticalLayout">
            <item>
                <widget class="QWidget" name="formLayoutWidget">
                    <layout class="QFormLayout" name="formLayout">
                        <property name="fieldGrowthPolicy">
                            <enum>QFormLayout::AllNonFixedFieldsGrow</enum>
                        </property>
                        
                        <item row="0" column="0">
                            <widget class="QLabel" name="labelPoint1">
                                <property name="text">
                                    <string>Point 1 Coordinates</string>
                                </property>
                            </widget>
                        </item>
                        <item row="0" column="1">
                            <widget class="QLineEdit" name="lineEditPoint1">
                                <property name="placeholderText">
                                    <string>format: x,y</string>
                                </property>
                            </widget>
                        </item>
                        
                        <item row="1" column="0">
                            <widget class="QLabel" name="labelPoint2">
                                <property name="text">
                                    <string>Point 2 Coordinates</string>
                                </property>
                            </widget>
                        </item>
                        <item row="1" column="1">
                            <widget class="QLineEdit" name="lineEditPoint2">
                                <property name="placeholderText">
                                    <string>format: x,y</string>
                                </property>
                            </widget>
                        </item>
                        
                        <item row="2" column="0" colspan="2">
                            <layout class="QHBoxLayout" name="horizontalLayout">
                                <property name="spacing">
                                    <number>6</number>
                                </property>
                                <property name="sizeConstraint">
                                    <enum>QLayout::SetDefaultConstraint</enum>
                                </property>
                                <item>
                                    <spacer name="horizontalSpacer">
                                        <property name="orientation">
                                            <enum>Qt::Horizontal</enum>
                                        </property>
                                        <property name="sizeType">
                                            <enum>QSizePolicy::Expanding</enum>
                                        </property>
                                        <property name="minimumSize">
                                            <size>
                                                <width>20</width>
                                                <height>20</height>
                                            </size>
                                        </property>
                                    </spacer>
                                </item>
                                <item>
                                    <widget class="QPushButton" name="buttonCalculate">
                                        <property name="text">
                                            <string>Calculate</string>
                                        </property>
                                    </widget>
                                </item>
                                <item>
                                    <spacer name="horizontalSpacer_2">
                                        <property name="orientation">
                                            <enum>Qt::Horizontal</enum>
                                        </property>
                                        <property name="sizeType">
                                            <enum>QSizePolicy::Expanding</enum>
                                        </property>
                                        <property name="minimumSize">
                                            <size>
                                                <width>20</width>
                                                <height>20</height>
                                            </size>
                                        </property>
                                    </spacer>
                                </item>
                            </layout>
                        </item>
                        <item row="3" column="0" colspan="2">
                            <widget class="QLabel" name="labelResult">
                                <property name="text">
                                    <string/>
                                </property>
                                <property name="alignment">
                                    <set>Qt::AlignCenter</set>
                                </property>
                            </widget>
                        </item>
                    </layout>
                </widget>
            </item>
        </layout>
    </widget>
    <resources/>
    <connections/>
</ui> 
