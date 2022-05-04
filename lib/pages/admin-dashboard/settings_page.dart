import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';

class SettingsPage extends StatefulWidget {
  const SettingsPage({Key? key}) : super(key: key);

  @override
  State<SettingsPage> createState() => _SettingsPageState();
}

class _SettingsPageState extends State<SettingsPage> {
  final TextEditingController emailEditingController = TextEditingController();
  final _formKey = GlobalKey<FormState>();

  

  @override
  Widget build(BuildContext context) {
    final emailField = TextFormField(
    autofocus: false,
    controller: emailEditingController,
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
      emailEditingController.text = value!;
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
    return Scaffold(
      floatingActionButtonLocation: FloatingActionButtonLocation.endDocked,
      floatingActionButton: SizedBox(
          height: 100,
          width: 120,
          child: Container(
            margin: const EdgeInsets.only(bottom: 10.0),
            child: FloatingActionButton(
                child: const Text("Log Out"),
                onPressed: () {
                  //logout
                }),
          )),
      appBar: AppBar(
        automaticallyImplyLeading: false,
        title: const Text("Settings"),
        centerTitle: true,
      ),
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
                  ClipRRect(
                    borderRadius: BorderRadius.circular(4),
                    child: Stack(
                      children: <Widget>[
                        Positioned.fill(
                          child: Container(
                            decoration: const BoxDecoration(
                              gradient: LinearGradient(
                                colors: <Color>[
                                  Color(0xfff32e20),
                                  Color(0xffdf1b0c),
                                  Color.fromARGB(255, 0, 0, 0)
                                ],
                              ),
                            ),
                          ),
                        ),
                        TextButton(
                          style: TextButton.styleFrom(
                            padding: const EdgeInsets.all(16.0),
                            primary: Colors.white,
                            textStyle: const TextStyle(fontSize: 20),
                          ),
                          onPressed: () {
                            resetPassword();
                          },
                          child: const Text('Change password'),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  Future resetPassword() async {
    User? user = FirebaseAuth.instance.currentUser;
    await FirebaseAuth.instance.sendPasswordResetEmail(email: emailEditingController.text);

    Fluttertoast.showToast(msg: "Email has been sent to reset password");
  }
}
