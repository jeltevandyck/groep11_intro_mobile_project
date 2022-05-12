// ignore_for_file: non_constant_identifier_names

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:groep11_intro_mobile_project/models/exam_model.dart';
import 'package:groep11_intro_mobile_project/models/question_model.dart';
import 'package:groep11_intro_mobile_project/pages/admin-dashboard/code_question_modal.dart';
import 'package:groep11_intro_mobile_project/pages/admin-dashboard/create_exam_modal.dart';
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
    return CodeQuestionModal(_examId);
  }

  Widget open_question_modal() {
    return OpenQuestionModal(_examId);
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
