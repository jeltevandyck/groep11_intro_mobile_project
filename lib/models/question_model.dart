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
  });

  factory QuestionModal.fromMap(map) {
    return QuestionModal(
      examId: map['examId'],
      max: map['max'],
      question: map['question'],
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'examId': examId,
      'examType': examType,
      'max': max,
      'question': question,
    };
  }

  QuestionModal.fromSnapshot(snapshot) : question = snapshot.data()['question'];
}
