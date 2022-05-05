import 'package:cloud_firestore/cloud_firestore.dart';

class StudentExamModel {
  String? examId;
  String? userId;
  Timestamp? latitude;
  Timestamp? longitude;

  StudentExamModel({
    this.examId,
    this.userId,
    this.latitude,
    this.longitude,
  });

  factory StudentExamModel.fromMap(map) {
    return StudentExamModel(
      examId: map['examId'],
      userId: map['userId'],
      latitude: map['latitude'],
      longitude: map['longitude'],
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'examId': examId,
      'userId': userId,
      'latitude': latitude,
      'longitude': longitude,
    };
  }
}
