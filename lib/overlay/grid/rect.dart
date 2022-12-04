import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:toolboard/shared/config/constants.dart';
import 'package:toolboard/shared/controllers/settings.controller.dart';

class RectBox extends StatefulWidget {
  final double? width;
  final double? height;
  const RectBox({this.height, this.width, super.key});

  @override
  State<RectBox> createState() => _RectBoxState();
}

class _RectBoxState extends State<RectBox> {
  final controller = Get.put(SettingsController());

  @override
  Widget build(BuildContext context) {
    return AnimatedContainer(
      duration: ANIMATION_DURATION,
      height: widget.height,
      width: widget.width,
      decoration: BoxDecoration(
        border: Border.all(
          width: controller.config.value.borderWidth,
          color: Theme.of(context).primaryColor,
        ),
        color: Theme.of(context).primaryColor.withOpacity(0.2),
        borderRadius:
            BorderRadius.circular(controller.config.value.borderRadius),
      ),
    );
  }
}
