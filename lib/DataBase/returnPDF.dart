import 'dart:typed_data';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'dart:io';
import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart' as pw;
import 'package:path_provider/path_provider.dart';
import 'package:printing/printing.dart';

import 'package:budget_rosneft/DataBase/DB_create.dart';

class returnPDF extends StatelessWidget {
  const returnPDF({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
        title: 'Создать PDF',
        theme: ThemeData(
          useMaterial3: true,
        ),
        home: const MyStatefulWidget());
  }
}

class MyStatefulWidget extends StatefulWidget {
  const MyStatefulWidget({super.key});

  @override
  State<MyStatefulWidget> createState() => _MyStatefulWidgetState();
}

class _MyStatefulWidgetState extends State<MyStatefulWidget> {

  //КАК ПЕРЕДАТЬ ТЕКСТ, ЧТОБЫ БЫЛО ПО СТОЛБАМ? НУЖЕН ПОДЗАПРОС ДЛЯ ВЫВОДА НАЗВАНИЯ ТИПА


  Future<Uint8List> generatePdf() async {

    String textDB = '${await SQLHelper().getItemsTransaction()}';
    final font = await rootBundle.load("assets/russia.ttf");
    final ttf = pw.Font.ttf(font);

    final pdf = pw.Document();
    pdf.addPage(pw.Page(
        pageFormat: PdfPageFormat.a4,
        build: (pw.Context context) {
          return pw.Center(
            child: pw.Text(
              textDB,
              style: pw.TextStyle(fontSize: 16,font: ttf),
            ),
          ); // Center
        }));

    final output = await getTemporaryDirectory();
    final file = File("${output.path}/example.pdf");
    await file.writeAsBytes(await pdf.save());
    return pdf.save();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Создать PDF'),
      ),
      body: PdfPreview(
        build: (context) => generatePdf(),
      ),
    );
  }
}