import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:groep11_intro_mobile_project/models/user_model.dart';

class ExamModel {
  String? uid;
  String? name;
  Timestamp? startDate;
  Timestamp? endDate;

  ExamModel({
    this.uid,
    this.name,
    this.startDate,
    this.endDate,
  });

  factory ExamModel.fromMap(map) {
    return ExamModel(
      uid: map['uid'],
      name: map['name'],
      startDate: map['startDate'],
      endDate: map['endDate'],
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'uid': uid,
      'name': name,
      'startDate': startDate,
      'endDate': endDate,
    };
  }
}
