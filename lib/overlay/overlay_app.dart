import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:toolboard/shared/controllers/settings.controller.dart';
import 'grid/grid_manager.dart';

class OverlayApp extends StatelessWidget {
  const OverlayApp({super.key});

  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      debugShowCheckedModeBanner: false,
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
        data: Theme.of(context).copyWith(
            primaryColor: controller.config.value.accentColor ??
                controller.accentColor.value),
        child: const Scaffold(
          backgroundColor: Colors.transparent,
          body: GridManager(),
        ),
      ),
    );
  }
}
