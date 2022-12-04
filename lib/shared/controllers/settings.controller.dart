import 'package:flutter/painting.dart';
import 'package:get/get.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:toolboard/shared/channel/app_channel.dart';
import 'package:toolboard/shared/config/constants.dart';
import 'package:toolboard/shared/config/model.dart';
import 'package:toolboard/shared/config/reader.dart';
import 'package:toolboard/shared/extensions/color.dart';
import 'package:toolboard/shared/services/caffeinate.dart';

class SettingsController extends GetxController {
  final accentColor = Rx<Color?>(null);
  final windowManagerEnabled = false.obs;
  final caffeinateEnabled = false.obs;
  final config = Rx(defaultConfig);

  final List<Function()> _subscriptions = [];

  @override
  void onInit() {
    SharedPreferences.getInstance().then((instance) {
      windowManagerEnabled.value = instance.getBool('window_manager_enabled') ??
          windowManagerEnabled.value;
      caffeinateEnabled.value =
          instance.getBool('caffeinate_enabled') ?? caffeinateEnabled.value;
    });

    ConfigReader()
        .readConfig()
        .then(
          (configRaw) => AppConfig.fromMap(
            {...config.value.toMap(), ...(configRaw ?? {})},
          ),
        )
        .then((newConfig) {
      config.value = newConfig;
    });

    AppChannel.instance.getCurrentAccentColor().then((color) {
      _setColor(color);
    });
    _subscriptions.add(AppChannel.instance.listen((key, payload) {
      if (key == 'on_change_accent_color') {
        _setColor(payload);
      }
    }));
    if (currentAppKey == 'statusbar') {
      _statusBarListeners();
    }
    super.onInit();
  }

  _statusBarListeners() async {
    final sharedPreferences = await SharedPreferences.getInstance();

    _subscriptions.add(
      caffeinateEnabled.listen((value) {
        sharedPreferences.setBool('caffeinate_enabled', value);
        var handler =
            value ? Caffeinate.instance.start : Caffeinate.instance.stop;
        handler();
      }).cancel,
    );
    _subscriptions.add(
      windowManagerEnabled.listen((value) {
        sharedPreferences.setBool('window_manager_enabled', value);
        var handler = value
            ? AppChannel.instance.startWindowManager
            : AppChannel.instance.stopWindowManager;
        handler();
      }).cancel,
    );
  }

  @override
  void onClose() {
    for (final unsubscribe in _subscriptions) {
      unsubscribe();
    }
    super.onClose();
  }

  _setColor(String color) {
    accentColor.value = HSLColor.fromColor(HexColor.fromHex(color))
        .withLightness(0.58)
        .toColor();
  }
}
