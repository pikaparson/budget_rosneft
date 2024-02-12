import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:budget_rosneft/DataBase/DB_create.dart';


//НЕ ДОБАВЛЯЕТ, НЕ ВЫДАЕТ ОШИБКУ

class Statistics extends StatelessWidget {
  const Statistics({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      // убирает баннер debug
        debugShowCheckedModeBanner: false,
        home: const StatisticsPage());
  }
}

class StatisticsPage extends StatefulWidget {
  const StatisticsPage({Key? key}) : super(key: key);

  @override
  State<StatisticsPage> createState() => _HomePageState();
}

class _HomePageState extends State<StatisticsPage> {
  // Все журналы
  List<Map<String, dynamic>> _journals = [];
  List<Map<String, dynamic>> _journalsCategory = [];

  bool _isLoading = true;
  // Эта функция используется, чтобы выгрузить все данные из БД
  void _refreshJournals() async {
    final data = await SQLHelper().getItemsTransaction();
    final dataCategory = await SQLHelper().getItemNamesCategory();
    setState(() {
      _journals = data!;
      _journalsCategory = dataCategory!;
      _isLoading = false;
    });
  }

  @override
  void initState() {
    super.initState();
    _refreshJournals(); //  загрузка журнала в начале программы
  }

  int transactionCategory = 1;
  final TextEditingController _nameController = TextEditingController();

  // Эта функция будет активирована при нажатии floatingActionB
  // Она также будет активирована, когда обновляем элемент
  void _showForm(int? id) async {
    if (id != null) {
      // id == null -> create new item
      // id != null -> update an existing item
      final existingJournal = _journals.firstWhere((element) => element['id'] == id);
      _nameController.text = existingJournal['name'];
    }
    // нижняя шторка для добавления объекта
    showModalBottomSheet(
        context: context,
        elevation: 5,
        isScrollControlled: true,
        backgroundColor: Colors.white,
        builder: (_) => Container(
          padding: EdgeInsets.only(
            top: 15,
            left: 15,
            right: 15,
            // это предотвратит закрытие текстовых полей программной клавиатурой
            bottom: MediaQuery.of(context).viewInsets.bottom + 120,
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              // поле для ввода имени
              TextField(
                controller: _nameController,
                decoration: const InputDecoration(hintText: 'Название транзакции'),
              ),
              // коробка с отступом
              const SizedBox(
                  height: 20,
                  child: Text('Выберите категорию')
              ),
              DropdownButton(
                  items: _journalsCategory.map((e) {
                    return DropdownMenuItem<int>(child: Text(e["name"]), value: e["id"],);
                  }).toList(),
                  onChanged: (t) {
                    transactionCategory = t!;
                  }),
              //добавление нового или обновление объекта
              ElevatedButton(
                onPressed: () async {
                  // Сохранение нового журнала
                  // Добавление объекта
                  if (id == null) {
                    await _addItem();
                  }
                  // Обновление объекта
                  if (id != null) {
                    await _updateItem(id);
                  }
                  // Очистим поле
                  _nameController.text = '';
                  // закрываем шторку
                  if (!mounted) return;
                  Navigator.of(context).pop();
                },
                child: Text('Добавить', style: TextStyle(color: Colors.black)),
              ),
              const SizedBox(
                height: 5,
              ),
              ElevatedButton(
                onPressed: () async {
                  Navigator.of(context).pop();
                },
                child: Text('Отмена', style: TextStyle(color: Colors.black)),
              ),
            ],
          ),
        ));
  }

// Вставить новый журнал в базу данных
  Future<void> _addItem() async {
    await SQLHelper().createItemCategories(
        _nameController.text, transactionCategory);
    _refreshJournals();
  }

  // Обновить существующий журнал
  Future<void> _updateItem(int id) async {
    await SQLHelper().updateItemCategories(
        id, _nameController.text, transactionCategory);
    _refreshJournals();
  }

  // Удалить объект
  void _deleteItem(int id) async {
    await SQLHelper().deleteItemCategories(id);
    ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
      content: Text('Successfully deleted a journal!'),
    ));
    _refreshJournals();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.blueGrey[400],
      appBar: AppBar(
        title: const Text('Транзакции'),
        backgroundColor: Colors.blueGrey[700],
        centerTitle: true,
      ),
      body: _isLoading
          ? const Center(
        child: CircularProgressIndicator(),
      )
          : ListView.builder(
        itemCount: _journals.length,
        itemBuilder: (context, index) => Card(
          color: Colors.white,
          margin: const EdgeInsets.all(15),
          child: ListTile(
              title: Text(_journals[index]['name']),
              subtitle: Text('${SQLHelper().getCategoryOfTransaction(_journals[index]['id'])}'),
              trailing: SizedBox(
                width: 100,
                child: Row(
                  children: [
                    IconButton(
                      icon: const Icon(Icons.edit),
                      onPressed: () => _showForm(_journals[index]['id']),
                    ),
                    IconButton(
                      icon: const Icon(Icons.delete),
                      onPressed: () =>
                          _deleteItem(_journals[index]['id']),
                    ),
                  ],
                ),
              )),
        ),
      ),
      floatingActionButton: FloatingActionButton(
        backgroundColor: Colors.white,
        child: const Icon(Icons.add),
        onPressed: () => _showForm(null),
      ),
    );
  }
}
