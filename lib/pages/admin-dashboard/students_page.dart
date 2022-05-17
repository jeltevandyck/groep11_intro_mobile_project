import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:csv/csv.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:groep11_intro_mobile_project/models/student_model.dart';
import 'package:groep11_intro_mobile_project/pages/admin-dashboard/add_students_page.dart';
import 'package:groep11_intro_mobile_project/pages/admin-dashboard/answers_page.dart';
import 'package:groep11_intro_mobile_project/pages/admin-dashboard/location_page.dart';

class StudentsPage extends StatefulWidget {
  const StudentsPage({Key? key}) : super(key: key);

  @override
  State<StudentsPage> createState() => _StudentsPageState();
}

class _StudentsPageState extends State<StudentsPage> {
  final _auth = FirebaseAuth.instance;

  final _formKey = GlobalKey<FormState>();

  String studentScore = "20";

  String? currentAddress;

  String _currentExitCounter = "";
  String _currentTimer = "";

  List<StudentModel> students = [];

  loadCSV(filePath) async {
    final myData = await rootBundle.loadString(filePath);
    List<List<dynamic>> csvTable = const CsvToListConverter().convert(myData);
    List<StudentModel> data = [];
    for (var row in csvTable) {
      for (var studentData in row) {
        final splittedValue = studentData.split(';');
        StudentModel studentModel = StudentModel();
        studentModel.accountNumber = splittedValue[0];
        studentModel.fullName = splittedValue[1];
        data.add(studentModel);
      }
    }
    students = data;
    uploadCSVToFirebase(students);
  }

  uploadCSVToFirebase(List<StudentModel> students) async {
    StudentModel studentModel = StudentModel();
    var firebaseFirestore = FirebaseFirestore.instance.collection("students");
    var snapshots = await firebaseFirestore.get();
    for (var doc in snapshots.docs) {
      await doc.reference.delete();
    }

    for (var i = 1; i < students.length; i++) {
      studentModel.accountNumber = students[i].accountNumber;
      studentModel.fullName = students[i].fullName;

      await firebaseFirestore
          .doc(studentModel.accountNumber)
          .set(studentModel.toMap());
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        floatingActionButtonLocation: FloatingActionButtonLocation.endDocked,
        floatingActionButton: SizedBox(
            height: 100,
            width: 120,
            child: Container(
              margin: const EdgeInsets.only(bottom: 10.0),
              child: FloatingActionButton(
                  child: const Text("Enter CSV"),
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => const AddStudentsPage()),
                    );
                  }),
            )),
        appBar: AppBar(
          automaticallyImplyLeading: false,
          title: const Text("Students"),
          centerTitle: true,
        ),
        body: StreamBuilder<QuerySnapshot>(
          stream: FirebaseFirestore.instance.collection("students").snapshots(),
          builder: (context, snapshot) {
            if (snapshot.hasError) {
              return const Text("Something went wrong");
            } else if (snapshot.hasData || snapshot != null) {
              return ListView.builder(
                shrinkWrap: true,
                itemCount: snapshot.data?.docs.length,
                itemBuilder: (BuildContext context, int index) {
                  QueryDocumentSnapshot<Object?>? documentSnapshot =
                      snapshot.data?.docs[index];
                  return Dismissible(
                      key: Key(index.toString()),
                      child: Card(
                        elevation: 5,
                        child: ListTile(
                          title: Text((documentSnapshot != null)
                              ? (documentSnapshot["accountNumber"])
                              : ""),
                          subtitle: Text((documentSnapshot != null)
                              ? (documentSnapshot["fullName"])
                              : ""),
                          onTap: () {
                            showStudentInformation(
                                documentSnapshot!["accountNumber"],
                                documentSnapshot["fullName"]);
                          },
                        ),
                      ));
                },
              );
            }
            return const Text("No students available");
          },
        ));
  }

  void showScoreChange() {
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
                          TextField(
                            controller: scoreController,
                            onChanged: (value) {
                              scoreController.text = value;
                            },
                            decoration: const InputDecoration(
                                border: OutlineInputBorder(),
                                hintText: "New Score"),
                          ),
                        ],
                      )));
                },
              ));
        });
  }

  void showStudentInformation(accountNr, fullname) async {
    await getCurrentExitCounter(accountNr);
    await getCurrentTimer(accountNr);
    final answersButton = Material(
        elevation: 5,
        borderRadius: BorderRadius.circular(30),
        color: Colors.red,
        child: SizedBox(
          width: 200,
          child: MaterialButton(
            padding: const EdgeInsets.fromLTRB(20, 15, 20, 15),
            minWidth: MediaQuery.of(context).size.width,
            onPressed: () {
              showAnswers(accountNr);
            },
            child: const Text('Answers',
                textAlign: TextAlign.center,
                style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 20,
                    color: Colors.white)),
          ),
        ));
    final locationButton = Material(
        elevation: 5,
        borderRadius: BorderRadius.circular(30),
        color: Colors.red,
        child: SizedBox(
          width: 200,
          child: MaterialButton(
            padding: const EdgeInsets.fromLTRB(20, 15, 20, 15),
            minWidth: MediaQuery.of(context).size.width,
            onPressed: () {
              showLocation(accountNr);
            },
            child: const Text('Location',
                textAlign: TextAlign.center,
                style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 20,
                    color: Colors.white)),
          ),
        ));
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
                      height: height - 400,
                      width: width - 400,
                      child: Scaffold(
                          appBar: AppBar(
                            automaticallyImplyLeading: true,
                            title: Text("$fullname ($accountNr)"),
                            centerTitle: true,
                          ),
                          body: Column(
                            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                            children: [
                              Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Text("Score: $studentScore"),
                                ],
                              ),
                              Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceEvenly,
                                children: [
                                  Text("the student closed the exam $_currentExitCounter times")
                                ],
                              ),Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceEvenly,
                                children: [
                                  Text("Time spend for the exam $_currentTimer")
                                ],
                              ),
                              Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceEvenly,
                                children: [
                                  answersButton,
                                  locationButton,
                                ],
                              )
                            ],
                          )));
                },
              ));
        });
  }

  getCurrentExitCounter(accountNr) async {
    QuerySnapshot collection = await FirebaseFirestore.instance
        .collection("student_exams")
        .where("userId", isEqualTo: accountNr)
        .get();
      setState(() => _currentExitCounter = collection.docs.first["exitCounter"]);
  }
  getCurrentTimer(accountNr) async {
    QuerySnapshot collection = await FirebaseFirestore.instance
        .collection("student_exams")
        .where("userId", isEqualTo: accountNr)
        .get();
      setState(() => _currentTimer = collection.docs.first["endExam"]);
  }

  Future<QuerySnapshot<Object?>> getStudentExam(accountNr) async {
    QuerySnapshot collection = await FirebaseFirestore.instance
        .collection("student_exams")
        .where("userId", isEqualTo: accountNr)
        .get();
      return collection;
  }

  void showLocation(accountNr) async {
    QuerySnapshot collection = await FirebaseFirestore.instance
        .collection("student_exams")
        .where("userId", isEqualTo: accountNr)
        .get();
    Navigator.push(
        context, MaterialPageRoute(builder: (context) => LocationPage(lat: collection.docs.first["latitude"], lon: collection.docs.first["longitude"])));
  }
  void showAnswers(accountNr) async {
    Navigator.push(
        context, MaterialPageRoute(builder: (context) => AnswersPage(accountNr: accountNr,)));
  }
}
