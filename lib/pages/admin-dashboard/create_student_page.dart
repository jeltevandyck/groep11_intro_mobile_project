// import 'dart:ui';

// import 'package:cloud_firestore/cloud_firestore.dart';
// import 'package:firebase_auth/firebase_auth.dart';
// import 'package:flutter/material.dart';
// import 'package:fluttertoast/fluttertoast.dart';
// import 'package:groep11_intro_mobile_project/Models/user_model.dart';

// class CreateStudentPage extends StatefulWidget {
//   const CreateStudentPage({Key? key}) : super(key: key);

//   @override
//   State<CreateStudentPage> createState() => _CreateStudentPageState();
// }

// class _CreateStudentPageState extends State<CreateStudentPage> {
//   final _auth = FirebaseAuth.instance;

//   final _formKey = GlobalKey<FormState>();

//   final TextEditingController accountNumberEditingController =
//       TextEditingController();
//   final TextEditingController emailEditingController = TextEditingController();
//   final TextEditingController firstNameEditingController =
//       TextEditingController();
//   final TextEditingController secondNameEditingController =
//       TextEditingController();
//   // final TextEditingController passwordEditingController =
//   //     TextEditingController();
//   // final TextEditingController confirmPasswordEditingController =
//   //     TextEditingController();
//   // final TextEditingController roleEditingController = TextEditingController();

//   @override
//   Widget build(BuildContext context) {
//     final firstNameField = TextFormField(
//       autofocus: false,
//       controller: firstNameEditingController,
//       keyboardType: TextInputType.name,
//       validator: (value) {
//         RegExp regexp = RegExp(r'^.{2,}$');
//         if (value!.isEmpty) {
//           return ("First Name is required!");
//         }
//         if (!regexp.hasMatch(value)) {
//           return ('Please enter a valid First Name (min. 2 characters).');
//         }
//         return null;
//       },
//       onSaved: (value) {
//         firstNameEditingController.text = value!;
//       },
//       textInputAction: TextInputAction.next,
//       decoration: InputDecoration(
//           fillColor: Colors.white,
//           filled: true,
//           prefixIcon: const Icon(Icons.account_circle),
//           contentPadding: const EdgeInsets.fromLTRB(20, 15, 20, 15),
//           hintText: 'First Name',
//           border: OutlineInputBorder(borderRadius: BorderRadius.circular(30))),
//     );

//     final secondNameField = TextFormField(
//       autofocus: false,
//       controller: secondNameEditingController,
//       keyboardType: TextInputType.name,
//       validator: (value) {
//         if (value!.isEmpty) {
//           return ("Second Name is required!");
//         }
//         return null;
//       },
//       onSaved: (value) {
//         secondNameEditingController.text = value!;
//       },
//       textInputAction: TextInputAction.next,
//       decoration: InputDecoration(
//           fillColor: Colors.white,
//           filled: true,
//           prefixIcon: const Icon(Icons.account_circle),
//           contentPadding: const EdgeInsets.fromLTRB(20, 15, 20, 15),
//           hintText: 'Second Name',
//           border: OutlineInputBorder(borderRadius: BorderRadius.circular(30))),
//     );

//     final emailField = TextFormField(
//       autofocus: false,
//       controller: emailEditingController,
//       keyboardType: TextInputType.emailAddress,
//       validator: (value) {
//         if (value!.isEmpty) {
//           return ("Please enter your email.");
//         }
//         if (!RegExp("^[a-zA-Z0-9+_.-]+@[a-zA-Z0-9.-]+.[a-z]").hasMatch(value)) {
//           return ('Please enter a valid email.');
//         }
//         return null;
//       },
//       onSaved: (value) {
//         emailEditingController.text = value!;
//       },
//       textInputAction: TextInputAction.next,
//       decoration: InputDecoration(
//           fillColor: Colors.white,
//           filled: true,
//           prefixIcon: const Icon(Icons.account_circle),
//           contentPadding: const EdgeInsets.fromLTRB(20, 15, 20, 15),
//           hintText: 'Email',
//           border: OutlineInputBorder(borderRadius: BorderRadius.circular(30))),
//     );

//     final accountNumberField = TextFormField(
//       autofocus: false,
//       controller: accountNumberEditingController,
//       keyboardType: TextInputType.name,
//       // validator: (value) {
//       //
//       // },
//       onSaved: (value) {
//         accountNumberEditingController.text = value!;
//       },
//       textInputAction: TextInputAction.next,
//       decoration: InputDecoration(
//           fillColor: Colors.white,
//           filled: true,
//           prefixIcon: const Icon(Icons.account_circle),
//           contentPadding: const EdgeInsets.fromLTRB(20, 15, 20, 15),
//           hintText: 'Account Number',
//           border: OutlineInputBorder(borderRadius: BorderRadius.circular(30))),
//     );

//     final createStudentButton = Material(
//         elevation: 5,
//         borderRadius: BorderRadius.circular(30),
//         color: Colors.red,
//         child: Container(
//           width: 200,
//           child: MaterialButton(
//             padding: const EdgeInsets.fromLTRB(20, 15, 20, 15),
//             minWidth: MediaQuery.of(context).size.width,
//             onPressed: () {
//               CreateStudent(emailEditingController.text);
//             },
//             child: const Text('Create student',
//                 textAlign: TextAlign.center,
//                 style: TextStyle(
//                     fontWeight: FontWeight.bold,
//                     fontSize: 20,
//                     color: Colors.white)),
//           ),
//         ));

//     final backgroundImage = Container(
//       decoration: const BoxDecoration(
//         image: DecorationImage(
//           image: AssetImage('assets/images/ap2.jpg'),
//           fit: BoxFit.cover,
//         ),
//       ),
//       child: BackdropFilter(
//         filter: ImageFilter.blur(sigmaX: 5.0, sigmaY: 5.0),
//         child: Container(
//           decoration: BoxDecoration(color: Colors.white.withOpacity(0.0)),
//           child: Scaffold(
//             backgroundColor: Colors.transparent,
//             body: Center(
//               child: SingleChildScrollView(
//                 child: Padding(
//                   padding: const EdgeInsets.all(260.0),
//                   child: Form(
//                     key: _formKey,
//                     child: Column(
//                       children: <Widget>[
//                         firstNameField,
//                         const SizedBox(
//                           height: 30,
//                         ),
//                         secondNameField,
//                         const SizedBox(
//                           height: 30,
//                         ),
//                         emailField,
//                         const SizedBox(
//                           height: 30,
//                         ),
//                         accountNumberField,
//                         const SizedBox(
//                           height: 30,
//                         ),
//                         // passwordField,
//                         // const SizedBox(
//                         //   height: 30,
//                         // ),
//                         // confirmPasswordField,
//                         // const SizedBox(
//                         //   height: 30,
//                         // ),
//                         createStudentButton,
//                         const SizedBox(
//                           height: 60,
//                         ),
//                       ],
//                     ),
//                   ),
//                 ),
//               ),
//             ),
//           ),
//         ),
//       ),
//     );

//     return Container(
//       constraints: const BoxConstraints.expand(),
//       child: backgroundImage,
//     );
//   }

//   void CreateStudent(String email) async {
//     const defaultPassword = "default";

//     if (_formKey.currentState!.validate()) {
//       await _auth
//           .createUserWithEmailAndPassword(
//               email: email, password: defaultPassword)
//           .then((value) => {postDetailsToFirestore()})
//           .catchError((e) {
//         Fluttertoast.showToast(msg: e!.message);
//       });
//     }
//   }


// //Moet aangepast worden aangezien datamodel is aangepast als het zou gebruikt worden
//   postDetailsToFirestore() async {
//     FirebaseFirestore firebaseFirestore = FirebaseFirestore.instance;
//     User? user = _auth.currentUser;
//     UserModel userModel = UserModel();

//     userModel.uid = user!.uid;
//     userModel.email = user.email;
//     userModel.firstName = firstNameEditingController.text;
//     userModel.secondName = secondNameEditingController.text;
//     userModel.accountNumber = accountNumberEditingController.text;
//     userModel.role = "STUDENT";

//     await firebaseFirestore
//         .collection("users")
//         .doc(user.uid)
//         .set(userModel.toMap());

//     Fluttertoast.showToast(msg: "The student has been created succesfully!");
//   }
// }
