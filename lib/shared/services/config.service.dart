import 'dart:io';

import 'package:flutter/material.dart';

class AppConfig {
  Color? color;
  double? windowGap;
  double? windowPadding;
}

class ConfigService {
  static ConfigService instance = ConfigService();

  getConfig() {
    _readConfig();
  }

  _readConfig() {
    final homeDir = Platform.environment["HOME"];
    print(homeDir);
    File('');
  }
}
