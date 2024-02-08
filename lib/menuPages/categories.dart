import 'package:flutter/material.dart';

class Categories extends StatefulWidget {
  const Categories({super.key});

  @override
  State<Categories> createState() => _CategoriesState();
}

class _CategoriesState extends State<Categories> {

  List todoList = [];

  late String _userToDo;

  @override
  void initState() {
    super.initState();

    todoList.addAll(['Зарплата', 'Покупка продуктов', 'Подарок подруге']);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.blueGrey[400],
      appBar: AppBar(
        backgroundColor: Colors.blueGrey[700],
        title: Text('Категории транзакций'),
        centerTitle: true,
      ),
      body: ListView.builder(
        itemCount: todoList.length,
        itemBuilder: (BuildContext context, int index) {
          return Dismissible(
            key: Key(todoList[index]),
            child: Card(
              child: ListTile(
                title: Text(todoList[index]),
                trailing: IconButton(
                    onPressed: () {
                      setState(() {
                        todoList.removeAt(index);
                      });
                    },
                    icon: Icon(
                      Icons.delete_outline,
                      color: Colors.blueAccent,
                    )
                ),
              ),
            ),
            onDismissed: (direction) {
              if (direction == DismissDirection.endToStart || direction == DismissDirection.startToEnd) {
                setState(() {
                  todoList.removeAt(index);
                });
              }
            },
          );
        },
      ),

      floatingActionButton: FloatingActionButton (
          onPressed: () {
            showDialog(
                context: context, //context - страничка, на которой мы все выполняем
                builder: (BuildContext context) { //как функция
                  return AlertDialog(
                      title: Text('Добавить дело'),
                      content: TextField( // ввод инфы пользователем
                        onChanged: (String value) {
                          _userToDo = value; // без setstate, т.к. пользователю инфа не видна
                        }, // срабатывает при вводе инфы
                      ),
                      actions: [ // добавим кнопки, с помощью массива будет легче
                        ElevatedButton(
                            onPressed: () {
                              setState(() {
                                todoList.add(_userToDo);
                              });
                              Navigator.of(context).pop(); //закрывает все вспоывающие окна
                            },
                            child: Text('Добавить')),
                        ElevatedButton(
                            onPressed: () {
                              Navigator.of(context).pop(); //закрывает все вспоывающие окна
                            },
                            child: Text('Отмена')),
                      ]
                  );
                });
          },
          child: Icon(
            Icons.add_box,
            color: Colors.blueGrey[600],
          )
      ),

    );
  }
}
