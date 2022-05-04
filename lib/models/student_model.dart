class StudentModel {
  String? fullName;
  String? accountNumber;

  StudentModel({
    this.fullName,this.accountNumber
  });

  factory StudentModel.fromMap(map){
    return StudentModel(
      fullName: map['fullName'],
      accountNumber: map['accountNumber'],
    );
  }

  Map<String, dynamic> toMap(){
    return{
      'fullName': fullName,
      'accountNumber': accountNumber,
    };
  }

}