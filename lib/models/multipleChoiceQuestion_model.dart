import 'dart:ffi';

import 'package:groep11_intro_mobile_project/models/question_model.dart';

class MultipleChoiceQuestionModel extends QuestionModal {
  late Choices choices;

  MultipleChoiceQuestionModel({
    String? examId,
    num? max,
    String? question,
    required Choices choices,
  }) : super(
          examId: examId,
          max: max,
          question: question,
        ) {
    this.choices = choices;
  }

  factory MultipleChoiceQuestionModel.fromMap(map) {
    return MultipleChoiceQuestionModel(
      examId: map['examId'],
      max: map['max'],
      question: map['question'],
      choices: Choices.fromMap(map['choices']),
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'examId': examId,
      'max': max,
      'question': question,
      'choices': choices.toMap(),
    };
  }

  MultipleChoiceQuestionModel.fromSnapshot(snapshot)
      : choices = snapshot.data()['choices'];
}

class Choices {
  Bool? correct;
  String? question;

  Choices({this.correct, this.question});

  factory Choices.fromMap(map) {
    return Choices(
      correct: map['correct'],
      question: map['question'],
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'correct': correct,
      'question': question,
    };
  }
}
