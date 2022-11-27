import 'dart:async';

import 'package:flutter/material.dart';
import 'package:toolboard/shared/config/constants.dart';
import 'package:toolboard/shared/store/helpers.dart';

class SettingsValue {
  double gap = 0;
  double padding = 0;
  Color accentColor;

  SettingsValue(
      {required this.gap, required this.padding, required this.accentColor});

  static SettingsValue fromMap(Map data) {
    return SettingsValue(
        gap: data['gap'] ?? 0.0,
        padding: data['padding'] ?? 0.0,
        accentColor: data['accent_color']);
  }

  Map toMap() {
    return {'padding': padding, 'gap': gap, 'accent_color': accentColor};
  }
}

class SettingsStore extends Store<SettingsValue> {
  SettingsStore()
      : super(
            value: SettingsValue(
                gap: WINDOW_GAP,
                padding: WINDOW_PADDING,
                accentColor: Colors.black));

  setAccentColor(Color accentColor) {
    value.accentColor = accentColor;
    next(value);
  }
}

final settingsStore = SettingsStore();
