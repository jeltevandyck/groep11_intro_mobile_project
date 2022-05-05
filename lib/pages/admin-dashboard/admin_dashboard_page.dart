import 'package:flutter/material.dart';
import 'package:groep11_intro_mobile_project/pages/admin-dashboard/settings_page.dart';

import 'create_exam_page.dart';
import 'students_page.dart';

class AdminDashboardPage extends StatefulWidget {
  const AdminDashboardPage({ Key? key }) : super(key: key);

  @override
  State<AdminDashboardPage> createState() => _AdminDashboardPageState();
}

class _AdminDashboardPageState extends State<AdminDashboardPage> {

  final TextEditingController emailController =
      TextEditingController();
  int currentindex=0;
  final pages = [
    const CreateExamPage(),
    const StudentsPage(),
    const SettingsPage()
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