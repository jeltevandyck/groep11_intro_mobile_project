import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:groep11_intro_mobile_project/models/question_model.dart';
import 'package:groep11_intro_mobile_project/pages/student-dashboard/questionCard.dart';

class VragenExamPage extends StatefulWidget {
  const VragenExamPage({Key? key}) : super(key: key);

  @override
  State<VragenExamPage> createState() => _VragenExamPageState();
}

class _VragenExamPageState extends State<VragenExamPage> {
  List<QuestionModal> _questions = [];

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    getQuestions();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Vragen'),
        automaticallyImplyLeading: false,
      ),
      body: SafeArea(
          child: ListView.builder(
              itemCount: _questions.length,
              itemBuilder: (context, index) {
                return QuestionCard(_questions[index]);
              })),
    );
  }

  Future getQuestions() async {
    var data = await FirebaseFirestore.instance.collection('questions').get();
    setState(() {
      _questions =
          List.from(data.docs.map((doc) => QuestionModal.fromSnapshot(doc)));
    });
  }
}
