import 'package:cloud_firestore/cloud_firestore.dart';

class ExamModel {
  String? name;
  Timestamp? startDate;
  Timestamp? endDate;

  ExamModel({
    this.name,
    this.startDate,
    this.endDate,
  });

  factory ExamModel.fromMap(map) {
    return ExamModel(
      name: map['name'],
      startDate: map['startDate'],
      endDate: map['endDate'],
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'name': name,
      'startDate': startDate,
      'endDate': endDate,
    };
  }
}
