import 'dart:ui';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:groep11_intro_mobile_project/pages/student-dashboard/start_exam_page.dart';

import 'admin_login_page.dart';

class StudentLoginPage extends StatefulWidget {
  const StudentLoginPage({Key? key}) : super(key: key);

  @override
  State<StudentLoginPage> createState() => _StudentLoginPageState();
}

class _StudentLoginPageState extends State<StudentLoginPage> {
  final _formKey = GlobalKey<FormState>();

  final _auth = FirebaseAuth.instance;

  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    final emailField = TextFormField(
      autofocus: false,
      controller: emailController,
      keyboardType: TextInputType.emailAddress,
      validator: (value) {
        if (value!.isEmpty) {
          return ("Please enter your email.");
        }
        if (!RegExp("^[a-zA-Z0-9+_.-]+@[a-zA-Z0-9.-]+.[a-z]").hasMatch(value)) {
          return ('Please enter a valid email.');
        }
        return null;
      },
      onSaved: (value) {
        emailController.text = value!;
      },
      textInputAction: TextInputAction.next,
      decoration: InputDecoration(
          fillColor: Colors.white,
          filled: true,
          prefixIcon: const Icon(Icons.account_circle),
          contentPadding: const EdgeInsets.fromLTRB(20, 15, 20, 15),
          hintText: 'Email',
          border: OutlineInputBorder(borderRadius: BorderRadius.circular(30))),
    );

    final loginButton = Material(
        elevation: 5,
        borderRadius: BorderRadius.circular(30),
        color: Colors.red,
        child: SizedBox(
          width: 200,
          child: MaterialButton(
            padding: const EdgeInsets.fromLTRB(20, 15, 20, 15),
            minWidth: MediaQuery.of(context).size.width,
            onPressed: () {
              signIn(emailController.text);
            },
            child: const Text('Login',
                textAlign: TextAlign.center,
                style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 20,
                    color: Colors.white)),
          ),
        ));

    final adminButton = Material(
        elevation: 5,
        borderRadius: BorderRadius.circular(30),
        color: Colors.red,
        child: SizedBox(
          width: 200,
          child: MaterialButton(
            padding: const EdgeInsets.fromLTRB(20, 15, 20, 15),
            minWidth: MediaQuery.of(context).size.width,
            onPressed: () {
              Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (context) => const AdminLoginPage()));
            },
            child: const Text('Admin login',
                textAlign: TextAlign.center,
                style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 20,
                    color: Colors.white)),
          ),
        ));

    final backgroundImage = Container(
      decoration: const BoxDecoration(
        image: DecorationImage(
          image: AssetImage('assets/images/ap2.jpg'),
          fit: BoxFit.cover,
        ),
      ),
      child: BackdropFilter(
        filter: ImageFilter.blur(sigmaX: 5.0, sigmaY: 5.0),
        child: Container(
          decoration: BoxDecoration(color: Colors.white.withOpacity(0.0)),
          child: Scaffold(
              backgroundColor: Colors.transparent,
              body: StreamBuilder<QuerySnapshot>(
                stream: FirebaseFirestore.instance
                    .collection("students")
                    .snapshots(),
                builder: (context, snapshot) {
                  if (snapshot.hasError) {
                    return const Text("Something went wrong");
                  } else if (snapshot.hasData) {
                    return ListView.builder(
                      shrinkWrap: true,
                      itemCount: snapshot.data?.docs.length,
                      itemBuilder: (BuildContext context, int index) {
                        QueryDocumentSnapshot<Object?>? documentSnapshot =
                            snapshot.data?.docs[index];
                        String accountNr = (documentSnapshot != null)
                            ? (documentSnapshot["accountNumber"])
                            : "";
                        String studentState = (documentSnapshot != null)
                            ? (documentSnapshot["examDone"])
                            : "";
                        String fullName = (documentSnapshot != null)
                            ? (documentSnapshot["fullName"])
                            : "";
                        if (studentState == "false") {
                          return Dismissible(
                              key: Key(index.toString()),
                              child: Card(
                                elevation: 5,
                                child: ListTile(
                                  title: Text((documentSnapshot != null)
                                      ? (documentSnapshot["accountNumber"])
                                      : ""),
                                  subtitle: Text((documentSnapshot != null)
                                      ? (documentSnapshot["fullName"])
                                      : ""),
                                  onTap: () => {
                                    Navigator.push(
                                        context,
                                        MaterialPageRoute(
                                            builder: (context) => StartExamPage(
                                                accountNr: accountNr,
                                                fullName: fullName)))
                                  },
                                ),
                              ));
                        }
                        return const SizedBox.shrink();
                      },
                    );
                  } else {
                    return const Text(
                        "There are no active exams at the moment");
                  }
                },
              )),
        ),
      ),
    );

    return Container(
      constraints: const BoxConstraints.expand(),
      child: Scaffold(
        floatingActionButtonLocation: FloatingActionButtonLocation.endDocked,
        floatingActionButton: SizedBox(
            height: 40,
            width: 150,
            child: Container(
              margin: const EdgeInsets.only(bottom: 10.0),
              child: FloatingActionButton(
                  child: const Text("Login as admin"),
                  shape: BeveledRectangleBorder(
                      borderRadius: BorderRadius.circular(4)),
                  onPressed: () {
                    Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => const AdminLoginPage()));
                  }),
            )),
        appBar: AppBar(
          title: const Text("Student Login"),
        ),
        body: backgroundImage,
      ),
    );
  }

  void signIn(String email) async {
    if (_formKey.currentState!.validate()) {
      await _auth
          .signInWithEmailAndPassword(email: email, password: "default")
          .then((uid) => Fluttertoast.showToast(msg: "Login Succesful"));
    }
  }
}
