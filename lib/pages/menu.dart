import 'package:flutter/material.dart';
import 'package:budget_rosneft/DataBase/returnPDF.dart';

class Menu extends StatelessWidget {
  const Menu({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.blueGrey[400],
      appBar: AppBar(
        title: Text('Меню'),
        centerTitle: true,
        backgroundColor: Colors.blueGrey[700],
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            ElevatedButton(
              onPressed: () {
                Navigator.pushNamedAndRemoveUntil(context, '/types', (route) => true);
              },
              child: Text('Типы транзакций', style: TextStyle(fontSize: 12, color: Colors.blueGrey[800]),),
            ),

            //  SizedBox(height: 10),

            ElevatedButton(
              onPressed: () {
                Navigator.pushNamedAndRemoveUntil(context, '/categories', (route) => true);
              },
              child: Text('Категория', style: TextStyle(fontSize: 12, color: Colors.blueGrey[800])),
            ),

            //   SizedBox(height: 10),

            ElevatedButton(
              onPressed: () {
                Navigator.pushNamedAndRemoveUntil(context, '/returnPDF', (route) => true);
              },
              child: Text('Вывести статистику в pdf', style: TextStyle(fontSize: 12, color: Colors.blueGrey[800])),
            ),

            // SizedBox(height: 10),

            ElevatedButton(
              onPressed: () {
                Navigator.pushNamedAndRemoveUntil(context, '/mapLesson', (route) => true);
              },
              child: Text('Карта', style: TextStyle(fontSize: 12, color: Colors.blueGrey[800])),
            ),
          ],
        ),
      )
    );
  }
}
