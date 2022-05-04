import 'package:flutter/material.dart';

import 'create_exam_page.dart';
import 'students_page.dart';

class AdminDashboardPage extends StatefulWidget {
  const AdminDashboardPage({ Key? key }) : super(key: key);

  @override
  State<AdminDashboardPage> createState() => _AdminDashboardPageState();
}

class _AdminDashboardPageState extends State<AdminDashboardPage> {

  int currentindex=0;
  final pages = [
    const CreateExamPage(),
    const StudentsPage()
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: pages[currentindex],
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: currentindex,
        onTap: (int index) => setState(() => currentindex = index),
        items: const <BottomNavigationBarItem>[
          BottomNavigationBarItem(
            icon: Icon(Icons.home),
            label: 'Exam',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.home),
            label: 'Students',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.settings),
            label: 'Settings',
          ),
        ],
      ),
    );
  }
}