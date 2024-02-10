import 'package:flutter/material.dart';

class Types extends StatefulWidget {
  const Types({super.key});

  @override
  State<Types> createState() => _TypesState();
}

class _TypesState extends State<Types> {

  List todoList = [];

  late String _userToDo;

  @override
  void initState() {
    super.initState();

    todoList.addAll(['Приход', 'Расход', 'Подарок кому-либо']);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.blueGrey[400],
      appBar: AppBar(
        backgroundColor: Colors.blueGrey[700],
        title: Text('Типы транзакций'),
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
                                //todoList.add(_userToDo);
                              });
                              showDialog(
                                  context: context,
                                  builder: (BuildContext context) {
                                    return AlertDialog(
                                      title: Text('Этот тип увеличивает бюджет?'),
                                      actions: [
                                        ElevatedButton(
                                            onPressed: () {
                                              Navigator.of(context).pop();//НЕ ВСЕ ОКНА
                                              },
                                            child: Text('Да')),
                                        ElevatedButton(
                                            onPressed: () {
                                              Navigator.of(context).pop();
                                            },
                                            child: Text('Нет')),
                                        ElevatedButton(
                                            onPressed: () {
                                              Navigator.of(context).pop();
                                            },
                                            child: Text('Отмена'))
                                      ],
                                    );
                                  });
                            },
                            child: Text('Продолжить')),
                        ElevatedButton(
                            onPressed: () {
                              Navigator.of(context).pop(); //закрывает все всплывающие окна
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
