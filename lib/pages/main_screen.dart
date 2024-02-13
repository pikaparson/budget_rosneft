import 'package:budget_rosneft/pages/transactions.dart';
import 'package:flutter/material.dart';
import 'package:budget_rosneft/pages/menu.dart';
import 'package:budget_rosneft/pages/exchangerate.dart';
import 'package:budget_rosneft/pages/budget.dart';


class MainScreen extends StatefulWidget {
  const MainScreen({super.key});

  @override
  State<MainScreen> createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> {

  var _currentPage = 0;

 // var _pages = [
 //   Text('1. Транзакции'),
  //  Text('2. Курс валют'),
 //   Text('3. Меню'),
 // ];

  final List<Widget> _pages = [
    Statistics(),
    ExchangeRate(),
    Menu(),
  ];

    @override
    Widget build(BuildContext context) {
      return Scaffold(
        backgroundColor: Colors.blueGrey[200],
        body: Center(
          child: _pages.elementAt(_currentPage),
        ),

        bottomNavigationBar: BottomNavigationBar(
          items: [
            BottomNavigationBarItem(
              backgroundColor: Colors.blueGrey[200],
              icon: Icon(Icons.format_list_numbered),
              label: 'Транзакции',
            ),
            BottomNavigationBarItem(
                backgroundColor: Colors.blueGrey[200],
                icon: Icon(Icons.monetization_on_outlined),
                label: 'Курс валют'
            ),
            BottomNavigationBarItem(
                backgroundColor: Colors.blueGrey[200],
                icon: Icon(Icons.menu_open_outlined),
                label: 'Меню'
            ),
          ],
          currentIndex: _currentPage,
          fixedColor: Colors.blueGrey[800],
          onTap: (int intIndex) {
            setState(() {
              _currentPage = intIndex;
            });
          }),
      );
    }
  }

