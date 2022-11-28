import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:toolboard/channel/channel.dart';
import 'package:toolboard/overlay/grid/rect.dart';
import 'package:toolboard/overlay/window_manager.dart';
import 'package:toolboard/shared/config/constants.dart';

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
    var top = (rrect?.position.dy ?? 0) - offset;
    var left = rrect?.position.dx ?? 0;

    return Stack(
      children: [
        AnimatedPositioned(
          duration: ANIMATION_DURATION,
          top: top < 0 ? 0 : top,
          left: left,
          child: AnimatedOpacity(
            duration: const Duration(
              milliseconds: 100,
            ),
            opacity: rect != null ? 1 : 0,
            child: Rect(
              width: (rrect?.size.width ?? 0) < 0 ? 0 : rrect?.size.width,
              height: (rrect?.size.height ?? 0) < 0 ? 0 : rrect?.size.height,
            ),
          ),
        ),
      ],
    );
  }
}
