import 'dart:ui';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';

class AdminLoginPage extends StatefulWidget {
  const AdminLoginPage({Key? key}) : super(key: key);

  @override
  State<AdminLoginPage> createState() => _AdminLoginPageState();
}

class _AdminLoginPageState extends State<AdminLoginPage> {
  final _formKey = GlobalKey<FormState>();

  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();

  final _auth = FirebaseAuth.instance;

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
          prefixIcon: const Icon(Icons.mail),
          contentPadding: const EdgeInsets.fromLTRB(20, 15, 20, 15),
          hintText: 'Email',
          border: OutlineInputBorder(borderRadius: BorderRadius.circular(30))),
    );
    final passwordField = TextFormField(
      autofocus: false,
      controller: passwordController,
      validator: (value) {
        RegExp regexp = RegExp(r'^.{6,}$');
        if (value!.isEmpty) {
          return ("Please enter your password.");
        }
        if (!regexp.hasMatch(value)) {
          return ('Please enter a valid password.');
        }
        return null;
      },
      onSaved: (value) {
        passwordController.text = value!;
      },
      obscureText: true,
      textInputAction: TextInputAction.done,
      decoration: InputDecoration(
          fillColor: Colors.white,
          filled: true,
          prefixIcon: const Icon(Icons.vpn_key),
          contentPadding: const EdgeInsets.fromLTRB(20, 15, 20, 15),
          hintText: 'Password',
          border: OutlineInputBorder(borderRadius: BorderRadius.circular(30))),
    );

    final loginButton = Material(
        elevation: 5,
        borderRadius: BorderRadius.circular(30),
        color: Colors.red,
        child: Container(
          width: 200,
          child: MaterialButton(
            padding: const EdgeInsets.fromLTRB(20, 15, 20, 15),
            minWidth: MediaQuery.of(context).size.width,
            onPressed: () {
              signIn(emailController.text, passwordController.text);
            },
            child: const Text('Login',
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
            appBar: AppBar(
              backgroundColor: Colors.transparent,
              leading: IconButton(
                icon: const Icon(
                  Icons.arrow_back,
                  color: Colors.red,
                ),
                onPressed: () {
                  Navigator.of(context).pop();
                },
              ),
              title: const Text(
                "Student login",
                style: TextStyle(fontWeight: FontWeight.bold, fontSize: 20),
                textAlign: TextAlign.center,
              ),
            ),
            backgroundColor: Colors.transparent,
            body: Center(
              child: SingleChildScrollView(
                child: Padding(
                  padding: const EdgeInsets.all(260.0),
                  child: Form(
                    key: _formKey,
                    child: Column(
                      children: <Widget>[
                        emailField,
                        const SizedBox(
                          height: 30,
                        ),
                        passwordField,
                        const SizedBox(
                          height: 60,
                        ),
                        loginButton
                      ],
                    ),
                  ),
                ),
              ),
            ),
          ),
        ),
      ),
    );

    return Container(
      constraints: const BoxConstraints.expand(),
      child: backgroundImage,
    );
  }

  void signIn(String email, String password) async {
    if (_formKey.currentState!.validate()) {
      await _auth
          .signInWithEmailAndPassword(email: email, password: password)
          .then((uid) => Fluttertoast.showToast(msg: "Login Succesful"));
    }
  }
}
