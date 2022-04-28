import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:groep11_intro_mobile_project/models/exam_model.dart';
import 'package:uuid/uuid.dart';

class CreateExamPage extends StatefulWidget {
  const CreateExamPage({Key? key}) : super(key: key);

  @override
  State<CreateExamPage> createState() => _CreateExamPageState();
}

class _CreateExamPageState extends State<CreateExamPage> {
  final _auth = FirebaseAuth.instance;

  final TextEditingController examNameControler = TextEditingController();
  List<ExamModel> exams = [];

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: showExamData(),
      bottomNavigationBar: BottomNavigationBar(
        items: const <BottomNavigationBarItem>[
          BottomNavigationBarItem(
            icon: Icon(Icons.home),
            label: 'Exam',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.home),
            label: 'Students',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.settings),
            label: 'Settings',
          ),
        ],
      ),
    );
  }

  Widget showExamData() {
    if (exams.isEmpty) {
      final examNameField = TextField(
        autofocus: false,
        controller: examNameControler,
        keyboardType: TextInputType.text,
        decoration: InputDecoration(
            fillColor: Colors.white,
            filled: true,
            prefixIcon: const Icon(Icons.account_circle),
            contentPadding: const EdgeInsets.fromLTRB(20, 15, 20, 15),
            hintText: 'Exam Name',
            border:
                OutlineInputBorder(borderRadius: BorderRadius.circular(30))),
      );

      return Center(
        child: TextButton(
          onPressed: () {
            showDialog(
                context: context,
                builder: (BuildContext context) {
                  return AlertDialog(
                    title: const Text('Create a new exam'),
                    content: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: <Widget>[
                        examNameField,
                      ],
                    ),
                    actions: <Widget>[
                      TextButton(
                        child: const Text('Cancel'),
                        onPressed: () {
                          Navigator.of(context).pop();
                        },
                      ),
                      TextButton(
                        child: const Text('Create',
                            style: TextStyle(color: Colors.green)),
                        onPressed: () {
                          pushExamToDatabase();
                          Navigator.of(context).pop();
                        },
                      ),
                    ],
                  );
                });
          },
          child: const Text('Create Exam'),
          style: OutlinedButton.styleFrom(
            primary: Colors.red,
            padding: const EdgeInsets.symmetric(horizontal: 30, vertical: 20),
          ),
        ),
      );
    } else {
      return Center(
        child: ListView.builder(
            itemCount: exams.length,
            itemBuilder: (BuildContext context, int index) {
              return ListTile(
                title: Text(exams[index].name ?? 'No name'),
                onTap: () {
                  Navigator.of(context)
                      .pushNamed('/exam', arguments: exams[index]);
                },
              );
            }),
      );
    }
  }

  popExamsFromDatabase() async {
    FirebaseFirestore firestore = FirebaseFirestore.instance;
    List<ExamModel> examsList = [];

    //get exammodels from firebase
    QuerySnapshot querySnapshot = await firestore.collection('exams').get();
    querySnapshot.docs.forEach((doc) {
      examsList.add(ExamModel.fromMap(doc.data()));
    });

    return examsList;
  }

  pushExamToDatabase() async {
    FirebaseFirestore firestore = FirebaseFirestore.instance;
    //create uuid
    String uuid = const Uuid().v4();

    await firestore
        .collection('exams')
        .doc()
        .set({'name': examNameControler.text});

    Fluttertoast.showToast(msg: 'Exam added');
  }
}
