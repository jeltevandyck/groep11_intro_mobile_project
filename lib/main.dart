import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:groep11_intro_mobile_project/pages/Login-dashboard/student_login_page.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: const FirebaseOptions(
      apiKey: "AIzaSyBst5neVVQUOheg8wur9JnXyuUSDJMezbo",
      appId: "1:1050149621647:android:b5ae192a1f1ef3f4a5c5fa",
      messagingSenderId: "1050149621647",
      projectId: "groep11-intro-mobile",
    ),
  );
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Login page',
      theme: ThemeData(primarySwatch: Colors.red),
      home: const StudentLoginPage(),
    );
  }
}
