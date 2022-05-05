import 'dart:ffi';

import 'package:groep11_intro_mobile_project/models/question_model.dart';

class CompareQuestionModel extends QuestionModal {
  Bool? caseSesitive;
  String? correctCode;
  String? wrongCode;

  CompareQuestionModel({
    String? examId,
    num? max,
    String? question,
    Bool? caseSesitive,
    String? correctCode,
    String? wrongCode,
  }) : super(
          examId: examId,
          max: max,
          question: question,
        ) {
    this.caseSesitive = caseSesitive;
    this.correctCode = correctCode;
    this.wrongCode = wrongCode;
  }

  factory CompareQuestionModel.fromMap(map) {
    return CompareQuestionModel(
      examId: map['examId'],
      max: map['max'],
      question: map['question'],
      caseSesitive: map['caseSesitive'],
      correctCode: map['correctCode'],
      wrongCode: map['wrongCode'],
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'examId': examId,
      'max': max,
      'question': question,
      'caseSesitive': caseSesitive,
      'correctCode': correctCode,
      'wrongCode': wrongCode,
    };
  }
}
