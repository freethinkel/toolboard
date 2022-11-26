import 'package:flutter/material.dart';
import 'package:toolboard/channel/channel.dart';
import 'package:toolboard/overlay/grid/rect.dart';
import 'package:toolboard/overlay/window_manager.dart';

Map rectPosition = {
  SnapArea.full: const AnimatedPositioned(
    duration: Duration(milliseconds: 100),
    top: 0,
    left: 0,
    right: 0,
    bottom: 0,
    child: Rect(),
  ),
  SnapArea.left: AnimatedPositioned(
    duration: const Duration(milliseconds: 100),
    top: 0,
    left: 0,
    bottom: 0,
    right: 0,
    child: Container(
      alignment: Alignment.topLeft,
      child: const FractionallySizedBox(
        widthFactor: 0.5,
        child: Rect(),
      ),
    ),
  ),
  SnapArea.right: AnimatedPositioned(
    duration: const Duration(milliseconds: 100),
    top: 0,
    left: 0,
    bottom: 0,
    right: 0,
    child: Container(
      alignment: Alignment.topRight,
      child: const FractionallySizedBox(
        widthFactor: 0.5,
        child: Rect(),
      ),
    ),
  ),
  SnapArea.topLeft: AnimatedPositioned(
    duration: const Duration(milliseconds: 100),
    top: 0,
    left: 0,
    bottom: 0,
    right: 0,
    child: Container(
      alignment: Alignment.topLeft,
      child: const FractionallySizedBox(
        widthFactor: 0.5,
        heightFactor: 0.5,
        child: Rect(),
      ),
    ),
  ),
  SnapArea.topRight: AnimatedPositioned(
    duration: const Duration(milliseconds: 100),
    top: 0,
    left: 0,
    bottom: 0,
    right: 0,
    child: Container(
      alignment: Alignment.topRight,
      child: const FractionallySizedBox(
        widthFactor: 0.5,
        heightFactor: 0.5,
        child: Rect(),
      ),
    ),
  ),
  SnapArea.bottomLeft: AnimatedPositioned(
    duration: const Duration(milliseconds: 100),
    top: 0,
    left: 0,
    bottom: 0,
    right: 0,
    child: Container(
      alignment: Alignment.bottomLeft,
      child: const FractionallySizedBox(
        widthFactor: 0.5,
        heightFactor: 0.5,
        child: Rect(),
      ),
    ),
  ),
  SnapArea.bottomRight: AnimatedPositioned(
    duration: const Duration(milliseconds: 100),
    top: 0,
    left: 0,
    bottom: 0,
    right: 0,
    child: Container(
      alignment: Alignment.bottomRight,
      child: FractionallySizedBox(
        widthFactor: 0.5,
        heightFactor: 0.5,
        child: Rect(),
      ),
    ),
  ),
};

class GridManager extends StatefulWidget {
  const GridManager({super.key});

  @override
  State<GridManager> createState() => _GridManagerState();
}

class _GridManagerState extends State<GridManager> {
  WindowManager? windowManager;
  SnapArea? currentArea;

  @override
  void initState() {
    windowManager = WindowManager(
        channel: AppChannel.instance, onMove: onMoveWindow, onDone: onMoveDone);
    windowManager?.listen();
    super.initState();
  }

  onMoveWindow(SnapArea? area) {
    if (currentArea != area) {
      setState(() {
        currentArea = area;
      });
    }
  }

  onMoveDone(SnapArea? area) {
    setState(() {
      currentArea = null;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        if (currentArea != null) rectPosition[currentArea],
      ],
    );
  }
}
