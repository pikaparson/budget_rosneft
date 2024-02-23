import 'dart:convert';
import 'dart:developer';
import 'dart:ffi';
import 'package:flutter/material.dart';
import 'package:dio/dio.dart';

import '../rateModel/model.dart';

class ExchangeRate extends StatefulWidget {
  const ExchangeRate({Key? key}) : super(key: key);

  @override
  State<ExchangeRate> createState() => _HomePageState();
}

class _HomePageState extends State<ExchangeRate> {

  List<AUD?> valueList = [];

  @override
  void initState() {
    getData();
  }

  void getData() async {
    try {
      var response = await Dio()
          .get('https://www.cbr-xml-daily.ru/daily_json.js');

      if (response.statusCode == 200) {
          final jsonList = MoneyModel.fromJson(jsonDecode(response.data));
          //проверка на null
          valueList.add(jsonList.valute?.uSD);
          valueList.add(jsonList.valute?.eUR);
          valueList.add(jsonList.valute?.kZT);
          valueList.add(jsonList.valute?.bYN);
          valueList.add(jsonList.valute?.cNY);
          valueList.add(jsonList.valute?.jPY);
          valueList.add(jsonList.valute?.kRW);
          valueList.add(jsonList.valute?.gEL);
          valueList.add(jsonList.valute?.gBP);
          valueList.add(jsonList.valute?.aED);
          setState(() {});
      } else {
        print(response.statusCode);
      }
    } catch (e) {
      print(e);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.blueGrey[200],
      appBar: AppBar(
        title: const Text('Курс валюты'),
        backgroundColor: Colors.blueGrey[400],
        centerTitle: true,
      ),
      body: ListView.builder(
          itemCount: valueList.length,
          itemBuilder: (BuildContext context, int index) {
            return Card(
              margin: const EdgeInsets.all(15),
              child: ListTile(
                title: Text('${valueList[index]!.name}', style: TextStyle(fontSize: 20),),
                subtitle: Text('${valueList[index]!.value}', style: TextStyle(fontSize: 18, color: Colors.grey[800]),),
              ),
            );
          }),
    );
  }
}