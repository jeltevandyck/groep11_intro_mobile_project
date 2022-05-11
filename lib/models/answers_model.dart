class AnswerModel {
  String? answer;
  String? grade;
  String? questionId;
  String? userId;

  AnswerModel({
    this.answer,
    this.grade,
    this.questionId,
    this.userId,
  });

  factory AnswerModel.fromMap(map) {
    return AnswerModel(
      answer: map['answer'],
      grade: map['grade'],
      questionId: map['questionId'],
      userId: map['userId'],
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'answer': answer,
      'grade': grade,
      'questionId': questionId,
      'userId': userId,
    };
  }

  AnswerModel.fromSnapshot(snapshot)
      : answer = snapshot.data()['answer'],
        grade = snapshot.data()['grade'],
        questionId = snapshot.data()['questionId'],
        userId = snapshot.data()['userId'];
}
