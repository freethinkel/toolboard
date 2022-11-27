import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:statsfl/statsfl.dart';
import 'package:toolboard/channel/channel.dart';
import 'package:toolboard/overlay/grid/rect.dart';
import 'package:toolboard/overlay/window_manager.dart';
import 'package:toolboard/shared/config/constants.dart';

Map rectPosition = {
  SnapArea.full: const AnimatedPositioned(
    duration: Duration(milliseconds: 100),
    top: WINDOW_PADDING,
    left: WINDOW_PADDING,
    right: WINDOW_PADDING,
    bottom: WINDOW_PADDING,
    child: Rect(),
  ),
  SnapArea.left: AnimatedPositioned(
    duration: const Duration(milliseconds: 100),
    top: WINDOW_PADDING,
    left: WINDOW_PADDING,
    bottom: WINDOW_PADDING,
    right: WINDOW_GAP / 2,
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
    top: WINDOW_PADDING,
    left: WINDOW_PADDING,
    bottom: WINDOW_PADDING,
    right: WINDOW_PADDING,
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
    top: WINDOW_PADDING,
    left: WINDOW_PADDING,
    bottom: WINDOW_PADDING,
    right: WINDOW_PADDING,
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

  RectData? prevRect;

  @override
  Widget build(BuildContext context) {
    var rect = currentArea != null
        ? windowManager!.calc.fromSnapArea(currentArea!)
        : null;

    var offset = windowManager?.calc.screen.topOffset ?? 0;

    if (rect != null) {
      prevRect = rect;
    }

    var rrect = rect ?? prevRect;

    return Stack(
      children: [
        // Positioned(
        //     top: 0,
        //     left: 0,
        //     child: StatsFl(
        //       isEnabled: true, //Toggle on/off
        //       width: 600, //Set size
        //       height: 20, //
        //       maxFps: 120, // Support custom FPS target (default is 60)
        //       showText: true, // Hide text label
        //       sampleTime: .5, //Interval between fps calculations, in seconds.
        //       totalTime: 15, //Total length of timeline, in seconds.
        //       align: Alignment.topLeft,
        //     )),
        AnimatedPositioned(
          duration: ANIMATION_DURATION,
          top: (rrect?.position.dy ?? 0) - offset,
          left: rrect?.position.dx,
          child: AnimatedOpacity(
            duration: const Duration(
              milliseconds: 100,
            ),
            opacity: rect != null ? 1 : 0,
            child: Rect(
              width: rrect?.size.width,
              height: rrect?.size.height,
            ),
          ),
        ),
      ],
    );
  }
}
