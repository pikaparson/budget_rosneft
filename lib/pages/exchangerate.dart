import 'package:flutter/material.dart';

class ExchangeRate extends StatelessWidget {
  const ExchangeRate({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.blueGrey[400],
      appBar: AppBar(
        title: Text('Курс валют'),
        centerTitle: true,
        backgroundColor: Colors.blueGrey[700],
      ),
    );
  }
}