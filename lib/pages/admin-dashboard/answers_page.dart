import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

import '../../models/question_model.dart';

class AnswersPage extends StatefulWidget {
  const AnswersPage({this.accountNr, Key? key}) : super(key: key);
  final String? accountNr;

  @override
  State<AnswersPage> createState() => _AnswersPageState();
}

class _AnswersPageState extends State<AnswersPage> {
  List<QuestionModal> _questions = [];
  String _currentAnswer = "";
  String _currentAnswerId = "";
  String _currentGrade = "";

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    getQuestions();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: true,
        title: const Text("Questions"),
        centerTitle: true,
      ),
      body: Stack(children: [
        ListView.builder(
            itemCount: _questions.length,
            itemBuilder: (context, index) {
              return GestureDetector(
                  onTap: () {
                    showAnswer(index);
                  },
                  child: Card(
                    child: Padding(
                        padding: const EdgeInsets.all(12.0),
                        child: Column(
                          children: [
                            Row(
                              children: [
                                Padding(
                                  padding: const EdgeInsets.only(bottom: 10.0),
                                  child: Text("${_questions[index].question}"),
                                )
                              ],
                            )
                          ],
                        )),
                  ));
            }),
      ]),
    );
  }

  Future getQuestions() async {
    var data = await FirebaseFirestore.instance.collection('questions').get();
    setState(() {
      _questions =
          List.from(data.docs.map((doc) => QuestionModal.fromSnapshot(doc)));
    });
  }

  Future<void> getStudentAnswer(questionId) async {
    QuerySnapshot collection = await FirebaseFirestore.instance
        .collection("answers")
        .where("userId", isEqualTo: widget.accountNr)
        .where("questionId", isEqualTo: questionId)
        .get();
    setState(() => _currentAnswer = collection.docs.first["answer"]);
    setState(() => _currentAnswerId = collection.docs.first.id);
    setState(() => _currentGrade = collection.docs.first["grade"]);
  }

  void showAnswer(index) async {
    var data = await FirebaseFirestore.instance.collection("questions").get();
    var questionId = data.docs[index].id;
    var questionMax = data.docs[index]["max"];
    await getStudentAnswer(questionId);
    var answers_list = _currentAnswer.split(";");
    var answers = <Widget>[];
    answers.add(const SizedBox(height: 20));
    for (var i = 0; i < answers_list.length; i++) {
      answers.add(Text(answers_list[i]));
    }
    showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
              insetPadding: EdgeInsets.zero,
              content: Builder(
                builder: (context) {
                  var height = MediaQuery.of(context).size.height;
                  var width = MediaQuery.of(context).size.width;

                  return SizedBox(
                      height: (height / 100) * 50,
                      width: (width / 100) * 50,
                      child: Scaffold(
                          floatingActionButtonLocation:
                              FloatingActionButtonLocation.endDocked,
                          floatingActionButton: SizedBox(
                              height: 100,
                              width: 120,
                              child: Container(
                                margin: const EdgeInsets.only(bottom: 10.0),
                                child: FloatingActionButton(
                                    child: const Text("Edit"),
                                    onPressed: () {showScoreChange(_currentAnswerId, index);}),
                              )),
                          appBar: AppBar(
                            automaticallyImplyLeading: true,
                            title: const Text("Answer and Grade"),
                            centerTitle: true,
                          ),
                          body: Center(
                            child: Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                crossAxisAlignment: CrossAxisAlignment.center,
                                children: [
                                  const Text("Answer: "),
                                  Column(
                                      children: answers,
                                      mainAxisAlignment:
                                          MainAxisAlignment.center,
                                      crossAxisAlignment:
                                          CrossAxisAlignment.center),
                                  const SizedBox(
                                    width: 100,
                                  ),
                                  Text("Grade: " +
                                      _currentGrade.toString() +
                                      " / " +
                                      questionMax.toString())
                                ]),
                          )));
                },
              ));
        });
  }

  void showScoreChange(answerId, index) {
    final TextEditingController scoreController = TextEditingController();
    showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
              insetPadding: EdgeInsets.zero,
              content: Builder(
                builder: (context) {
                  // Get available height and width of the build area of this widget. Make a choice depending on the size.
                  var height = MediaQuery.of(context).size.height;
                  var width = MediaQuery.of(context).size.width;

                  return SizedBox(
                      height: (height / 100) * 20,
                      width: (width / 100) * 20,
                      child: Scaffold(
                          body: Column(
                        children: [
                          TextFormField(
                            autofocus: true,
                            controller: scoreController,
                            onSaved: (value) {
                              scoreController.text = value!;
                            },
                            decoration: const InputDecoration(
                                border: OutlineInputBorder(),
                                hintText: "New Score"),
                          ),
                          TextButton(
                              onPressed: () {
                                updateQuestionScore(answerId, scoreController.text);
                                Navigator.pop(context);
                                Navigator.pop(context);
                                // build(context);
                                showAnswer(index);
                              },
                              child: const Text("edit"))
                        ],
                      )));
                },
              ));
        });
  }
  void updateQuestionScore(answerId, grade)async{
    var FBInstance = await FirebaseFirestore.instance;
    FBInstance.collection("answers").doc(answerId).update({'grade': grade});
    
  }
}
