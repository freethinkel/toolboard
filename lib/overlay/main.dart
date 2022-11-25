import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:toolboard/channel/channel.dart';
import 'package:toolboard/channel/model.dart';

class OverlayApp extends StatelessWidget {
  const OverlayApp({super.key});

  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      home: DebugScreen(),
    );
  }
}

class DebugScreen extends StatefulWidget {
  const DebugScreen({super.key});

  @override
  State<DebugScreen> createState() => _DebugScreenState();
}

class _DebugScreenState extends State<DebugScreen> {
  WindowFrameChangedEvent? windowInfo;
  Size? currentScreen;
  Offset? offset;

  @override
  void initState() {
    AppChannel.instance.getScreens().then((screens) {
      // setState(() {
      //   currentScreen = Size(screens.first['width'], screens.first['height']);
      // });
      print(screens);
    });
    AppChannel.instance.listen((key, payload) {
      print("list");
      var handler = {
        "on_mouse_down": () {
          print("down: $payload");
        },
        "on_mouse_dragged": () {
          var data = jsonDecode(payload);
          setState(() {
            offset = Offset(data['x'], data['y']);
          });
        },
        "on_mouse_up": () {
          // print("up: $payload");
          setState(() {
            offset = Offset(0, 0);
          });
        }
      }[key];
      if (handler != null) {
        handler();
      }
      // if (handler != null) {
      //   var data = handler();
      //   // if (data is WindowFrameChangedEvent) {
      //   //   setState(() {
      //   //     windowInfo = data;
      //   //   });
      //   // }
      // }
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.transparent,
      body: Stack(
        children: [
          Positioned(
            left: offset?.dx ?? 0.0,
            top: offset?.dy ?? 0.0,
            child: Container(
              height: 30,
              width: 30,
              decoration: BoxDecoration(color: Colors.red),
            ),
          ),
        ],
      ),
    );
  }
}
