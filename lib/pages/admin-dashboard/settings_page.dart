import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:groep11_intro_mobile_project/pages/Login-dashboard/student_login_page.dart';

class SettingsPage extends StatefulWidget {
  const SettingsPage({Key? key}) : super(key: key);

  @override
  State<SettingsPage> createState() => _SettingsPageState();
}

class _SettingsPageState extends State<SettingsPage> {
  final TextEditingController passwordController = TextEditingController();
  final _formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
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
                  logOut();
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
                  passwordField,
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
                            changePassword(passwordController.text.trim());
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

  void changePassword(String password) async {
    User user = FirebaseAuth.instance.currentUser!;

    user.updatePassword(password).then((_) {
      Fluttertoast.showToast(msg: "Password changed successfully");
    }).catchError((error) {
      Fluttertoast.showToast(msg: "Oops, something went wrong");
    });
  }

  void logOut() {
    Navigator.pushAndRemoveUntil(
        context,
        PageRouteBuilder(pageBuilder: (BuildContext context,
            Animation animation, Animation secondaryAnimation) {
          return const StudentLoginPage();
        }, transitionsBuilder: (BuildContext context,
            Animation<double> animation,
            Animation<double> secondaryAnimation,
            Widget child) {
          return SlideTransition(
            position: Tween<Offset>(
              begin: const Offset(1.0, 0.0),
              end: Offset.zero,
            ).animate(animation),
            child: child,
          );
        }),
        (Route route) => false);
  }
}
