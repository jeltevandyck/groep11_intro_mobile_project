class StudentModel {
  String? fullName;
  String? accountNumber;
  String? examDone;

  StudentModel({
    this.fullName,this.accountNumber,this.examDone
  });

  factory StudentModel.fromMap(map){
    return StudentModel(
      fullName: map['fullName'],
      accountNumber: map['accountNumber'],
      examDone: map['examDone'],
    );
  }

  Map<String, dynamic> toMap(){
    return{
      'fullName': fullName,
      'accountNumber': accountNumber,
      'examDone': examDone,
    };
  }

}