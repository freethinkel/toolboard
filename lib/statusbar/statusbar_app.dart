import 'package:flutter/material.dart';
import 'package:toolboard/statusbar/config.dart';
import 'package:toolboard/statusbar/settings_view.dart';

class StatusbarApp extends StatelessWidget {
  const StatusbarApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: lightTheme,
      darkTheme: darkTheme,
      home: const Scaffold(
          backgroundColor: Colors.transparent,
          body: Center(
            child: SettingsView(),
          )),
    );
  }
}
