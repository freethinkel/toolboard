import 'package:flutter/material.dart';
import 'package:toolboard/shared/config/constants.dart';
import 'package:toolboard/shared/store/helpers.dart';
import 'package:toolboard/shared/store/settings.dart';

class RectBox extends StatefulWidget {
  final double? width;
  final double? height;
  const RectBox({this.height, this.width, super.key});

  @override
  State<RectBox> createState() => _RectBoxState();
}

class _RectBoxState extends State<RectBox> {
  @override
  Widget build(BuildContext context) {
    return StoreBuilder<SettingsValue, SettingsStore>(
      store: settingsStore,
      builder: (context, store) {
        return AnimatedContainer(
          duration: ANIMATION_DURATION,
          height: widget.height,
          width: widget.width,
          decoration: BoxDecoration(
            border: Border.all(
              width: WINDOW_PLACEHOLDER_BORDER_WIDTH,
              color: store.accentColor,
            ),
            color: store.accentColor.withOpacity(0.2),
            borderRadius:
                BorderRadius.circular(WINDOW_PLACEHOLDER_BORDER_RADIUS),
          ),
        );
      },
    );
  }
}
