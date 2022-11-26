import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:toolboard/channel/channel.dart';
import 'package:toolboard/channel/model.dart';
import 'package:toolboard/overlay/grid/grid_manager.dart';
import 'package:toolboard/overlay/grid/rect.dart';
import 'package:toolboard/overlay/window_manager.dart';

class OverlayApp extends StatelessWidget {
  const OverlayApp({super.key});

  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      debugShowCheckedModeBanner: false,
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
  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      backgroundColor: Colors.transparent,
      body: GridManager(),
    );
  }
}
