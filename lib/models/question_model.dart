class QuestionModal {
  String? examId;
  num? examType;
  num? max;
  String? question;
  String? answers;
  String? solution;
  bool? caseSensitive;
  String? correctCode;
  String? wrongCode;

  QuestionModal({
    this.examId,
    this.examType,
    this.max,
    this.question,
    this.answers,
    this.solution,
    this.caseSensitive,
    this.correctCode,
    this.wrongCode,
  });

  factory QuestionModal.fromMap(map) {
    return QuestionModal(
        examId: map['examId'],
        examType: map['examType'],
        max: map['max'],
        question: map['question'],
        answers: map['answers'],
        solution: map['solution'],
        caseSensitive: map['caseSensitive'],
        correctCode: map['correctCode'],
        wrongCode: map['wrongCode']);
  }

  Map<String, dynamic> toMap() {
    return {
      'examId': examId,
      'examType': examType,
      'max': max,
      'question': question,
      'answers': answers,
      'solution': solution,
      'caseSensitive': caseSensitive,
      'correctCode': correctCode,
      'wrongCode': wrongCode
    };
  }

  QuestionModal.fromSnapshot(snapshot)
      : question = snapshot.data()['question'],
        examId = snapshot.data()['examId'],
        examType = snapshot.data()['examType'],
        max = snapshot.data()['max'],
        answers = snapshot.data()['answers'],
        solution = snapshot.data()['solution'],
        caseSensitive = snapshot.data()['caseSensitive'],
        correctCode = snapshot.data()['correctCode'],
        wrongCode = snapshot.data()['wrongCode'];
}
