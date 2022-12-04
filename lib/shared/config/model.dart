import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:toolboard/shared/extensions/color.dart';

final defaultConfig = AppConfig(
  windowPadding: 10.0,
  windowGap: 10.0,
  borderRadius: 10.0,
  borderWidth: 2.0,
);

class AppConfig {
  final double windowPadding;
  final double windowGap;
  final double borderWidth;
  final double borderRadius;
  final Color? accentColor;

  AppConfig({
    required this.windowPadding,
    required this.windowGap,
    required this.borderRadius,
    required this.borderWidth,
    this.accentColor,
  });

  static AppConfig fromMap(Map data) {
    Color? color;
    try {
      color = HexColor.fromHex(data['accent_color']);
    } catch (_) {}

    return AppConfig(
      windowPadding: data['window_padding'],
      windowGap: data['window_gap'],
      borderRadius: data['border_radius'],
      borderWidth: data['border_width'],
      accentColor: color,
    );
  }

  Map toMap() {
    return {
      'window_padding': windowPadding,
      'window_gap': windowGap,
      'border_width': borderWidth,
      'border_radius': borderRadius,
      'accent_color': accentColor,
    };
  }
}
