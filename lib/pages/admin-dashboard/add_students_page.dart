import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

import '../../models/student_model.dart';

class AddStudentsPage extends StatefulWidget {
  const AddStudentsPage({Key? key}) : super(key: key);

  @override
  State<AddStudentsPage> createState() => _AddStudentsPageState();
}


class _AddStudentsPageState extends State<AddStudentsPage> {

  final TextEditingController CSVController =
      TextEditingController();
  List<StudentModel> students = [];

loadCSV(filePath) async {
    String csv = CSVController.text;
    var splittedCSV = csv.split(";");
    List<StudentModel> data = [];
      for (var student in splittedCSV) {
        final splittedValue = student.split(',');
        StudentModel studentModel = StudentModel();
        studentModel.accountNumber = splittedValue[0];
        studentModel.fullName = splittedValue[1];
        data.add(studentModel);
    }
    students = data;
    uploadCSVToFirebase(students);
  }

uploadCSVToFirebase(List<StudentModel> students) async {
    StudentModel studentModel = StudentModel();
    var firebaseFirestore = FirebaseFirestore.instance.collection("students");
    var snapshots = await firebaseFirestore.get();
    for (var doc in snapshots.docs) {
      await doc.reference.delete();
    }

    for (var i = 0; i < students.length; i++) {
      studentModel.accountNumber = students[i].accountNumber;
      studentModel.fullName = students[i].fullName;

      await firebaseFirestore
      .doc(studentModel.accountNumber)
      .set(studentModel.toMap());
    }
  }




  @override
  Widget build(BuildContext context) {
    return Scaffold(
      floatingActionButtonLocation: FloatingActionButtonLocation.endDocked,
        floatingActionButton: SizedBox(
            height: 100,
            width: 120,
            child: Container(
              margin: const EdgeInsets.only(bottom: 10.0),
              child: FloatingActionButton(
                  child: const Text("Upload CSV"),
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => const AddStudentsPage()),
                    );
                  }),
            )),
      appBar: AppBar(
        title: const Text("Upload CSV"),
        centerTitle: true,
      ),
      body: TextFormField(
        controller: CSVController,
        decoration: const InputDecoration(
            border: OutlineInputBorder(), hintText: "Enter your CSV (AccountNr, FullName;)"),
      ),
    );
  }
}
