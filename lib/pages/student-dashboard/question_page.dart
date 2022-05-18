import 'dart:async';
import 'dart:html';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:groep11_intro_mobile_project/models/answers_model.dart';
import 'package:groep11_intro_mobile_project/models/question_model.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:groep11_intro_mobile_project/pages/student-dashboard/questionlist_page.dart';

class QuestionPage extends StatefulWidget {
  QuestionPage(
      {this.accountNr,
      this.fullName,
      this.questionid,
      this.index,
      this.longitude,
      this.latitude,
      this.uid,
      this.duration,
      required this.listAnswers,
      required this.counter,
      Key? key,
      required this.question})
      : super(key: key);
  final QuestionModal question;
  final String? accountNr;
  final String? fullName;
  final String? questionid;
  final num? index;
  final double? longitude;
  final double? latitude;
  final String? uid;
  final Duration? duration;
  num counter;

  final List<AnswerModel> listAnswers;

  @override
  State<QuestionPage> createState() => _QuestionPageState();
}

class _QuestionPageState extends State<QuestionPage>
    with WidgetsBindingObserver {
  TextEditingController openController = TextEditingController();
  TextEditingController CompareController = TextEditingController();

  String defaultValue = "";

  num count = 0;

  Duration duration = Duration();
  Timer? timer;

  String twoDigits(int n) => n.toString().padLeft(2, '0');

  AnswerModel _answer = AnswerModel();

  @override
  initState() {
    super.initState();
    count = widget.counter;

    if (kIsWeb) {
      window.addEventListener('focus', onFocus);
      window.addEventListener('blur', onBlur);
    } else {
      WidgetsBinding.instance!.addObserver(this);
    }

    duration = widget.duration!;
    startTimer();
  }

  @override
  void dispose() {
    if (kIsWeb) {
      window.removeEventListener('focus', onFocus);
      window.removeEventListener('blur', onBlur);
    } else {
      WidgetsBinding.instance!.removeObserver(this);
    }
    super.dispose();
  }

  void onFocus(Event e) {
    didChangeAppLifecycleState(AppLifecycleState.resumed);
  }

  void onBlur(Event e) {
    didChangeAppLifecycleState(AppLifecycleState.paused);
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    super.didChangeAppLifecycleState(state);

    final isBackground = state == AppLifecycleState.paused;

    if (isBackground) {
      count++;
    } else {}
  }

  @override
  Widget build(BuildContext context) {
    List<String>? _answers = widget.question.answers?.split(";");
    return Scaffold(
        appBar: AppBar(
          title:
              Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
            Text("Questions"),
            Text(
                "${twoDigits(duration.inHours)}:${twoDigits(duration.inMinutes.remainder(60))}:${twoDigits(duration.inSeconds.remainder(60))}"),
          ]),
          automaticallyImplyLeading: false,
        ),
        body: Center(
            child: (widget.question.examType == 1)
                ? Center(
                    child: Column(
                      children: <Widget>[
                        Padding(
                            padding: const EdgeInsets.all(100),
                            child: Column(
                              children: [
                                Text("${widget.question.question}",
                                    style: const TextStyle(fontSize: 40))
                              ],
                            )),
                        ListView.builder(
                            shrinkWrap: true,
                            itemCount: _answers?.length,
                            itemBuilder: (context, index) {
                              return Padding(
                                  padding: const EdgeInsets.only(
                                      left: 600.0, right: 600),
                                  child: Card(
                                      child: ListTile(
                                    title: Text(_answers![index]),
                                    leading: Radio(
                                      value: _answers[index],
                                      groupValue: defaultValue,
                                      onChanged: (String? value) {
                                        setState(() {
                                          defaultValue = value.toString();
                                        });
                                      },
                                    ),
                                  )));
                            }),
                        Padding(
                          padding: const EdgeInsets.symmetric(vertical: 16.0),
                          child: ElevatedButton(
                            onPressed: () {
                              uploadMultipleChoiceAnswer(
                                  defaultValue,
                                  widget.question.solution.toString(),
                                  widget.questionid.toString(),
                                  widget.accountNr.toString());

                              Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (context) => QuestionListPage(
                                      accountNr: widget.accountNr,
                                      fullName: widget.fullName,
                                      count: count,
                                      longitude: widget.longitude,
                                      latitude: widget.latitude,
                                      uid: widget.uid,
                                      duration: duration,
                                      answer: _answer,
                                      listAnswers: widget.listAnswers,
                                    ),
                                  ));
                            },
                            child: const Text('Submit'),
                          ),
                        ),
                      ],
                    ),
                  )
                : (widget.question.examType == 2)
                    ? Center(
                        child: Column(
                          children: <Widget>[
                            Padding(
                                padding: const EdgeInsets.all(100),
                                child: Column(
                                  children: [
                                    Text("${widget.question.question}",
                                        style: const TextStyle(fontSize: 40)),
                                    Padding(
                                      padding: const EdgeInsets.only(top: 40),
                                      child: Text(
                                          "${widget.question.wrongCode}",
                                          style: const TextStyle(fontSize: 20)),
                                    ),
                                  ],
                                )),
                            SizedBox(
                              width: 350,
                              child: TextFormField(
                                controller: CompareController,
                                obscureText: false,
                                textAlign: TextAlign.left,
                                decoration: const InputDecoration(
                                  border: InputBorder.none,
                                  hintText: 'Fill In',
                                  hintStyle: TextStyle(color: Colors.grey),
                                ),
                              ),
                            ),
                            Padding(
                              padding:
                                  const EdgeInsets.symmetric(vertical: 16.0),
                              child: ElevatedButton(
                                onPressed: () {
                                  uploadCompareAnswer(
                                      CompareController.text,
                                      widget.questionid.toString(),
                                      widget.accountNr.toString(),
                                      widget.question.correctCode.toString(),
                                      widget.question.caseSensitive);
                                  Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                        builder: (context) => QuestionListPage(
                                          accountNr: widget.accountNr,
                                          fullName: widget.fullName,
                                          count: count,
                                          longitude: widget.longitude,
                                          latitude: widget.latitude,
                                          uid: widget.uid,
                                          duration: duration,
                                          answer: _answer,
                                          listAnswers: widget.listAnswers,
                                        ),
                                      ));
                                },
                                child: const Text('Submit'),
                              ),
                            ),
                          ],
                        ),
                      )
                    : Center(
                        child: Column(
                          children: <Widget>[
                            Padding(
                                padding: const EdgeInsets.all(100),
                                child: Text(
                                    "Question ${widget.question.question}",
                                    style: const TextStyle(fontSize: 40))),
                            SizedBox(
                              width: 350,
                              child: TextFormField(
                                controller: openController,
                                obscureText: false,
                                textAlign: TextAlign.left,
                                decoration: const InputDecoration(
                                  border: InputBorder.none,
                                  hintText: 'Fill In',
                                  hintStyle: TextStyle(color: Colors.grey),
                                ),
                              ),
                            ),
                            Padding(
                              padding:
                                  const EdgeInsets.symmetric(vertical: 16.0),
                              child: ElevatedButton(
                                onPressed: () {
                                  uploadOpenAnswer(
                                      openController.text,
                                      widget.questionid.toString(),
                                      widget.accountNr.toString());
                                  Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                        builder: (context) => QuestionListPage(
                                          accountNr: widget.accountNr,
                                          fullName: widget.fullName,
                                          count: count,
                                          longitude: widget.longitude,
                                          latitude: widget.latitude,
                                          uid: widget.uid,
                                          duration: duration,
                                          answer: _answer,
                                          listAnswers: widget.listAnswers,
                                        ),
                                      ));
                                },
                                child: const Text('Submit'),
                              ),
                            ),
                          ],
                        ),
                      )));
  }

  uploadMultipleChoiceAnswer(
      String answer, String solution, String questionid, String userId) async {
    FirebaseFirestore firebaseFirestore = FirebaseFirestore.instance;
    AnswerModel answerModel = AnswerModel();

    if (answer == solution) {
      answerModel.grade = "10";
    } else {
      answerModel.grade = "0";
    }

    answerModel.answer = answer + ";";

    answerModel.questionId = questionid;
    answerModel.userId = userId;

    _answer = answerModel;
  }

  uploadOpenAnswer(String answer, String questionid, String userId) async {
    FirebaseFirestore firebaseFirestore = FirebaseFirestore.instance;
    AnswerModel answerModel = AnswerModel();
    answerModel.answer = answer + ";";
    answerModel.grade = "0";
    answerModel.questionId = questionid;
    answerModel.userId = userId;

    _answer = answerModel;
  }

  uploadCompareAnswer(String answer, String questionid, String userId,
      String correct, bool? casesensitive) async {
    FirebaseFirestore firebaseFirestore = FirebaseFirestore.instance;
    AnswerModel answerModel = AnswerModel();

    if (casesensitive == true) {
      if (answer.compareTo(correct) == 0) {
        answerModel.grade = "10";
      } else {
        answerModel.grade = "0";
      }
    } else {
      if (answer.toLowerCase().compareTo(correct.toLowerCase()) == 0) {
        answerModel.grade = "10";
      } else {
        answerModel.grade = "0";
      }
    }

    answerModel.answer = answer;
    answerModel.questionId = questionid;
    answerModel.userId = userId;

    _answer = answerModel;
  }

  void startTimer() {
    timer = Timer.periodic(Duration(seconds: 1), (_) => addTime());
  }

  void addTime() {
    final addSeconds = 1;
    setState(() {
      final seconds = duration.inSeconds + addSeconds;
      duration = Duration(seconds: seconds);
    });
  }
}
