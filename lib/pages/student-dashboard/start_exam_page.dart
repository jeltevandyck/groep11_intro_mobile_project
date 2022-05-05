import 'package:flutter/material.dart';
import 'package:groep11_intro_mobile_project/pages/student-dashboard/questionlist_page.dart';

class StartExamPage extends StatefulWidget {
  const StartExamPage({Key? key}) : super(key: key);

  @override
  State<StartExamPage> createState() => _StartExamPageState();
}

class _StartExamPageState extends State<StartExamPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(body: startExam());
  }

  Widget startExam() {
    return Center(
      child: ElevatedButton(
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => const VragenExamPage()),
          );
        },
        child: const Text('Start Exam'),
        style: OutlinedButton.styleFrom(
          primary: Colors.white,
          padding: const EdgeInsets.symmetric(horizontal: 30, vertical: 20),
          textStyle: const TextStyle(fontSize: 20),
          backgroundColor: Colors.red,
        ),
      ),
    );
  }
}
