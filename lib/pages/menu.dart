import 'package:flutter/material.dart';
import 'package:budget_rosneft/menuPages/types.dart';

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
                Navigator.pushNamed(context, '/types');
              },
              child: Text('Типы транзакций', style: TextStyle(fontSize: 12, color: Colors.blueGrey[800]),),
            ),

            //  SizedBox(height: 10),

            ElevatedButton(
              onPressed: () {
                // Navigator.pushNamed(context, '/types');
              },
              child: Text('Категория', style: TextStyle(fontSize: 12, color: Colors.blueGrey[800])),
            ),

            //   SizedBox(height: 10),

            ElevatedButton(
              onPressed: () {
                //  Navigator.pushNamed(context, '/types');
              },
              child: Text('Статистика', style: TextStyle(fontSize: 12, color: Colors.blueGrey[800])),
            ),

            // SizedBox(height: 10),

            ElevatedButton(
              onPressed: () {
                //  Navigator.pushNamed(context, '/types');
              },
              child: Text('Об авторе', style: TextStyle(fontSize: 12, color: Colors.blueGrey[800])),
            ),
          ],
        ),
      )
    );
  }
}
