import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:toolboard/shared/channel/app_channel.dart';
import 'package:toolboard/shared/config/constants.dart';
import 'package:toolboard/statusbar/statusbar_app.dart';

import 'overlay/overlay_app.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  currentAppKey =
      (await AppChannel.instance.getKey().catchError((err) => '__none__'));
  var handler = ({
    'overlay': () => runApp(const OverlayApp()),
    'statusbar': () => runApp(const StatusbarApp())
  })[currentAppKey];

  if (handler != null) {
    handler();
  }
}
