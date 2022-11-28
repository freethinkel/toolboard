import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:toolboard/channel/channel.dart';
import 'package:toolboard/shared/store/settings.dart';

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
  RectData rect;

  ScreenData({required this.topOffset, required this.rect});

  static ScreenData fromMap(Map data) {
    return ScreenData(
        topOffset: data['position']['top_offset'],
        rect: RectData.fromMap(data));
  }
}

class RectData {
  Size size;
  Offset position;

  RectData({required this.position, required this.size});

  static RectData fromMap(Map data) {
    return RectData(
      position: Offset(data['position']['x'], data['position']['y']),
      size: Size(
        data['size']['width'],
        data['size']['height'],
      ),
    );
  }

  Map toMap() {
    return ({
      'position': {
        'x': position.dx,
        'y': position.dy,
      },
      'size': {
        'width': size.width,
        'height': size.height,
      }
    });
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
  ScreenData screen;
  _AreaCalculator({required this.screen});
  final _diff = 10;

  RectData? fromSnapArea(SnapArea area) {
    var rect = {
      SnapArea.full: RectData(
          position: Offset(settingsStore.value.padding,
              screen.topOffset + settingsStore.value.padding),
          size: Size(screen.rect.size.width - settingsStore.value.padding * 2,
              screen.rect.size.height - settingsStore.value.padding * 2)),
      SnapArea.left: RectData(
        position: Offset(settingsStore.value.padding,
            screen.topOffset + settingsStore.value.padding),
        size: Size(
            screen.rect.size.width / 2 -
                settingsStore.value.gap / 2 -
                settingsStore.value.padding,
            screen.rect.size.height - settingsStore.value.padding),
      ),
      SnapArea.right: RectData(
        position: Offset(
            screen.rect.size.width / 2 + settingsStore.value.gap / 2,
            screen.topOffset + settingsStore.value.padding),
        size: Size(
            screen.rect.size.width / 2 -
                settingsStore.value.gap / 2 -
                settingsStore.value.padding,
            screen.rect.size.height - settingsStore.value.padding * 2),
      ),
      SnapArea.topLeft: RectData(
        position: Offset(settingsStore.value.padding,
            screen.topOffset + settingsStore.value.padding),
        size: Size(
            screen.rect.size.width / 2 -
                settingsStore.value.padding -
                settingsStore.value.gap / 2,
            screen.rect.size.height / 2 -
                settingsStore.value.padding -
                settingsStore.value.gap / 2),
      ),
      SnapArea.topRight: RectData(
        position: Offset(
            screen.rect.size.width / 2 + settingsStore.value.gap / 2,
            screen.topOffset + settingsStore.value.padding),
        size: Size(
            screen.rect.size.width / 2 -
                settingsStore.value.padding -
                settingsStore.value.gap / 2,
            screen.rect.size.height / 2 -
                settingsStore.value.padding -
                settingsStore.value.gap / 2),
      ),
      SnapArea.bottomLeft: RectData(
        position: Offset(
            settingsStore.value.padding,
            screen.rect.size.height / 2 +
                screen.topOffset +
                settingsStore.value.gap / 2),
        size: Size(
            screen.rect.size.width / 2 -
                settingsStore.value.padding -
                settingsStore.value.gap / 2,
            screen.rect.size.height / 2 -
                settingsStore.value.padding -
                settingsStore.value.gap / 2),
      ),
      SnapArea.bottomRight: RectData(
        position: Offset(
            screen.rect.size.width / 2 + settingsStore.value.gap / 2,
            (screen.rect.size.height / 2 + screen.topOffset) +
                settingsStore.value.gap / 2),
        size: Size(
            screen.rect.size.width / 2 -
                settingsStore.value.padding -
                settingsStore.value.gap / 2,
            screen.rect.size.height / 2 -
                settingsStore.value.padding -
                settingsStore.value.gap / 2),
      ),
    }[area];

    return rect;
  }

  SnapArea? fromMouseEvent(MouseEvent event) {
    if (event.window == null) {
      return null;
    }
    if (event.position.dx >
            (screen.rect.size.width - screen.rect.size.width / _diff) &&
        event.position.dy >
            (screen.rect.size.height - screen.rect.size.height / _diff)) {
      return SnapArea.bottomRight;
    }
    if (event.position.dx < screen.rect.size.width / _diff &&
        event.position.dy >
            (screen.rect.size.height - screen.rect.size.height / _diff)) {
      return SnapArea.bottomLeft;
    }
    if (event.position.dx >
            (screen.rect.size.width - screen.rect.size.width / _diff) &&
        event.position.dy < screen.rect.size.height / _diff) {
      return SnapArea.topRight;
    }
    if (event.position.dx < screen.rect.size.width / _diff &&
        event.position.dy < screen.rect.size.height / _diff) {
      return SnapArea.topLeft;
    }
    if (event.position.dx < screen.rect.size.width / _diff) {
      return SnapArea.left;
    }
    if (event.position.dx >
        (screen.rect.size.width - screen.rect.size.width / _diff)) {
      return SnapArea.right;
    }
    if (event.position.dy < (screen.rect.size.height / _diff) &&
        event.position.dx > (screen.rect.size.width / _diff) &&
        event.position.dx <
            (screen.rect.size.width - (screen.rect.size.width / _diff))) {
      return SnapArea.full;
    }
    return null;
  }
}

class WindowManager {
  AppChannel channel;
  MouseEvent? _lastPoint;
  final calc = _AreaCalculator(
    screen: ScreenData(
      topOffset: 0,
      rect: RectData(
        size: const Size(0, 0),
        position: const Offset(0, 0),
      ),
    ),
  );
  Function(SnapArea?) onMove;
  Function(SnapArea?) onDone;

  SnapArea? currentSnapArea;

  WindowManager({
    required this.channel,
    required this.onMove,
    required this.onDone,
  });

  setCurrentWindowFrame(ScreenData screen) {
    channel.setCurrentWindowFrame(screen.rect);
  }

  setWindowFrame(WindowInfo window, Offset position) {
    channel.setWindowFrame(
        window.id, RectData(position: position, size: window.frame));
  }

  updateScreen() {
    channel.getScreen().then((screenData) {
      var screen = ScreenData.fromMap(screenData);
      calc.screen = screen;
      setCurrentWindowFrame(screen);
    });
  }

  listen() {
    updateScreen();
    channel.listen((key, payload) {
      var handler = {
        "on_mouse_down": () {},
        "on_mouse_dragged": () {
          var data = jsonDecode(payload);
          _lastPoint = MouseEvent.fromMap(data);
          currentSnapArea = calc.fromMouseEvent(_lastPoint!);
          onMove(currentSnapArea);
        },
        "on_mouse_up": () {
          if (currentSnapArea != null) {
            var rect = calc.fromSnapArea(currentSnapArea!);
            if (rect != null && _lastPoint!.window!.id != null) {
              setWindowFrame(
                WindowInfo(id: _lastPoint!.window!.id, frame: rect.size),
                rect.position,
              );
            }
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
