// ignore_for_file: non_constant_identifier_names

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:groep11_intro_mobile_project/models/exam_model.dart';
import 'package:groep11_intro_mobile_project/models/question_model.dart';
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
  final TextEditingController openQuestionModalController =
      TextEditingController();
  final TextEditingController MaxResultsController = TextEditingController();
  final TextEditingController questionController = TextEditingController();
  final TextEditingController codeQuestionController = TextEditingController();
  final TextEditingController wrongQuestionController = TextEditingController();

  bool isCaseSensitive = false;

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
          body: Center(
              child: ElevatedButton(
                  onPressed: () {
                    showDialog(
                        context: context,
                        builder: (context) => create_exam_modal());
                  },
                  child: const Text('Create exam'))));
    }

    Center exam_information(ExamModel examModel) {
      return Center(
        child: Column(children: [
          Padding(
              padding: const EdgeInsets.fromLTRB(0, 50, 0, 20),
              child: Text(examModel.name.toString())),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Padding(
                  padding: const EdgeInsets.all(20),
                  child:
                      Text(examModel.startDate!.toDate().toLocal().toString())),
              Padding(
                  padding: const EdgeInsets.all(20),
                  child:
                      Text(examModel.endDate!.toDate().toLocal().toString())),
            ],
          ),
          const Text('Add questions'),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Padding(
                padding: const EdgeInsets.all(10),
                child: ElevatedButton(
                    onPressed: () {
                      showDialog(
                          context: context,
                          builder: (context) => open_question_modal());
                    },
                    child: const Text('Open')),
              ),
              Padding(
                padding: const EdgeInsets.all(10),
                child: ElevatedButton(
                    onPressed: () {}, child: const Text('Multiple choice')),
              ),
              Padding(
                padding: const EdgeInsets.all(10),
                child: ElevatedButton(
                    onPressed: () {
                      showDialog(
                          context: context,
                          builder: (context) => code_question_modal());
                    },
                    child: const Text('Code')),
              ),
            ],
          ),
          Row(
            children: [
              Scaffold(
                body: StreamBuilder<QuerySnapshot>(
                  stream: FirebaseFirestore.instance
                      .collection('questions')
                      .snapshots(),
                  builder: (context, snapshot) {
                    if (!snapshot.hasData) {
                      return const Text('Loading...');
                    } else {
                      return ListView.builder(
                          itemCount: snapshot.data?.docs.length,
                          itemBuilder: (context, index) {
                            final question = snapshot.data?.docs[index].data();
                            return Text(question.toString());
                          });
                    }
                  },
                ),
              )
            ],
          )
        ]),
      );
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

  Widget code_question_modal() {
    return AlertDialog(
      title: const Text('Code question'),
      content: Container(
        height: 500,
        width: 500,
        child: Form(
          key: _formKey,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextFormField(
                controller: questionController,
                decoration: const InputDecoration(
                  labelText: 'Question',
                ),
                validator: (value) {
                  if (value!.isEmpty) {
                    return 'Please enter some text';
                  }
                  return null;
                },
              ),
              TextFormField(
                controller: codeQuestionController,
                decoration: const InputDecoration(
                  labelText: 'Correct code',
                ),
                validator: (value) {
                  if (value!.isEmpty) {
                    return 'Please enter some text';
                  }
                  return null;
                },
              ),
              TextFormField(
                controller: wrongQuestionController,
                decoration: const InputDecoration(
                  labelText: 'Wrong code',
                ),
                validator: (value) {
                  if (value!.isEmpty) {
                    return 'Please enter some text';
                  }
                  return null;
                },
              ),
              TextFormField(
                controller: MaxResultsController,
                decoration: const InputDecoration(
                  labelText: 'Max results',
                ),
                validator: (value) {
                  if (value!.isEmpty) {
                    return 'Please enter some text';
                  }
                  return null;
                },
              ),
              Row(
                children: [
                  Checkbox(
                      checkColor: Colors.white,
                      value: isCaseSensitive,
                      onChanged: (bool? value) {
                        setState(() {
                          isCaseSensitive = value!;
                        });
                      }),
                  const Text('Case sensitive'),
                ],
              ),
              Padding(
                padding: const EdgeInsets.all(10),
                child: ElevatedButton(
                  onPressed: () async {
                    if (_formKey.currentState!.validate()) {
                      await pushCodeQuestionToDatabase();
                      Navigator.pop(context);
                    }
                  },
                  child: const Text('Create'),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget open_question_modal() {
    return AlertDialog(
      title: const Text('Open vraag'),
      content: Container(
        height: 500,
        width: 500,
        child: Form(
          key: _formKey,
          child: Column(
            children: [
              TextFormField(
                controller: openQuestionModalController,
                decoration: const InputDecoration(
                  labelText: 'Question',
                ),
                validator: (value) {
                  if (value!.isEmpty) {
                    return 'Question is empty';
                  }
                  return null;
                },
                onSaved: (value) {
                  openQuestionModalController.text = value!;
                },
              ),
              TextFormField(
                controller: MaxResultsController,
                decoration: const InputDecoration(
                  labelText: 'Max results',
                ),
                validator: (value) {
                  if (value!.isEmpty) {
                    return 'Max results is empty';
                  }
                  return null;
                },
                onSaved: (value) {
                  MaxResultsController.text = value!;
                },
              ),
              Padding(
                padding: const EdgeInsets.all(10),
                child: ElevatedButton(
                    onPressed: () async {
                      await pushOpenQuestionToDatabase();
                      Navigator.pop(context);
                    },
                    child: const Text('Create')),
              )
            ],
          ),
        ),
      ),
    );
  }

  Widget create_exam_modal() {
    return AlertDialog(
      title: const Text('Create exam'),
      content: SizedBox(
        height: 400,
        width: 500,
        child: Form(
          key: _formKey,
          child: Column(
            children: <Widget>[
              const Text('Exam name'),
              TextFormField(
                  controller: examNameController,
                  decoration: const InputDecoration(hintText: 'Exam name'),
                  validator: (value) {
                    if (value!.isEmpty) {
                      return 'Please enter an exam name.';
                    }
                    return null;
                  },
                  onSaved: (value) {
                    examNameController.text = value!;
                  }),
              const Text('Start date'),
              TextFormField(
                controller: startDateController,
                decoration:
                    const InputDecoration(hintText: 'yyyy-mm-dd hh:mm:ss'),
                validator: (value) {
                  if (value!.isEmpty) {
                    return 'Please enter a start date.';
                  }
                  if (!RegExp(r'(\d{4}-?\d\d-?\d\d(\s|T)\d\d:?\d\d:?\d\d)')
                      .hasMatch(value)) {
                    return 'year-mm-dd hh:mm:ss';
                  }
                  return null;
                },
                onSaved: (value) {
                  startDateController.text = value!;
                },
              ),
              const Text('End date'),
              TextFormField(
                controller: endDateController,
                decoration:
                    const InputDecoration(hintText: 'yyyy-mm-dd hh:mm:ss'),
                validator: (value) {
                  if (value!.isEmpty) {
                    return 'yyyy-mm-dd hh:mm:ss';
                  }
                  if (!RegExp(r'(\d{4}-?\d\d-?\d\d(\s|T)\d\d:?\d\d:?\d\d)')
                      .hasMatch(value)) {
                    return 'yyyy-mm-dd hh:mm:ss';
                  }
                  return null;
                },
                onSaved: (value) {
                  endDateController.text = value!;
                },
                textInputAction: TextInputAction.done,
              ),
              ElevatedButton(
                onPressed: () async {
                  // Create exam
                  if (_formKey.currentState!.validate()) {
                    await pushExamToDatabase();

                    Navigator.pop(context);
                  }
                },
                child: const Text('Create'),
              )
            ],
          ),
        ),
      ),
    );
  }

  pushOpenQuestionToDatabase() async {
    FirebaseFirestore firestore = FirebaseFirestore.instance;

    await firestore.collection('questions').doc().set({
      "question": openQuestionModalController.text,
      "max": int.parse(MaxResultsController.text),
      "examType": 3,
      "examId": _examId.toString()
    });
  }

  pushCodeQuestionToDatabase() async {
    FirebaseFirestore firestore = FirebaseFirestore.instance;

    await firestore.collection('questions').doc().set({
      "question": questionController.text,
      "correctCode": codeQuestionController.text,
      "wrongCode": wrongQuestionController.text,
      "examType": 2,
      "caseSensitive": isCaseSensitive,
      "max": int.parse(MaxResultsController.text),
    });
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
