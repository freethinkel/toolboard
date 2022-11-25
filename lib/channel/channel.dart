import 'dart:convert';

import 'package:flutter/services.dart';

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
