import 'package:flutter/material.dart';
import 'package:toolboard/shared/model/rect.dart';

class WindowInfo {
  String processId;
  String bundleId;
  String name;
  WindowInfo(
      {required this.processId, required this.bundleId, required this.name});

  static WindowInfo? fromMap(Map? data) {
    if (data != null) {
      return WindowInfo(
        processId: data['process_id'],
        bundleId: data['bundle_id'],
        name: data['name'],
      );
    }
    return null;
  }
}

class WindowFrameChangedEvent {
  RectEntry oldPosition;
  RectEntry newPosition;
  WindowInfo app;
  Offset mousePosition;

  WindowFrameChangedEvent({
    required this.app,
    required this.newPosition,
    required this.oldPosition,
    required this.mousePosition,
  });

  static WindowFrameChangedEvent? fromMap(Map data) {
    try {
      var app = WindowInfo.fromMap(data['app'])!;
      var mousePosition = Offset(
        data['mouse_position']['x'],
        data['mouse_position']['y'],
      );
      var oldPosition = RectEntry(
        offset: Offset(data['old']['x'], data['old']['y']),
        size: Size(data['old']['width'], data['old']['height']),
      );
      var newPosition = RectEntry(
        offset: Offset(data['new']['x'], data['new']['y']),
        size: Size(data['new']['width'], data['new']['height']),
      );
      return WindowFrameChangedEvent(
        app: app,
        newPosition: oldPosition,
        oldPosition: newPosition,
        mousePosition: mousePosition,
      );
    } catch (err) {
      return null;
    }
  }
}
