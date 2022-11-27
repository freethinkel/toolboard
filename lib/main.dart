import 'package:flutter/material.dart';
import 'package:toolboard/channel/channel.dart';
import 'package:toolboard/shared/store/settings.dart';
import 'package:toolboard/statusbar/statusbar_app.dart';

import 'overlay/overlay_app.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  var key =
      (await AppChannel.instance.getKey().catchError((err) => '__none__'));
  var handler = ({
    'overlay': () => runApp(const OverlayApp()),
    'statusbar': () => runApp(const StatusbarApp())
  })[key];

  if (handler != null) {
    handler();
  }

  AppChannel.instance.getCurrentAccentColor().then((accentColor) {
    settingsStore.setAccentColor(HexColor.fromHex(accentColor));
  });
}

extension HexColor on Color {
  /// String is in the format "aabbcc" or "ffaabbcc" with an optional leading "#".
  static Color fromHex(String hexString) {
    final buffer = StringBuffer();
    if (hexString.length == 6 || hexString.length == 7) buffer.write('ff');
    buffer.write(hexString.replaceFirst('#', ''));
    return Color(int.parse(buffer.toString(), radix: 16));
  }

  /// Prefixes a hash sign if [leadingHashSign] is set to `true` (default is `true`).
  String toHex({bool leadingHashSign = true}) => '${leadingHashSign ? '#' : ''}'
      '${alpha.toRadixString(16).padLeft(2, '0')}'
      '${red.toRadixString(16).padLeft(2, '0')}'
      '${green.toRadixString(16).padLeft(2, '0')}'
      '${blue.toRadixString(16).padLeft(2, '0')}';
}
