import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:groep11_intro_mobile_project/pages/student-dashboard/questionlist_page.dart';

class StartExamPage extends StatefulWidget {
  const StartExamPage({Key? key}) : super(key: key);

  @override
  State<StartExamPage> createState() => _StartExamPageState();
}

class _StartExamPageState extends State<StartExamPage> {
  Position? currentPosition;
  @override
  Widget build(BuildContext context) {
    return Scaffold(body: startExam());
  }

  Widget startExam() {
    final c1 = Scaffold(
      body: Center(
        child: ElevatedButton(
          onPressed: () async {
            await getCurrentLocation();

            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => const VragenExamPage()),
            );
          },
          child: const Text('Start Exam'),
          style: OutlinedButton.styleFrom(
            primary: Colors.white,
            padding: const EdgeInsets.symmetric(horizontal: 30, vertical: 20),
            textStyle: const TextStyle(fontSize: 20),
            backgroundColor: Colors.red,
          ),
        ),
      ),
    );
    final c2 = Center(child: Text("Er is geen examen"),);
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
          print(documentSnapshot);
          return Center(
            child: documentSnapshot == true ? c1 : c2,
          );
        }
      },
    ));

    //   if(){
    //   return Scaffold(
    //     body: StreamBuilder<QuerySnapshot>(
    //       stream: FirebaseFirestore.instance.collection("exams").snapshots(),

    //     ),
    //     body: Center(
    //     child: ElevatedButton(
    //       onPressed: () async{
    //         await getCurrentLocation();

    //         Navigator.push(
    //           context,
    //           MaterialPageRoute(builder: (context) => const VragenExamPage()),
    //         );
    //       },
    //       child: const Text('Start Exam'),
    //       style: OutlinedButton.styleFrom(
    //         primary: Colors.white,
    //         padding: const EdgeInsets.symmetric(horizontal: 30, vertical: 20),
    //         textStyle: const TextStyle(fontSize: 20),
    //         backgroundColor: Colors.red,
    //       ),
    //     ),
    //   ),
    //   );
    // }else {
    //   return Container(child: Text("test"));
    // }
  }

  getCurrentLocation() {
    Geolocator.getCurrentPosition(
            desiredAccuracy: LocationAccuracy.best,
            forceAndroidLocationManager: true)
        .then((Position position) {
      setState(() {
        currentPosition = position;
      });
    }).catchError((e) {
      print(e);
    });
  }

  uploadStudentExamToFirebase() {}
}
