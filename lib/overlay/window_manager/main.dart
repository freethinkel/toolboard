import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:toolboard/shared/channel/app_channel.dart';
import 'package:toolboard/overlay/window_manager/models.dart';
import 'package:toolboard/shared/config/model.dart';
import 'package:toolboard/shared/model/rect.dart';

class AreaCalculator {
  ScreenData screen;
  AppConfig config;

  AreaCalculator({required this.screen, required this.config});

  final sensitive = 0.1;

  RectEntry? fromSnapArea(SnapArea area) {
    var rect = {
      SnapArea.full: RectEntry(
          offset: Offset(
              config.windowPadding, screen.topOffset + config.windowPadding),
          size: Size(screen.rect.size.width - config.windowPadding * 2,
              screen.rect.size.height - config.windowPadding * 2)),
      SnapArea.left: RectEntry(
        offset: Offset(
            config.windowPadding, screen.topOffset + config.windowPadding),
        size: Size(
            screen.rect.size.width / 2 -
                config.windowGap / 2 -
                config.windowPadding,
            screen.rect.size.height - config.windowPadding * 2),
      ),
      SnapArea.right: RectEntry(
        offset: Offset(screen.rect.size.width / 2 + config.windowGap / 2,
            screen.topOffset + config.windowPadding),
        size: Size(
            screen.rect.size.width / 2 -
                config.windowGap / 2 -
                config.windowPadding,
            screen.rect.size.height - config.windowPadding * 2),
      ),
      SnapArea.topLeft: RectEntry(
        offset: Offset(
            config.windowPadding, screen.topOffset + config.windowPadding),
        size: Size(
            screen.rect.size.width / 2 -
                config.windowPadding -
                config.windowGap / 2,
            screen.rect.size.height / 2 -
                config.windowPadding -
                config.windowGap / 2),
      ),
      SnapArea.topRight: RectEntry(
        offset: Offset(screen.rect.size.width / 2 + config.windowGap / 2,
            screen.topOffset + config.windowPadding),
        size: Size(
            screen.rect.size.width / 2 -
                config.windowPadding -
                config.windowGap / 2,
            screen.rect.size.height / 2 -
                config.windowPadding -
                config.windowGap / 2),
      ),
      SnapArea.bottomLeft: RectEntry(
        offset: Offset(
            config.windowPadding,
            screen.rect.size.height / 2 +
                screen.topOffset +
                config.windowGap / 2),
        size: Size(
            screen.rect.size.width / 2 -
                config.windowPadding -
                config.windowGap / 2,
            screen.rect.size.height / 2 -
                config.windowPadding -
                config.windowGap / 2),
      ),
      SnapArea.bottomRight: RectEntry(
        offset: Offset(
            screen.rect.size.width / 2 + config.windowGap / 2,
            (screen.rect.size.height / 2 + screen.topOffset) +
                config.windowGap / 2),
        size: Size(
            screen.rect.size.width / 2 -
                config.windowPadding -
                config.windowGap / 2,
            screen.rect.size.height / 2 -
                config.windowPadding -
                config.windowGap / 2),
      ),
    }[area];

    return rect;
  }

  SnapArea? fromMouseEvent(MouseEvent event) {
    if (event.window == null) {
      return null;
    }
    if (event.position.dx >
            (screen.rect.size.width - screen.rect.size.width * sensitive) &&
        event.position.dy >
            (screen.rect.size.height - screen.rect.size.height * sensitive)) {
      return SnapArea.bottomRight;
    }
    if (event.position.dx < screen.rect.size.width * sensitive &&
        event.position.dy >
            (screen.rect.size.height - screen.rect.size.height * sensitive)) {
      return SnapArea.bottomLeft;
    }
    if (event.position.dx >
            (screen.rect.size.width - screen.rect.size.width * sensitive) &&
        event.position.dy < screen.rect.size.height * sensitive) {
      return SnapArea.topRight;
    }
    if (event.position.dx < screen.rect.size.width * sensitive &&
        event.position.dy < screen.rect.size.height * sensitive) {
      return SnapArea.topLeft;
    }
    if (event.position.dx < screen.rect.size.width * sensitive) {
      return SnapArea.left;
    }
    if (event.position.dx >
        (screen.rect.size.width - screen.rect.size.width * sensitive)) {
      return SnapArea.right;
    }
    if (event.position.dy < (screen.rect.size.height * sensitive) &&
        event.position.dx > (screen.rect.size.width * sensitive) &&
        event.position.dx <
            (screen.rect.size.width - (screen.rect.size.width * sensitive))) {
      return SnapArea.full;
    }
    return null;
  }
}

class WindowManager {
  final AppChannel channel;

  AreaCalculator calc;
  final Function(SnapArea?) onMove;
  final Function(SnapArea?) onDone;

  MouseEvent? _lastPoint;
  SnapArea? currentSnapArea;

  WindowManager({
    required this.calc,
    required this.channel,
    required this.onMove,
    required this.onDone,
  });

  void setCurrentWindowFrame(ScreenData screen) {
    channel.setCurrentWindowFrame(screen.rect);
  }

  void setWindowFrame(WindowInfo window, Offset offset) {
    channel.setWindowFrame(
        window.id, RectEntry(offset: offset, size: window.frame));
  }

  void updateScreen() {
    channel.getScreen().then((screenData) {
      var screen = ScreenData.fromMap(screenData);
      calc.screen = screen;
      setCurrentWindowFrame(screen);
    });
  }

  void listen() {
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
            if (rect != null && _lastPoint?.window?.id != null) {
              setWindowFrame(
                WindowInfo(id: _lastPoint!.window!.id, frame: rect.size),
                rect.offset,
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
