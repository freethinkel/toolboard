import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:toolboard/shared/components/quit_info.dart';
import 'package:toolboard/shared/components/switch.dart';
import 'package:toolboard/shared/store/helpers.dart';
import 'package:toolboard/shared/store/settings.dart';

class SettingsView extends StatefulWidget {
  const SettingsView({super.key});

  @override
  State<SettingsView> createState() => _SettingsViewState();
}

class _SettingsViewState extends State<SettingsView> {
  @override
  Widget build(BuildContext context) {
    return StoreBuilder<SettingsValue, SettingsStore>(
      store: settingsStore,
      builder: (context, store) => Container(
        child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Expanded(
                child: Column(
                  children: [
                    TextButton(onPressed: () {}, child: Text("adasdas")),
                    TBSwitch(
                      value: store.windowManagerEnable,
                      onChange: (state) {
                        settingsStore.changeWindowManagerEnable(state);
                      },
                      child: const Text("WindowManager"),
                    ),
                  ],
                ),
              ),
              const QuitInfo()
            ]),
      ),
    );
  }
}
