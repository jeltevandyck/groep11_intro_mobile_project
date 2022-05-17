import 'dart:async';
import 'dart:html';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:geolocator/geolocator.dart';
import 'package:groep11_intro_mobile_project/models/answers_model.dart';
import 'package:groep11_intro_mobile_project/models/student_exam_model.dart';
import 'package:groep11_intro_mobile_project/pages/student-dashboard/questionlist_page.dart';

class StartExamPage extends StatefulWidget {
  const StartExamPage({this.accountNr, Key? key}) : super(key: key);
  final String? accountNr;

  @override
  State<StartExamPage> createState() => _StartExamPageState();
}

class _StartExamPageState extends State<StartExamPage> {
  double? longitude;
  double? latitude;

  String? uid = "";

  Duration duration = Duration();
  Timer? timer;

  List<AnswerModel> _answers = [];
  AnswerModel nullAnswer = AnswerModel();

  @override
  void initState() {
    super.initState();
    startTimer();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: StreamBuilder<QuerySnapshot>(
      stream: FirebaseFirestore.instance.collection("exams").snapshots(),
      builder: (context, snapshot) {
        if (snapshot.hasError) {
          return const Center(child: Text('Error loading documents'));
        } else if (!snapshot.hasData) {
          return Text("Er is geen examen");
        } else {
          var documentSnapshot = snapshot.data?.docs.isNotEmpty;
          return Center(
            child: (documentSnapshot == true)
                ? Scaffold(
                    body: Center(
                      child: ElevatedButton(
                        onPressed: () async {
                          await getStudentExam(widget.accountNr);
                          await getCurrentLocation(uid);
                        },
                        child: const Text('Start exam'),
                        style: OutlinedButton.styleFrom(
                          primary: Colors.white,
                          padding: const EdgeInsets.symmetric(
                              horizontal: 30, vertical: 20),
                          textStyle: const TextStyle(fontSize: 20),
                          backgroundColor: Colors.red,
                        ),
                      ),
                    ),
                  )
                : Center(
                    child: Text("Er is geen examen"),
                  ),
          );
        }
      },
    ));
  }

  getCurrentLocation(String? uid) async {
    Geolocator.getCurrentPosition(
            desiredAccuracy: LocationAccuracy.best,
            forceAndroidLocationManager: true)
        .then((Position position) {
      longitude = position.longitude;
      latitude = position.latitude;
      uploadStudentExamToFirebase(uid, longitude, latitude);
      Navigator.push(
        context,
        MaterialPageRoute(
            builder: (context) => QuestionListPage(
                  accountNr: widget.accountNr,
                  count: 0,
                  longitude: longitude,
                  latitude: latitude,
                  uid: uid,
                  duration: duration,
                  listAnswers: _answers,
                  answer: nullAnswer,
                )),
      );
    }).catchError((e) {
      print(e);
    });
  }

  getStudentExam(accountNr) async {
    QuerySnapshot collection = await FirebaseFirestore.instance
        .collection("student_exams")
        .where("userId", isEqualTo: accountNr)
        .get();

    setState(() => uid = collection.docs.first["uid"]);
  }

  uploadStudentExamToFirebase(String? uid, double? lon, double? lat) async {
    FirebaseFirestore firebaseFirestore = FirebaseFirestore.instance;
    StudentExamModel studentExamModel = StudentExamModel();
    studentExamModel.uid = uid;
    studentExamModel.userId = widget.accountNr;
    studentExamModel.longitude = lon.toString();
    studentExamModel.latitude = lat.toString();
    studentExamModel.exitCounter = "0";
    studentExamModel.endExam = "";

    await firebaseFirestore
        .collection("student_exams")
        .doc(studentExamModel.uid)
        .set(studentExamModel.toMap());

    Fluttertoast.showToast(msg: "The exam is started");
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
