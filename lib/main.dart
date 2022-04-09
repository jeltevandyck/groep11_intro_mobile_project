import 'package:flutter/material.dart';


import 'pages/admin_login_page.dart';
import 'pages/student_login_page.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Login page',
      theme: ThemeData(
        primarySwatch: Colors.red
      ),
      home: const StudentLoginPage(),
    );
  }
}
