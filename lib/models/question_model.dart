class QuestionModal {
  String? examId;
  num? max;
  String? question;

  QuestionModal({
    this.examId,
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
      'max': max,
      'question': question,
    };
  }

  QuestionModal.fromSnapshot(snapshot) : question = snapshot.data()['question'];
}
