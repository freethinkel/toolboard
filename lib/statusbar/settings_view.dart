import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:toolboard/shared/components/quit_info.dart';
import 'package:toolboard/shared/components/switch.dart';

class SettingsView extends StatefulWidget {
  const SettingsView({super.key});

  @override
  State<SettingsView> createState() => _SettingsViewState();
}

class _SettingsViewState extends State<SettingsView> {
  @override
  Widget build(BuildContext context) {
    return Container(
      child:
          Column(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
        Text("asdasdasd"),
        TextButton(onPressed: () {}, child: Text("adasdas")),
        TBSwitch(
          child: Text("WindowManager"),
          value: false,
          onChange: (state) {},
        ),
        QuitInfo()
      ]),
    );
  }
}
