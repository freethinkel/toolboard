import 'package:flutter/material.dart';
import 'package:toolboard/overlay/grid/grid_manager.dart';
import 'package:toolboard/shared/store/helpers.dart';
import 'package:toolboard/shared/store/settings.dart';

class OverlayApp extends StatelessWidget {
  const OverlayApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: StoreBuilder<SettingsValue, SettingsStore>(
        store: settingsStore,
        builder: (context, store) => Theme(
          data: Theme.of(context).copyWith(primaryColor: store.accentColor),
          child: const Scaffold(
            backgroundColor: Colors.transparent,
            body: GridManager(),
          ),
        ),
      ),
    );
  }
}
