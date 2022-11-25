import 'package:flutter/material.dart';

class StatusbarApp extends StatelessWidget {
  const StatusbarApp({super.key});

  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      home: Scaffold(
          body: Center(
        child: Text('statusbar'),
      )),
    );
  }
}
