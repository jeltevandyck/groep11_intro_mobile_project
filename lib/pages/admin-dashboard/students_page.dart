import 'dart:convert';
import 'dart:io';

import 'package:csv/csv.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class StudentsPage extends StatefulWidget {
  const StudentsPage({Key? key}) : super(key: key);

  @override
  State<StudentsPage> createState() => _StudentsPageState();
}

class _StudentsPageState extends State<StudentsPage> {

  List<List<dynamic>> data = [];

  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      body: Text("test students"),
    );
  }

  Widget ShowTable(){
    loadAsset("csv/testData.csv");
    return Text("data");
  }

  loadAsset(filePath) async {
    final myData = await rootBundle.loadString(filePath);
    List<List<dynamic>> csvTable = const CsvToListConverter().convert(myData);
    data = csvTable;
  }
}
