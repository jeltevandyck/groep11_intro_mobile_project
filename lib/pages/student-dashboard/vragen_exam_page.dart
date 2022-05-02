import 'package:flutter/material.dart';

class VragenExamPage extends StatefulWidget {
  const VragenExamPage({Key? key}) : super(key: key);

  @override
  State<VragenExamPage> createState() => _VragenExamPageState();
}

class _VragenExamPageState extends State<VragenExamPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(body: lijstVragen());
  }

  Widget lijstVragen() {
    return Center(
      child: Table(
        children: const <TableRow>[
          TableRow(
            children: <Widget>[Text('Vraag')],
          ),
        ],
      ),
    );
  }
}
