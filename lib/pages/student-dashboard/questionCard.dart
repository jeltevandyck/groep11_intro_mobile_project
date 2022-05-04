import 'package:flutter/material.dart';
import 'package:groep11_intro_mobile_project/models/question_model.dart';
import 'package:groep11_intro_mobile_project/pages/student-dashboard/question_page.dart';

class QuestionCard extends StatelessWidget {
  final QuestionModal _question;

  QuestionCard(this._question);

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
        onTap: () => Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => QuestionPage(question: _question),
              ),
            ),
        child: Card(
          child: Padding(
              padding: const EdgeInsets.all(12.0),
              child: Column(
                children: [
                  Row(
                    children: [
                      Padding(
                        padding: const EdgeInsets.only(bottom: 10.0),
                        child: Text("${_question.question}"),
                      )
                    ],
                  )
                ],
              )),
        ));
  }
}
