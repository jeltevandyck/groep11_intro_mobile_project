import 'package:flutter/material.dart';

import 'exam_page.dart';

class StudentDashboardPage extends StatefulWidget {
  const StudentDashboardPage({ Key? key }) : super(key: key);

  @override
  State<StudentDashboardPage> createState() => _StudentDashboardPageState();
}

class _StudentDashboardPageState extends State<StudentDashboardPage> {

int currentindex=0;
  final pages = [
    const ExamPage()
    //Hier moet er eventueel nog iets bijkomen
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
            label: 'Temp',
          ),
          
        ],
      ),
    );
  }
}