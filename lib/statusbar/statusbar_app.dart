import 'package:flutter/material.dart';
import 'package:toolboard/shared/store/helpers.dart';
import 'package:toolboard/shared/store/settings.dart';
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
      home: StoreBuilder<SettingsValue, SettingsStore>(
        store: settingsStore,
        builder: (context, store) => Theme(
          data: Theme.of(context).copyWith(primaryColor: store.accentColor),
          child: const Scaffold(
              backgroundColor: Colors.transparent,
              body: Center(
                child: SettingsView(),
              )),
        ),
      ),
    );
  }
}
