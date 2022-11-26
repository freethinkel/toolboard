import 'package:flutter/material.dart';

class Rect extends StatefulWidget {
  final double? width;
  final double? height;
  const Rect({this.height, this.width, super.key});

  @override
  State<Rect> createState() => _RectState();
}

var color = Colors.green;

class _RectState extends State<Rect> {
  @override
  Widget build(BuildContext context) {
    return AnimatedContainer(
      duration: const Duration(milliseconds: 200),
      height: widget.height,
      width: widget.width,
      decoration: BoxDecoration(
          border: Border.all(width: 2, color: color),
          color: color.withOpacity(0.2),
          borderRadius: BorderRadius.circular(10)),
    );
  }
}
