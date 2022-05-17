import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class CodeQuestionModal extends StatefulWidget {
  CodeQuestionModal({Key? key}) : super(key: key);

  String isCaseSensitive = 'No';

  @override
  State<CodeQuestionModal> createState() => _CodeQuestionModalState();
}

class _CodeQuestionModalState extends State<CodeQuestionModal> {
  final TextEditingController MaxResultsController = TextEditingController();
  final TextEditingController questionController = TextEditingController();
  final TextEditingController codeQuestionController = TextEditingController();
  final TextEditingController wrongQuestionController = TextEditingController();

  final _formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
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
                  const Text('Case sensitive'),
                  Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: DropdownButton<String>(
                        value: widget.isCaseSensitive,
                        items: ['Yes', 'No'].map((String value) {
                          return DropdownMenuItem<String>(
                            value: value,
                            child: Text(value),
                          );
                        }).toList(),
                        onChanged: (String? value) {
                          setState(() {
                            if (value == 'Yes') {
                              widget.isCaseSensitive = 'Yes';
                            } else {
                              widget.isCaseSensitive = 'No';
                            }
                          });
                        },
                      )),
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

  pushCodeQuestionToDatabase() async {
    FirebaseFirestore firestore = FirebaseFirestore.instance;

    await firestore.collection('questions').doc().set({
      "question": questionController.text,
      "correctCode": codeQuestionController.text,
      "wrongCode": wrongQuestionController.text,
      "examType": 2,
      "caseSensitive": widget.isCaseSensitive == 'Yes' ? true : false,
      "max": int.parse(MaxResultsController.text),
    });
  }
}
