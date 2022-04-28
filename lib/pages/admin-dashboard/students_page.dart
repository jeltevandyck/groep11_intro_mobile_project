import 'package:flutter/material.dart';

class StudentsPage extends StatefulWidget {
  const StudentsPage({Key? key}) : super(key: key);

  @override
  State<StudentsPage> createState() => _StudentsPageState();
}

class _StudentsPageState extends State<StudentsPage> {
  int currentindex=0;
  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      body: Text("test students"),
    );
  }
}
