import 'dart:convert';

import 'package:flutter/services.dart';
import 'package:toolboard/overlay/window_manager.dart';

class AppChannel {
  final _channelName = 'ru.freethinkel.toolboard/window';
  late final channel = MethodChannel(_channelName);
  List<Function(String, dynamic)> _listeners = [];

  static final instance = AppChannel();

  AppChannel();

  Future<Map> getScreen() {
    return channel.invokeMethod('get_current_screen').then((value) {
      return jsonDecode(value);
    });
  }

  Future setCurrentWindowFrame(RectData rect) {
    return channel.invokeMethod(
      "set_current_window_frame",
      jsonEncode(
        rect.toMap(),
      ),
    );
  }

  Future startWindowManager() {
    return channel.invokeMethod('start_window_manager');
  }

  Future stopWindowManager() {
    return channel.invokeMethod('stop_window_manager');
  }

  Future<String> getCurrentAccentColor() {
    return channel.invokeMethod('get_accent_color').then((value) {
      return value as String;
    });
  }

  Future setWindowFrame(int windowId, RectData rect) {
    return channel.invokeMethod(
        "set_window_frame",
        jsonEncode({
          'id': windowId,
          ...rect.toMap(),
        }));
  }

  listen(Function(String, dynamic) cb) {
    _listeners.add(cb);
    channel.setMethodCallHandler((call) async {
      for (var cb in _listeners) {
        cb(call.method, call.arguments);
      }
    });

    return () {
      _listeners = _listeners.where((el) => el != cb).toList();
    };
  }

  Future<String> getKey() async {
    return await channel
        .invokeMethod(('get_key'))
        .then((value) => value.toString());
  }
}
