import 'dart:convert';
import 'dart:developer';
import 'package:flutter/material.dart';
import 'package:toolboard/channel/channel.dart';

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

class _AreaCalculator {
  Size screen;
  _AreaCalculator({required this.screen});
  final _diff = 8;

  SnapArea? fromMouseEvent(MouseEvent event) {
    if (event.window == null) {
      return null;
    }
    if (event.position.dx > (screen.width - screen.width / _diff) &&
        event.position.dy > (screen.height - screen.height / _diff)) {
      return SnapArea.bottomRight;
    }
    if (event.position.dx < screen.width / _diff &&
        event.position.dy > (screen.height - screen.height / _diff)) {
      return SnapArea.bottomLeft;
    }
    if (event.position.dx > (screen.width - screen.width / _diff) &&
        event.position.dy < screen.height / _diff) {
      return SnapArea.topRight;
    }
    if (event.position.dx < screen.width / _diff &&
        event.position.dy < screen.height / _diff) {
      return SnapArea.topLeft;
    }
    if (event.position.dx < screen.width / _diff) {
      return SnapArea.left;
    }
    if (event.position.dx > (screen.width - screen.width / _diff)) {
      return SnapArea.right;
    }
    if (event.position.dy < (screen.height / _diff) &&
        event.position.dx > (screen.width / _diff) &&
        event.position.dx < (screen.width - (screen.width / _diff))) {
      return SnapArea.full;
    }
    return null;
  }
}

class WindowManager {
  AppChannel channel;
  MouseEvent? _lastPoint;
  _AreaCalculator calc = _AreaCalculator(screen: const Size(2056, 1330));
  Function(SnapArea?) onMove;
  Function(SnapArea?) onDone;

  SnapArea? currentSnapArea;

  WindowManager({
    required this.channel,
    required this.onMove,
    required this.onDone,
  });

  listen() {
    channel.listen((key, payload) {
      var handler = {
        "on_mouse_down": () {
          //
        },
        "on_mouse_dragged": () {
          var data = jsonDecode(payload);
          _lastPoint = MouseEvent.fromMap(data);
          currentSnapArea = calc.fromMouseEvent(_lastPoint!);
          onMove(currentSnapArea);
        },
        "on_mouse_up": () {
          if (currentSnapArea != null) {
            log("snapArea: $currentSnapArea");
            onDone(currentSnapArea);
          }
          currentSnapArea = null;
        }
      }[key];
      if (handler != null) {
        handler();
      }
    });
  }
}
