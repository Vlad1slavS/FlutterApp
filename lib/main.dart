import 'package:flutter/material.dart';
import 'package:file_picker/file_picker.dart';
import 'dart:io';
import 'logic/number_summer.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Суммирование чисел',
      home: SumNumbersScreen(),
    );
  }
}

class SumNumbersScreen extends StatefulWidget {
  @override
  _SumNumbersScreenState createState() => _SumNumbersScreenState();
}

class _SumNumbersScreenState extends State<SumNumbersScreen> {
  String _result = '';

  Future<void> _pickAndProcessFile() async {
    // Выбираем текстовый файл
    FilePickerResult? result = await FilePicker.platform.pickFiles(
      type: FileType.custom,
      allowedExtensions: ['txt'],
    );
    
    if (result != null) {
      String? filePath = result.files.single.path;
      if (filePath != null) {
        File file = File(filePath);
        String content = await file.readAsString();

        // Используем класс NumberSummer для суммирования чисел
        SumResult sumResult = NumberSummer.sumNumbers(content);

        // Если обнаружены нечисловые токены, показываем предупреждение
        if (sumResult.ignoredWords) {
          final MaterialBanner banner = MaterialBanner(
            content: DataTable(
              columns: [
                DataColumn(label: Text("Сообщение")),
              ],
              rows: [
                DataRow(cells: [
                  DataCell(Text("В вашем файле встречаются слова.\nОни будут не учтены в сумме."))
                ]),
              ],
            ),
            actions: [
              TextButton(
                onPressed: () {
                  ScaffoldMessenger.of(context).hideCurrentMaterialBanner();
                },
                child: Text("OK"),
              )
            ],
          );
          ScaffoldMessenger.of(context).showMaterialBanner(banner);
          Future.delayed(Duration(seconds: 3), () {
            ScaffoldMessenger.of(context).hideCurrentMaterialBanner();
          });
        }

        setState(() {
          _result = 'Сумма чисел: ${sumResult.sum}';
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Суммирование чисел'),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            ElevatedButton(
              onPressed: _pickAndProcessFile,
              child: Text('Выбрать файл'),
            ),
            SizedBox(height: 20),
            Text(
              _result,
              style: TextStyle(fontSize: 20),
            ),
          ],
        ),
      ),
    );
  }
}
