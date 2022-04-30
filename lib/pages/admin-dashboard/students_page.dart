import 'dart:html';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:csv/csv.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:groep11_intro_mobile_project/models/student_model.dart';

class StudentsPage extends StatefulWidget {
  const StudentsPage({Key? key}) : super(key: key);

  @override
  State<StudentsPage> createState() => _StudentsPageState();
}

class _StudentsPageState extends State<StudentsPage> {
  final _auth = FirebaseAuth.instance;

  final _formKey = GlobalKey<FormState>();
  List<StudentModel> students = [];

  loadCSV(filePath) async {
    final myData = await rootBundle.loadString(filePath);
    List<List<dynamic>> csvTable = const CsvToListConverter().convert(myData);
    List<StudentModel> data = [];
    for (var row in csvTable) {
      for (var studentData in row) {
        final splittedValue = studentData.split(';');
        StudentModel studentModel = StudentModel();
        studentModel.accountNumber = splittedValue[0];
        studentModel.fullName = splittedValue[1];
        data.add(studentModel);
      }
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

    for (var i = 1; i < students.length; i++) {
      studentModel.accountNumber = students[i].accountNumber;
      studentModel.fullName = students[i].fullName;

      await firebaseFirestore
      .doc(studentModel.accountNumber)
      .set(studentModel.toMap());
    }
    print("upload succesfull");
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        floatingActionButtonLocation: FloatingActionButtonLocation.endDocked,
        floatingActionButton: SizedBox(
          height: 80,
          width: 100,
          child: FloatingActionButton(
              child: const Text("Load CSV"),
              onPressed: () async {
                await loadCSV("csv/testData.csv");
              }),
        ),
        appBar: AppBar(
          title: const Text("Table Layout and CSV"),
        ),
        body: StreamBuilder<QuerySnapshot>(
          stream: FirebaseFirestore.instance.collection("students").snapshots(),
          builder: (context, snapshot) {
            if (snapshot.hasError) {
              return const Text("Something went wrong");
            } else if (snapshot.hasData || snapshot != null) {
              return ListView.builder(
                shrinkWrap: true,
                itemCount: snapshot.data?.docs.length,
                itemBuilder: (BuildContext context, int index) {
                  QueryDocumentSnapshot<Object?>? documentSnapshot =
                      snapshot.data?.docs[index];
                  return Dismissible(
                      key: Key(index.toString()),
                      child: Card(
                        elevation: 5,
                        child: ListTile(
                          title: Text((documentSnapshot != null)
                              ? (documentSnapshot["accountNumber"])
                              : ""),
                          subtitle: Text((documentSnapshot != null)
                              ? (documentSnapshot["fullName"])
                              : ""),
                        ),
                      )
                    );
                },
              );
            }
            return const Text("temp");
          },
        )
      );
  }

}
