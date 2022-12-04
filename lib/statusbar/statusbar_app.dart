import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:toolboard/shared/controllers/settings.controller.dart';
import 'package:toolboard/statusbar/config.dart';
import 'package:toolboard/statusbar/settings_view.dart';

class StatusbarApp extends StatelessWidget {
  const StatusbarApp({super.key});

  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      debugShowCheckedModeBanner: false,
      theme: lightTheme,
      darkTheme: darkTheme,
      home: Wrapper(),
    );
  }
}

class Wrapper extends StatelessWidget {
  final controller = Get.put(SettingsController());
  Wrapper({super.key});

  @override
  Widget build(BuildContext context) {
    return Obx(
      () => Theme(
        data: Theme.of(context)
            .copyWith(primaryColor: controller.accentColor.value),
        child: const Scaffold(
            backgroundColor: Colors.transparent,
            body: Center(
              child: SettingsView(),
            )),
      ),
    );
  }
}
