import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:toolboard/statusbar/components/quit_info.dart';
import 'package:toolboard/statusbar/components/switch.dart';
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
      builder: (context, store) => Padding(
        padding: EdgeInsets.zero,
        child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Expanded(
                child: Column(
                  children: [
                    Container(
                      padding: const EdgeInsets.symmetric(vertical: 10),
                      child: Column(children: [
                        TBSwitch(
                          value: store.enableCaffeinate,
                          onChange: (state) {
                            settingsStore.changeCaffeinate(state);
                          },
                          child: const Text(
                            "Caffeinate",
                            style: TextStyle(fontSize: 13),
                          ),
                        ),
                        TBSwitch(
                          value: store.windowManagerEnable,
                          onChange: (state) {
                            settingsStore.changeWindowManagerEnable(state);
                          },
                          child: const Text(
                            "Window Manager",
                            style: TextStyle(fontSize: 13),
                          ),
                        ),
                      ]),
                    )
                  ],
                ),
              ),
              const QuitInfo()
            ]),
      ),
    );
  }
}
