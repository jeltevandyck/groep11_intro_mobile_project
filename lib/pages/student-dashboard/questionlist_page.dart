import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:groep11_intro_mobile_project/models/question_model.dart';
import 'package:groep11_intro_mobile_project/pages/student-dashboard/questionCard.dart';
import 'package:groep11_intro_mobile_project/pages/student-dashboard/start_exam_page.dart';

class VragenExamPage extends StatefulWidget {
  const VragenExamPage({Key? key}) : super(key: key);

  @override
  State<VragenExamPage> createState() => _VragenExamPageState();
}

class _VragenExamPageState extends State<VragenExamPage> {
  List<QuestionModal> _questions = [];

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    getQuestions();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Vragen'),
        automaticallyImplyLeading: false,
      ),
      body: Stack(children: [
        ListView.builder(
            itemCount: _questions.length,
            itemBuilder: (context, index) {
              return QuestionCard(_questions[index]);
            }),
        Align(
          alignment: Alignment.bottomCenter,
          child: Container(
            margin: const EdgeInsets.all(150),
            child: ElevatedButton(
              onPressed: () {
                _showMyDialog();
              },
              child: const Text('Beëndig Examen'),
              style: OutlinedButton.styleFrom(
                primary: Colors.white,
                padding:
                    const EdgeInsets.symmetric(horizontal: 30, vertical: 20),
                textStyle: const TextStyle(fontSize: 20),
                backgroundColor: Colors.red,
              ),
            ),
          ),
        )
      ]),
    );
  }

  Future<void> _showMyDialog() async {
    return showDialog<void>(
      context: context,
      barrierDismissible: false, // user must tap button!
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Ben je zeker dat je de examen wilt beëindigen?'),
          actions: <Widget>[
            TextButton(
              child: const Text('JA'),
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (context) => const StartExamPage()),
                );
              },
            ),
            TextButton(
              child: const Text('NEE'),
              onPressed: () => Navigator.pop(context),
            ),
          ],
        );
      },
    );
  }

  Future getQuestions() async {
    var data = await FirebaseFirestore.instance.collection('questions').get();
    setState(() {
      _questions =
          List.from(data.docs.map((doc) => QuestionModal.fromSnapshot(doc)));
    });
  }
}
