import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:toolboard/shared/controllers/settings.controller.dart';
import 'package:toolboard/statusbar/components/quit_info.dart';
import 'package:toolboard/statusbar/components/switch.dart';

class SettingsView extends StatefulWidget {
  const SettingsView({super.key});

  @override
  State<SettingsView> createState() => _SettingsViewState();
}

class _SettingsViewState extends State<SettingsView> {
  final controller = Get.put(SettingsController());

  @override
  Widget build(BuildContext context) {
    return Obx(
      () => Padding(
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
                          value: controller.caffeinateEnabled.value,
                          onChange: (state) {
                            controller.caffeinateEnabled.value = state;
                          },
                          child: const Text(
                            "Caffeinate",
                            style: TextStyle(fontSize: 13),
                          ),
                        ),
                        TBSwitch(
                          value: controller.windowManagerEnabled.value,
                          onChange: (state) {
                            controller.windowManagerEnabled.value = state;
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
