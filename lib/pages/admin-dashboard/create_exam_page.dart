// ignore_for_file: non_constant_identifier_names

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:groep11_intro_mobile_project/models/exam_model.dart';
import 'package:groep11_intro_mobile_project/models/question_model.dart';
import 'package:groep11_intro_mobile_project/pages/admin-dashboard/code_question_modal.dart';
import 'package:groep11_intro_mobile_project/pages/admin-dashboard/create_exam_modal.dart';
import 'package:groep11_intro_mobile_project/pages/admin-dashboard/mutliple_question_modal.dart';
import 'package:groep11_intro_mobile_project/pages/admin-dashboard/open_question_modal.dart';
import 'package:uuid/uuid.dart';

class CreateExamPage extends StatefulWidget {
  const CreateExamPage({Key? key}) : super(key: key);

  @override
  State<CreateExamPage> createState() => _CreateExamPageState();
}

class _CreateExamPageState extends State<CreateExamPage> {
  final TextEditingController examNameController = TextEditingController();
  final TextEditingController startDateController = TextEditingController();
  final TextEditingController endDateController = TextEditingController();

  String? _examId = "";

  final _formKey = GlobalKey<FormState>();

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return overview_exam();
  }

  Widget overview_exam() {
    Scaffold create_button() {
      return Scaffold(
          appBar: AppBar(
            title: const Text("Exam"),
          ),
          body: Center(
              child: ElevatedButton(
                  onPressed: () {
                    showDialog(
                        context: context,
                        builder: (context) => create_exam_modal());
                  },
                  child: const Text('Create exam'))));
    }

    Widget edit_exam_widget() {
      return AlertDialog(
          title: const Text('Add questions'),
          content: Form(
            key: _formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              mainAxisSize: MainAxisSize.min,
              children: [
                Padding(
                    padding: const EdgeInsets.all(8),
                    child: ElevatedButton(
                        onPressed: () {
                          Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) => OpenQuestionModal()));
                        },
                        child: const Text('Open question'))),
                Padding(
                  padding: const EdgeInsets.all(8),
                  child: ElevatedButton(
                      onPressed: () {
                        Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) => MultipleQuestionModal()));
                      },
                      child: const Text('Multiple choice question')),
                ),
                Padding(
                    padding: const EdgeInsets.all(8),
                    child: ElevatedButton(
                        onPressed: () {
                          Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) => CodeQuestionModal()));
                        },
                        child: const Text('Code question'))),
                Padding(
                  padding: const EdgeInsets.only(top: 50, left: 8, right: 8),
                  child: ElevatedButton(
                      onPressed: () {
                        FirebaseFirestore firestore =
                            FirebaseFirestore.instance;
                        firestore.collection("exams").doc(_examId).delete();
                        firestore
                            .collection("answers")
                            .get()
                            .then((snapshot) => {
                                  for (DocumentSnapshot ds in snapshot.docs)
                                    {ds.reference.delete()}
                                });

                        firestore
                            .collection("questions")
                            .get()
                            .then((snapshot) => {
                                  for (DocumentSnapshot ds in snapshot.docs)
                                    {ds.reference.delete()}
                                });

                        firestore
                            .collection("student_exams")
                            .get()
                            .then((snapshot) => {
                                  for (DocumentSnapshot ds in snapshot.docs)
                                    {ds.reference.delete()}
                                });

                        firestore
                            .collection("students")
                            .get()
                            .then((snapshot) => {
                                  for (DocumentSnapshot ds in snapshot.docs)
                                    {ds.reference.delete()}
                                });

                        Navigator.pop(context);
                      },
                      child: const Text('Remove')),
                ),
              ],
            ),
          ));
    }

    Scaffold exam_information(ExamModel examModel) {
      return Scaffold(
          floatingActionButtonLocation: FloatingActionButtonLocation.endDocked,
          floatingActionButton: SizedBox(
            width: 70,
            height: 70,
            child: Container(
              margin: const EdgeInsets.only(bottom: 10.0),
              child: FloatingActionButton(
                onPressed: () {
                  showDialog(
                      context: context,
                      builder: (context) => edit_exam_widget());
                },
                child: const Icon(Icons.edit),
              ),
            ),
          ),
          appBar: AppBar(
            title: const Text("Exam"),
          ),
          body: StreamBuilder<QuerySnapshot>(
              stream: FirebaseFirestore.instance
                  .collection("questions")
                  .snapshots(),
              builder: (context, snapshot) {
                if (!snapshot.hasData) {
                  return const Center(
                    child: CircularProgressIndicator(),
                  );
                } else {
                  return ListView.builder(
                      itemCount: snapshot.data?.docs.length,
                      itemBuilder: (context, index) {
                        QueryDocumentSnapshot<Object?>? snap =
                            snapshot.data?.docs[index];
                        return Dismissible(
                            key: Key(snap?.id.toString() ?? ""),
                            child: Card(
                              margin: const EdgeInsets.all(8),
                              elevation: 5,
                              child: ListTile(title: Text(snap?['question'])),
                            ),
                            onDismissed: (direction) {
                              FirebaseFirestore.instance
                                  .collection("questions")
                                  .doc(snap?.id)
                                  .delete();
                            });
                      });
                }
              }));
    }

    return Scaffold(
        body: StreamBuilder<QuerySnapshot>(
      stream: FirebaseFirestore.instance.collection("exams").snapshots(),
      builder: (context, snapshot) {
        if (!snapshot.hasData) {
          return const Center(
            child: CircularProgressIndicator(),
          );
        } else {
          var empty = snapshot.data?.docs.isNotEmpty;
          if (empty == false) {
            return create_button();
          } else {
            _examId = snapshot.data?.docs.first.id;
            ExamModel examModel = ExamModel.fromMap(snapshot.data?.docs.first);
            return exam_information(examModel);
          }
        }
      },
    ));
  }

  Widget create_exam_modal() {
    return CreateExamModal();
  }

  pushExamToDatabase() async {
    FirebaseFirestore firestore = FirebaseFirestore.instance;

    ExamModel exam = ExamModel();
    exam.name = examNameController.text;
    exam.startDate =
        Timestamp.fromDate(DateTime.parse(startDateController.text));
    exam.endDate = Timestamp.fromDate(DateTime.parse(endDateController.text));

    DocumentReference docref = firestore.collection('exams').doc();
    await docref.set(exam.toMap());

    _examId = docref.id;
    Fluttertoast.showToast(msg: 'Exam added');
  }
}
