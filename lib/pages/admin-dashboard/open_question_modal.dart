import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:groep11_intro_mobile_project/pages/admin-dashboard/create_exam_page.dart';

class OpenQuestionModal extends StatefulWidget {
  OpenQuestionModal({Key? key}) : super(key: key);

  @override
  State<OpenQuestionModal> createState() => _OpenQuestionModalState();
}

class _OpenQuestionModalState extends State<OpenQuestionModal> {
  final TextEditingController openQuestionModalController =
      TextEditingController();
  final TextEditingController MaxResultsController = TextEditingController();
  final TextEditingController questionController = TextEditingController();
  final _formKey = GlobalKey<FormState>();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text('Open Question '),
        ),
        body: Center(
          child: Container(
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

                      if (int.tryParse(value) == null) {
                        return 'Max results is not a number';
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
                          if (_formKey.currentState!.validate()) {
                            await pushOpenQuestionToDatabase();
                            Navigator.pop(context);
                          }
                        },
                        child: const Text('Create')),
                  )
                ],
              ),
            ),
          ),
        ));
  }

  pushOpenQuestionToDatabase() async {
    FirebaseFirestore firestore = FirebaseFirestore.instance;

    await firestore.collection('questions').doc().set({
      "question": openQuestionModalController.text,
      "max": int.parse(MaxResultsController.text),
      "examType": 3,
    });
  }
}
