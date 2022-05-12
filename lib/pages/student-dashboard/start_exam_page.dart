import 'dart:html';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:geolocator/geolocator.dart';
import 'package:groep11_intro_mobile_project/models/student_exam_model.dart';
import 'package:groep11_intro_mobile_project/pages/student-dashboard/questionlist_page.dart';

class StartExamPage extends StatefulWidget {
  const StartExamPage({this.accountNr, Key? key}) : super(key: key);
  final String? accountNr;

  @override
  State<StartExamPage> createState() => _StartExamPageState();
}

class _StartExamPageState extends State<StartExamPage> {
  // Position? currentPosition;
  @override
  Widget build(BuildContext context) {
    return Scaffold(body: startExam());
  }

  Widget startExam() {
    Scaffold c1(String uid) {
      return Scaffold(
        body: Center(
          child: ElevatedButton(
            onPressed: () async {
              await getCurrentLocation(uid);
            },
            child: const Text('Start exam'),
            style: OutlinedButton.styleFrom(
              primary: Colors.white,
              padding: const EdgeInsets.symmetric(horizontal: 30, vertical: 20),
              textStyle: const TextStyle(fontSize: 20),
              backgroundColor: Colors.red,
            ),
          ),
        ),
      );
    }

    final c2 = Center(
      child: Text("Er is geen examen"),
    );
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
            child: documentSnapshot == true
                ? c1(snapshot.data?.docs.first["uid"])
                : c2,
          );
        }
      },
    ));
  }

  getCurrentLocation(String uid) {
    Geolocator.getCurrentPosition(
            desiredAccuracy: LocationAccuracy.best,
            forceAndroidLocationManager: true)
        .then((Position position) {
      uploadStudentExamToFirebase(uid, position.longitude, position.latitude);
    }).catchError((e) {
      print(e);
  });

    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => const VragenExamPage()),
    );
  }

  uploadStudentExamToFirebase(String uid, double lon, double lat) async {

    FirebaseFirestore firebaseFirestore = FirebaseFirestore.instance;
    StudentExamModel studentExamModel = StudentExamModel();
    studentExamModel.uid = uid;
    studentExamModel.userId = widget.accountNr;
    studentExamModel.longitude = lon.toString();
    studentExamModel.latitude = lat.toString();
    studentExamModel.exitCounter = "0";

    await firebaseFirestore
        .collection("student_exams")
        .doc(studentExamModel.uid)
        .set(studentExamModel.toMap());

    Fluttertoast.showToast(msg: "The exam is started");
  }
}
