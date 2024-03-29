import 'package:flutter/material.dart';
import 'package:budget_rosneft/DataBase/DB_create.dart';

class Types extends StatefulWidget {
  const Types({Key? key}) : super(key: key);

  @override
  State<Types> createState() => _TypesState();
}

class _TypesState extends State<Types> {
  // Все журналы
  List<Map<String, dynamic>> _journals = [];
  bool _isLoading = true;

  // Эта функция используется, чтобы выгрузить все данные из БД
  void _refreshJournals() async {
    final data = await SQLHelper().getItemsType();
    setState(() {
      if(data != null)
        {
          _journals = data;
        }
      _isLoading = false;
    });
  }

  @override
  void initState() {
    super.initState();
    _refreshJournals(); //  загрузка журнала в начале программы
  }

  int profitOrNot = 0;
  final TextEditingController _nameController = TextEditingController();

  // Эта функция будет активирована при нажатии floatingActionB
  // Она также будет активирована, когда обновляем элемент
  void _showForm(int? id) async {
    if (id != null) {
      // id == null -> create new item
      // id != null -> update an existing item
      final existingJournal =
      _journals.firstWhere((element) => element['id'] == id);
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
                //keyboardType: TextInputType.text,
                decoration: const InputDecoration(hintText: 'Названите типа'),
              ),
              // коробка с отступом
              const SizedBox(
                height: 20,
                child: Text('Данный тип добавляет деньги в бюджет?')
              ),
              //добавление нового или обновление объекта
              ElevatedButton(
                onPressed: () async {
                  profitOrNot = 1;
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
                child: Text('Да', style: TextStyle(color: Colors.black)),
              ),
              const SizedBox(
                  height: 5,
              ),
              ElevatedButton(
                onPressed: () async {
                  profitOrNot = 0;
                  if (id == null) {
                    await _addItem();
                  }
                  if (id != null) {
                    await _updateItem(id);
                  }
                  // Очистим поле
                  _nameController.text = '';
                  // закрываем шторку
                  if (!mounted) return;
                  Navigator.of(context).pop();
                },
                child: Text('Нет', style: TextStyle(color: Colors.black)),
              ),const SizedBox(
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
    await SQLHelper().createItemType(
        _nameController.text, profitOrNot);
    _refreshJournals();
  }

  // Обновить существующий журнал
  Future<void> _updateItem(int id) async {
    await SQLHelper().updateItemType(
        id, _nameController.text, profitOrNot);
    _refreshJournals();
  }

  // Удалить объект
  void _deleteItem(int id) async {
    await SQLHelper().deleteItemType(id);
    ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
      content: Text('Successfully deleted a journal!'),
    ));
    _refreshJournals();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.blueGrey[200],
      appBar: AppBar(
        title: const Text('Типы транзакции'),
        backgroundColor: Colors.blueGrey[400],
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
              subtitle: Text(_journals[index]['profit'] == 1 ? 'Увеличивает бюджет' : 'Уменьшает бюджет'),
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
