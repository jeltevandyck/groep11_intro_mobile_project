import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:csv/csv.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:groep11_intro_mobile_project/models/student_model.dart';
import 'package:groep11_intro_mobile_project/pages/admin-dashboard/add_students_page.dart';

class StudentsPage extends StatefulWidget {
  const StudentsPage({Key? key}) : super(key: key);

  @override
  State<StudentsPage> createState() => _StudentsPageState();
}

class _StudentsPageState extends State<StudentsPage> {
  final _auth = FirebaseAuth.instance;

  final _formKey = GlobalKey<FormState>();
  List<StudentModel> students = [];

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
                  child: const Text("Enter CSV"),
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => const AddStudentsPage()),
                    );
                  }),
            )),
        appBar: AppBar(
          automaticallyImplyLeading: false,
          title: const Text("Students"),
          centerTitle: true,
          
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
                      ));
                },
              );
            }
            return const Text("temp");
          },
        ));
  }
}
