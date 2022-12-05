import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:toolboard/shared/channel/app_channel.dart';
import 'package:toolboard/overlay/window_manager/main.dart';
import 'package:toolboard/overlay/window_manager/models.dart';
import 'package:toolboard/shared/controllers/settings.controller.dart';
import 'package:toolboard/shared/model/rect.dart';

class GridController extends GetxController {
  final currentArea = Rx<SnapArea?>(null);
  final prevArea = Rx<SnapArea?>(null);
  final settingsController = Get.put(SettingsController());

  Rx<RectEntry?> get currentRect {
    return _getRect(currentArea.value ?? prevArea.value).obs;
  }

  late final _windowManager = WindowManager(
    calc: AreaCalculator(
      config: settingsController.config.value,
      screen: ScreenData(
        heightDiff: 0,
        offsetTop: 0,
        rect: RectEntry(
          size: const Size(0, 0),
          offset: const Offset(0, 0),
        ),
      ),
    ),
    channel: AppChannel.instance,
    onMove: _onMoveWindow,
    onDone: _onMoveDone,
  );

  @override
  onInit() {
    _windowManager.listen();
    settingsController.config.listen((config) {
      _windowManager.calc.config = config;
    });
    super.onInit();
  }

  RectEntry? _getRect(SnapArea? area) {
    if (area != null) {
      var rect = _windowManager.calc.fromSnapArea(area);
      if (rect?.offset != null) {
        // print(_windowManager.calc.screen.rect.offset);
        // print(_windowManager.calc.screen.heightDiff);
        // // rect!.offset = Offset(rect.offset.dx,
        // //     rect.offset.dy - _windowManager.calc.screen.topOffset);
        rect!.offset = Offset(
          rect.offset.dx - _windowManager.calc.screen.rect.offset.dx,
          rect.offset.dy - _windowManager.calc.screen.rect.offset.dy,
        );
      }
      return rect;
    }

    return null;
  }

  _onMoveWindow(SnapArea? area) {
    if (area == null && currentArea.value != null) {
      prevArea.value = currentArea.value;
    }
    currentArea.value = area;
  }

  _onMoveDone(SnapArea? _) {
    if (currentArea.value != null) {
      prevArea.value = currentArea.value;
    }
    currentArea.value = null;
  }
}
