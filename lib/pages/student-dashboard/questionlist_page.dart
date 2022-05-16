import 'dart:html';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:groep11_intro_mobile_project/models/answers_model.dart';
import 'package:groep11_intro_mobile_project/models/question_model.dart';
import 'package:groep11_intro_mobile_project/pages/Login-dashboard/student_login_page.dart';
import 'package:groep11_intro_mobile_project/pages/student-dashboard/start_exam_page.dart';
import '../../models/student_exam_model.dart';
import 'question_page.dart';

class VragenExamPage extends StatefulWidget {
  const VragenExamPage(
      {this.accountNr,
      this.longitude,
      this.latitude,
      this.uid,
      required this.count,
      Key? key})
      : super(key: key);
  final String? accountNr;
  final num? count;
  final double? longitude;
  final double? latitude;
  final String? uid;

  @override
  State<VragenExamPage> createState() => _VragenExamPageState();
}

class _VragenExamPageState extends State<VragenExamPage>
    with WidgetsBindingObserver {
  List<QuestionModal> _questions = [];
  String _currentQuestionid = "";

  num counter = 0;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    getQuestions();
  }

  @override
  initState() {
    super.initState();
    if (kIsWeb) {
      window.addEventListener('focus', onFocus);
      window.addEventListener('blur', onBlur);
    } else {
      WidgetsBinding.instance!.addObserver(this);
    }
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
      print("App is in background");
      counter++;
    } else {
      print("App is in foreground");
    }
  }

  @override
  Widget build(BuildContext context) {
    print(counter);
    if (widget.count != null) {
      counter = widget.count!;
    }

    print(widget.longitude);
    print(widget.latitude);
    return Scaffold(
      appBar: AppBar(
        title: const Text('Vragen'),
        automaticallyImplyLeading: false,
      ),
      body: Stack(children: [
        ListView.builder(
            itemCount: _questions.length,
            itemBuilder: (context, index) {
              return GestureDetector(
                  onTap: () async {
                    await getQuestionId(index);
                    Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => QuestionPage(
                            question: _questions[index],
                            accountNr: widget.accountNr,
                            questionid: _currentQuestionid,
                            index: index,
                            counter: counter,
                            longitude: widget.longitude,
                            latitude: widget.latitude,
                          ),
                        ));
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
        Align(
          alignment: Alignment.bottomCenter,
          child: Container(
            margin: const EdgeInsets.all(150),
            child: ElevatedButton(
              onPressed: () {
                _showMyDialog();
              },
              child: const Text('Beëndig Examen'),
              style: OutlinedButton.styleFrom(
                primary: Colors.white,
                padding:
                    const EdgeInsets.symmetric(horizontal: 30, vertical: 20),
                textStyle: const TextStyle(fontSize: 20),
                backgroundColor: Colors.red,
              ),
            ),
          ),
        )
      ]),
    );
  }

  Future<void> _showMyDialog() async {
    return showDialog<void>(
      context: context,
      barrierDismissible: false, // user must tap button!
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Ben je zeker dat je de examen wilt beëindigen?'),
          actions: <Widget>[
            TextButton(
              child: const Text('JA'),
              onPressed: () {
                updateStudentExam(counter);
                Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (context) => const StudentLoginPage()),
                );
              },
            ),
            TextButton(
              child: const Text('NEE'),
              onPressed: () => Navigator.pop(context),
            ),
          ],
        );
      },
    );
  }

  getQuestionId(int index) async {
    var data = await FirebaseFirestore.instance.collection('questions').get();
    setState(() {
      _currentQuestionid = data.docs[index].id;
    });
  }

  Future getQuestions() async {
    var data = await FirebaseFirestore.instance.collection('questions').get();
    setState(() {
      _questions =
          List.from(data.docs.map((doc) => QuestionModal.fromSnapshot(doc)));
    });
  }

  updateStudentExam(num? countss) async {
    FirebaseFirestore firebaseFirestore = FirebaseFirestore.instance;
    StudentExamModel studentExamModel = StudentExamModel();
    studentExamModel.uid = widget.uid;
    studentExamModel.userId = widget.accountNr;
    studentExamModel.longitude = widget.longitude.toString();
    studentExamModel.latitude = widget.latitude.toString();
    studentExamModel.exitCounter = countss.toString();

    print(studentExamModel.uid);
    print(studentExamModel.userId);
    print(studentExamModel.longitude);
    print(studentExamModel.latitude);
    print(studentExamModel.exitCounter);

    await firebaseFirestore
        .collection("student_exams")
        .doc(studentExamModel.uid)
        .set(studentExamModel.toMap());
  }
}
