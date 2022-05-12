import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

// ignore: must_be_immutable
class OpenQuestionModal extends StatelessWidget {
  String? examId;

  OpenQuestionModal(this.examId);

  final TextEditingController openQuestionModalController =
      TextEditingController();
  final TextEditingController MaxResultsController = TextEditingController();
  final TextEditingController questionController = TextEditingController();
  final _formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
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

  pushOpenQuestionToDatabase() async {
    FirebaseFirestore firestore = FirebaseFirestore.instance;

    await firestore.collection('questions').doc().set({
      "question": openQuestionModalController.text,
      "max": int.parse(MaxResultsController.text),
      "examType": 3,
      "examId": examId.toString()
    });
  }
}
