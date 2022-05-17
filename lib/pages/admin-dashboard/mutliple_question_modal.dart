import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class MultipleQuestionModal extends StatefulWidget {
  const MultipleQuestionModal({Key? key}) : super(key: key);

  @override
  State<MultipleQuestionModal> createState() => _MultipleQuestionModalState();
}

class _MultipleQuestionModalState extends State<MultipleQuestionModal> {
  int multipleChoices = 2;
  List<TextEditingController> controllers = [];
  TextEditingController questionController = TextEditingController();
  TextEditingController maxGradeController = TextEditingController();
  final _formKey = GlobalKey<FormState>();

  // create list of TextEditingControllers

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: const Text('Multiple Question'),
        ),
        body: Center(
          child: Container(
            height: 500,
            width: 500,
            child: Form(
              key: _formKey,
              child: Column(children: [
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: TextFormField(
                    controller: questionController,
                    decoration: const InputDecoration(
                      labelText: 'Question',
                    ),
                    validator: (value) {
                      if (value!.isEmpty) {
                        return 'Please enter a question';
                      }
                      return null;
                    },
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: TextFormField(
                    controller: maxGradeController,
                    decoration: const InputDecoration(
                      labelText: 'Max grade',
                    ),
                    validator: (value) {
                      if (value!.isEmpty) {
                        return 'Please enter a max grade';
                      }

                      if (int.tryParse(value) == null) {
                        return 'Max grade must be a number';
                      }

                      return null;
                    },
                  ),
                ),
                Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        ElevatedButton(
                            onPressed: () => {
                                  setState(() {
                                    multipleChoices++;
                                  })
                                },
                            child: const Text('+')),
                        ElevatedButton(
                            onPressed: () => {
                                  setState(() => {
                                        if (multipleChoices > 2)
                                          {multipleChoices--}
                                      })
                                },
                            child: const Text('-'))
                      ],
                    )),
                Expanded(child: listView()),
                ElevatedButton(
                    onPressed: () async {
                      if (_formKey.currentState!.validate()) {
                        await addQuestion();
                        Navigator.of(context).pop();
                      }
                    },
                    child: const Text('Create question')),
              ]),
            ),
          ),
        ));
  }

  Widget listView() {
    generateControllers();

    return ListView.builder(
        itemCount: multipleChoices,
        itemBuilder: (context, index) {
          return TextFormField(
            controller: controllers[index],
            decoration: InputDecoration(
              labelText: 'Answer ' + (index + 1).toString(),
            ),
            validator: (value) {
              if (value!.isEmpty) {
                return 'Please enter an answer';
              }
              return null;
            },
          );
        });
  }

  generateControllers() {
    List<TextEditingController> cons = List<TextEditingController>.generate(
      multipleChoices,
      (i) => TextEditingController(),
    );

    controllers = cons;
  }

  addQuestion() async {
    FirebaseFirestore firestore = FirebaseFirestore.instance;

    String answers = '';
    for (int i = 0; i < multipleChoices; i++) {
      answers += controllers[i].text + ';';
    }

    await firestore.collection('questions').doc().set({
      "question": questionController.text,
      "max": int.parse(maxGradeController.text),
      "examType": 1,
      "answers": answers
    });
  }
}
