import 'package:flutter/material.dart';

class CreateExamPage extends StatefulWidget {
  const CreateExamPage({Key? key}) : super(key: key);

  @override
  State<CreateExamPage> createState() => _CreateExamPageState();
}

class _CreateExamPageState extends State<CreateExamPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: examOrCreate(),
      bottomNavigationBar: BottomNavigationBar(
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

  Widget examOrCreate() {
    const data = 'Exam';

    if (data == 'Exam') {
      return Center(
        child: TextButton(
          onPressed: () {},
          child: const Text('Create Exam'),
          style: OutlinedButton.styleFrom(
            primary: Colors.red,
            padding: const EdgeInsets.symmetric(horizontal: 30, vertical: 20),
          ),
        ),
      );
    } else {
      return Center(
        child: Table(
          children: const <TableRow>[
            TableRow(
              children: <Widget>[
                Text('Exam'),
                Text('Students'),
              ],
            ),
          ],
        ),
      );
    }
  }
}
