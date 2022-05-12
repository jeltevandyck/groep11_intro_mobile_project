import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:groep11_intro_mobile_project/models/exam_model.dart';

class CreateExamModal extends StatelessWidget {
  final TextEditingController examNameController = TextEditingController();
  final TextEditingController startDateController = TextEditingController();
  final TextEditingController endDateController = TextEditingController();

  String? _examId = "";

  final _formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
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
