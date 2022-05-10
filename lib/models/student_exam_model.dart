import 'package:cloud_firestore/cloud_firestore.dart';

class StudentExamModel {
  String? uid;
  String? userId;
  String? latitude;
  String? longitude;

  StudentExamModel({
    this.uid,
    this.userId,
    this.latitude,
    this.longitude,
  });

  factory StudentExamModel.fromMap(map) {
    return StudentExamModel(
      uid: map['uid'],
      userId: map['userId'],
      latitude: map['latitude'],
      longitude: map['longitude'],
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'uid': uid,
      'userId': userId,
      'latitude': latitude,
      'longitude': longitude,
    };
  }
}
