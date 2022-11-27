import 'package:flutter/material.dart';
import 'package:toolboard/overlay/grid/grid_manager.dart';

class OverlayApp extends StatelessWidget {
  const OverlayApp({super.key});

  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      debugShowCheckedModeBanner: false,
      home: Scaffold(
        backgroundColor: Colors.transparent,
        body: GridManager(),
      ),
    );
  }
}
