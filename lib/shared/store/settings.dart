import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:toolboard/shared/config/color.dart';
import 'package:toolboard/shared/config/constants.dart';
import 'package:toolboard/shared/services/caffeinate.dart';
import 'package:toolboard/shared/store/helpers.dart';

import '../../channel/channel.dart';

class SettingsValue {
  double gap = 0;
  double padding = 0;
  Color accentColor;
  bool windowManagerEnable = false;
  bool enableCaffeinate = false;

  SettingsValue(
      {required this.gap,
      required this.padding,
      required this.accentColor,
      this.windowManagerEnable = false,
      this.enableCaffeinate = false});

  static SettingsValue fromMap(Map data) {
    return SettingsValue(
      gap: data['gap'] ?? 0.0,
      padding: data['padding'] ?? 0.0,
      accentColor: Color(data['accent_color']),
      windowManagerEnable: data['window_manager_enable'] ?? false,
      enableCaffeinate: data['enable_caffeinate'] ?? false,
    );
  }

  Map toMap() {
    return {
      'padding': padding,
      'gap': gap,
      'accent_color': accentColor.value,
      'window_manager_enable': windowManagerEnable,
      'enable_caffeinate': enableCaffeinate,
    };
  }
}

class SettingsStore extends Store<SettingsValue> {
  init() {
    SharedPreferences.getInstance().then((instance) {
      try {
        var data = instance.getString('settings');
        next(SettingsValue.fromMap(jsonDecode(data ?? '{}')));

        if (value.windowManagerEnable) {
          AppChannel.instance.startWindowManager();
        }
        if (value.enableCaffeinate && currentAppKey == 'statusbar') {
          Caffeinate.instance.start().then((res) {
            if (!res) {
              value.enableCaffeinate = false;
              next(value);
            }
          });
        }
      } catch (err) {
        //
      }
    });
    AppChannel.instance.listen((key, payload) {
      if (key == 'on_change_accent_color') {
        setAccentColor(HSLColor.fromColor(HexColor.fromHex(payload))
            .withLightness(0.58)
            .toColor());
      }
    });
    AppChannel.instance.getCurrentAccentColor().then((accentColor) {
      setAccentColor(HSLColor.fromColor(HexColor.fromHex(accentColor))
          .withLightness(0.58)
          .toColor());
    });

    AppChannel.instance.onExit(() {
      Caffeinate.instance.stop();
    });

    subscribe((state) {
      final data = jsonEncode(state.toMap());
      SharedPreferences.getInstance().then((instance) {
        instance.setString('settings', data);
      });
    });
  }

  SettingsStore()
      : super(
          value: SettingsValue(
            gap: WINDOW_GAP,
            padding: WINDOW_PADDING,
            accentColor: Colors.black,
          ),
        );

  setAccentColor(Color accentColor) {
    value.accentColor = accentColor;
    next(value);
  }

  changeCaffeinate(bool state) async {
    if (currentAppKey != 'statusbar') {
      return;
    }
    if (!state && Caffeinate.instance.enable) {
      if (Caffeinate.instance.stop()) {
        value.enableCaffeinate = state;
        next(value);
      }
    }

    if (state && !Caffeinate.instance.enable) {
      final result = await Caffeinate.instance.start();
      if (result) {
        value.enableCaffeinate = state;
        next(value);
      }
    }
  }

  changeWindowManagerEnable(bool state) {
    value.windowManagerEnable = state;
    if (state) {
      AppChannel.instance.startWindowManager();
    } else {
      AppChannel.instance.stopWindowManager();
    }
    next(value);
  }
}

final settingsStore = SettingsStore();
