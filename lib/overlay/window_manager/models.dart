import 'package:flutter/material.dart';
import 'package:toolboard/shared/model/rect.dart';

class WindowInfo {
  int id;
  Size frame;

  WindowInfo({required this.id, required this.frame});

  static WindowInfo fromMap(Map data) {
    return WindowInfo(
        id: data['id'],
        frame: Size(data['frame']['width'], data['frame']['height']));
  }
}

class ScreenData {
  double topOffset;
  RectEntry rect;

  ScreenData({required this.topOffset, required this.rect});

  static ScreenData fromMap(Map data) {
    return ScreenData(
        topOffset: data['position']['top_offset'],
        rect: RectEntry.fromMap(data));
  }
}

class MouseEvent {
  Offset position;
  WindowInfo? window;

  MouseEvent({required this.position, this.window});

  static MouseEvent? fromMap(Map data) {
    var window = data['window']['id'] != null && data['window']['id'] != 0
        ? WindowInfo.fromMap(data['window'])
        : null;
    return MouseEvent(position: Offset(data['x'], data['y']), window: window);
  }
}

enum SnapArea { left, right, full, topLeft, topRight, bottomLeft, bottomRight }
