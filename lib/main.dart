import 'package:flutter/material.dart';
import 'package:toolboard/channel/channel.dart';
import 'package:toolboard/statusbar/main.dart';

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
}
