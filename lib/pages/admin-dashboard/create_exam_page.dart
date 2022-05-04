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

  final TextEditingController examNameController = TextEditingController();
  List<ExamModel> exams = [];

  @override
  void initState() {
    super.initState();
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
          return createExamButton();
        } else {
          QueryDocumentSnapshot<Object?>? documentSnapshot =
              snapshot.data?.docs.first;
          return Center(
            child: Container(
              height: 150,
              width: 500,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(20),
                color: const Color.fromRGBO(255, 255, 255, 0.8),
                boxShadow: [
                  BoxShadow(
                    color: Colors.grey.withOpacity(0.5),
                    spreadRadius: 5,
                    blurRadius: 7,
                  ),
                ],
              ),
              child: Column(
                children: <Widget>[
                  const SizedBox(height: 10),
                  Text(
                    (documentSnapshot != null)
                        ? (documentSnapshot["name"])
                        : "",
                    style: const TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.w100,
                      fontFamily: "Varela",
                      color: Colors.black,
                    ),
                  ),
                  OutlinedButton(
                    style: TextButton.styleFrom(
                      primary: Colors.red,
                      padding: const EdgeInsets.all(20),
                    ),
                    child: const Text("Edit"),
                    onPressed: () {},
                  ),
                  ElevatedButton(
                    style: TextButton.styleFrom(
                      primary: Colors.red,
                      padding: const EdgeInsets.all(20),
                    ),
                    child: const Text("Remove",
                        style: TextStyle(color: Colors.white)),
                    onPressed: () {},
                  ),
                ],
              ),
            ),
          );
        }
      },
    ));
  }

  Widget createExamButton() {
    return Center(
      child: TextButton(
        onPressed: () {
          showDialog(
              context: context,
              builder: (BuildContext context) {
                return createDialog();
              });
        },
        child: const Text('Create Exam'),
        style: OutlinedButton.styleFrom(
          primary: Colors.red,
          padding: const EdgeInsets.symmetric(horizontal: 30, vertical: 20),
        ),
      ),
    );
  }

  Widget createDialog() {
    final examNameField = TextField(
      autofocus: false,
      keyboardType: TextInputType.text,
      controller: examNameController,
      decoration: InputDecoration(
          fillColor: Colors.white,
          filled: true,
          prefixIcon: const Icon(Icons.account_circle),
          contentPadding: const EdgeInsets.fromLTRB(20, 15, 20, 15),
          hintText: 'Exam Name',
          border: OutlineInputBorder(borderRadius: BorderRadius.circular(30))),
    );

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
            //Navigator.of(context).pop();
          },
        ),
        TextButton(
          child: const Text('Create', style: TextStyle(color: Colors.green)),
          onPressed: () {
            pushExamToDatabase();
            //Navigator.of(context).pop();
          },
        ),
      ],
    );
  }

  pushExamToDatabase() async {
    FirebaseFirestore firestore = FirebaseFirestore.instance;
    //create uuid
    String uuid = const Uuid().v4();

    await firestore
        .collection('exams')
        .doc()
        .set({'name': examNameController.text});

    Fluttertoast.showToast(msg: 'Exam added');
  }
}
