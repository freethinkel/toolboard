import 'package:flutter/material.dart';
import 'package:get/state_manager.dart';
import 'package:toolboard/channel/channel.dart';
import 'package:toolboard/overlay/window_manager/main.dart';
import 'package:toolboard/overlay/window_manager/models.dart';
import 'package:toolboard/shared/model/rect.dart';

class GridController extends GetxController {
  final currentArea = Rx<SnapArea?>(null);
  final prevArea = Rx<SnapArea?>(null);

  Rx<RectEntry?> get currentRect {
    return _getRect(currentArea.value ?? prevArea.value).obs;
  }

  late final _windowManager = WindowManager(
      channel: AppChannel.instance, onMove: _onMoveWindow, onDone: _onMoveDone);

  @override
  onInit() {
    _windowManager.listen();
    super.onInit();
  }

  RectEntry? _getRect(SnapArea? area) {
    if (area != null) {
      var rect = _windowManager.calc.fromSnapArea(area);
      if (rect?.offset != null) {
        rect!.offset = Offset(rect.offset.dx,
            rect.offset.dy - _windowManager.calc.screen.topOffset);
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
