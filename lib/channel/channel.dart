import 'dart:convert';

import 'package:flutter/services.dart';
import 'package:toolboard/overlay/window_manager.dart';

class AppChannel {
  final _channelName = 'ru.freethinkel.toolboard/mindow';
  late final channel = MethodChannel(_channelName);

  static final instance = AppChannel();

  AppChannel();

  Future<List<Map>> getScreens() {
    return channel.invokeMethod('get_screens').then((value) {
      return (value as List<dynamic>)
          .map<Map>((item) => jsonDecode(item))
          .toList();
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

  Future setWindowFrame(int windowId, RectData rect) {
    return channel.invokeMethod(
        "set_window_frame",
        jsonEncode({
          'id': windowId,
          ...rect.toMap(),
        }));
  }

  listen(Function(String, dynamic) cb) {
    channel.setMethodCallHandler((call) async {
      cb(call.method, call.arguments);
    });
  }

  Future<String> getKey() async {
    return await channel
        .invokeMethod(('get_key'))
        .then((value) => value.toString());
  }
}
