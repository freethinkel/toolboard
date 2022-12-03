import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:toolboard/overlay/grid/controller.dart';
import 'package:toolboard/overlay/grid/rect.dart';
import 'package:toolboard/shared/config/constants.dart';

class GridManager extends StatefulWidget {
  const GridManager({super.key});

  @override
  State<GridManager> createState() => _GridManagerState();
}

class _GridManagerState extends State<GridManager> {
  final gridController = Get.put(GridController());

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        Obx(
          () => AnimatedPositioned(
            duration: ANIMATION_DURATION,
            top: gridController.currentRect.value?.offset.dy,
            left: gridController.currentRect.value?.offset.dx,
            child: AnimatedOpacity(
              duration: ANIMATION_DURATION,
              opacity: gridController.currentArea.value == null ? 0 : 1,
              child: RectBox(
                width: gridController.currentRect.value?.size.width,
                height: gridController.currentRect.value?.size.height,
              ),
            ),
          ),
        ),
      ],
    );
  }
}
