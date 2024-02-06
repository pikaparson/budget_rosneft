import 'package:flutter/material.dart';

class Budget extends StatelessWidget {
  const Budget({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.blueGrey[400],
      appBar: AppBar(
        title: Text('Бюджет'),
        centerTitle: true,
        backgroundColor: Colors.blueGrey[700],
      ),
    );
  }
}
