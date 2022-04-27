class UserModel {
  String? uid;
  String? firstName;
  String? secondName;
  String? email;
  String? accountNumber;
   String? role;

  UserModel({
    this.uid, this.firstName, this.secondName, this.email, this.accountNumber, this.role
  });

  factory UserModel.fromMap(map){
    return UserModel(
      uid: map['uid'],
      firstName: map['firstName'],
      secondName: map['secondName'],
      email: map['email'],
      accountNumber: map['accountNumber'],
      role: map['role'],
    );
  }

  Map<String, dynamic> toMap(){
    return{
      'uid': uid,
      'firstName': firstName,
      'secondName': secondName,
      'email': email,
      'accountNumber': accountNumber,
      'role': role,
    };
  }

}