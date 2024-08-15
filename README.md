# budget_rosneft

A new Flutter project.

## Getting Started

This project is a starting point for a Flutter application.

A few resources to get you started if this is your first Flutter project:

- [Lab: Write your first Flutter app](https://docs.flutter.dev/get-started/codelab)
- [Cookbook: Useful Flutter samples](https://docs.flutter.dev/cookbook)

For help getting started with Flutter development, view the
[online documentation](https://docs.flutter.dev/), which offers tutorials,
samples, guidance on mobile development, and a full API reference.



distance_calculator.py

import os
from qgis.core import QgsPointXY, QgsGeometry, QgsProject
from qgis.utils import iface
from qgis.PyQt import QtCore, QtGui, QtWidgets
from qgis.gui import QgsMapToolEmitPoint

class DistanceCalculator(QtWidgets.QWidget):
    def __init__(self, parent=None):
        super().__init__(parent)
        self.initUI()

    def initUI(self):
        self.setWindowTitle("Расчет расстояния")

        layout = QtWidgets.QVBoxLayout()

        # Coordinate Labels
        self.coord1_label = QtWidgets.QLabel("Координаты точки 1: Не выбрана")
        self.coord2_label = QtWidgets.QLabel("Координаты точки 2: Не выбрана")
        layout.addWidget(self.coord1_label)
        layout.addWidget(self.coord2_label)

        # Distance Label
        self.distance_label = QtWidgets.QLabel("Расстояние: ")
        layout.addWidget(self.distance_label)

        # Calculate Button
        self.calc_button = QtWidgets.QPushButton("Рассчитать расстояние")
        self.calc_button.clicked.connect(self.calculate_distance)
        layout.addWidget(self.calc_button)

        self.setLayout(layout)

        self.point1 = None
        self.point2 = None

    def set_point1(self, point):
        self.point1 = point
        self.coord1_label.setText(f"Координаты точки 1: ({point.x()}, {point.y()})")

    def set_point2(self, point):
        self.point2 = point
        self.coord2_label.setText(f"Координаты точки 2: ({point.x()}, {point.y()})")

    def calculate_distance(self):
        if self.point1 and self.point2:
            geom1 = QgsGeometry.fromPointXY(QgsPointXY(self.point1))
            geom2 = QgsGeometry.fromPointXY(QgsPointXY(self.point2))
            distance = geom1.distance(geom2)
            self.distance_label.setText(f"Расстояние: {distance:.2f} метров")
        else:
            QtWidgets.QMessageBox.warning(self, "Ошибка", "Выберите две точки!")


class PointSelectionTool(QgsMapToolEmitPoint):
    pointSelected = QtCore.pyqtSignal(QgsPointXY)

    def __init__(self, canvas):
        super().__init__(canvas)
        self.canvas = canvas

    def canvasReleaseEvent(self, event):
        point = self.toMapCoordinates(event.pos())
        self.pointSelected.emit(point)


class DistanceCalculatorPlugin:
    def __init__(self, iface):
        self.iface = iface
        self.canvas = iface.mapCanvas()
        self.tool = PointSelectionTool(self.canvas)
        self.tool.pointSelected.connect(self.point_selected)
        self.calc_widget = None

    def initGui(self):
        self.action = QtWidgets.QAction("Расчет расстояния", self.iface.mainWindow())
        self.action.triggered.connect(self.run)
        self.iface.addPluginToMenu("&Distance Calculator", self.action)
        self.iface.addToolBarIcon(self.action)

    def unload(self):
        self.iface.removePluginMenu("&Distance Calculator", self.action)
        self.iface.removeToolBarIcon(self.action)

    def run(self):
        if not self.calc_widget:
            self.calc_widget = DistanceCalculator(parent=self.iface.mainWindow())
        self.calc_widget.show()
        self.calc_widget.raise_()

        # Set the map tool
        self.canvas.setMapTool(self.tool)

    def point_selected(self, point):
        if not self.calc_widget.point1:
            self.calc_widget.set_point1(point)
        elif not self.calc_widget.point2:
            self.calc_widget.set_point2(point)
            self.canvas.unsetMapTool(self.tool)
        else:
            QtWidgets.QMessageBox.warning(self.calc_widget, "Ошибка", "Вы уже выбрали две точки!")
            self.canvas.unsetMapTool(self.tool)


metadata.txt

    [general]
    name=DistanceCalculator
    qgisMinimumVersion=3.0
    author=Ваше имя
    email=ваш.email@example.com
    description=Плагин для расчета расстояния между двумя точками
    version=1.0

__init__.py
def classFactory(iface):  # выполняется при загрузке плагина
    from .distance_calculator_plugin import DistanceCalculatorPlugin
    return DistanceCalculatorPlugin(iface)

