import 'package:flutter/material.dart';

class Statistics extends StatefulWidget {
  const Statistics({super.key});

  @override
  State<Statistics> createState() => _StatisticsState();
}

class _StatisticsState extends State<Statistics> {

  List todoList = [];

  late String _userToDo;

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.blueGrey[400],
      appBar: AppBar(
        backgroundColor: Colors.blueGrey[700],
        title: Text('Cтатистика транзакций'),
        centerTitle: true,
      ),
      body: Text('Здесь будет общий доход, расход и баланс'),
    );
  }
}
