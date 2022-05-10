import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:groep11_intro_mobile_project/models/question_model.dart';

class QuestionPage extends StatefulWidget {
  final QuestionModal question;

  const QuestionPage({Key? key, required this.question}) : super(key: key);

  @override
  State<QuestionPage> createState() => _QuestionPageState();
}

class _QuestionPageState extends State<QuestionPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: const Text('Vraag'),
          automaticallyImplyLeading: true,
        ),
        body: Center(
          child: Text(
            "${widget.question.question}",
            style: const TextStyle(fontSize: 30),
          ),
        ));
  }
}
