import 'package:flutter/material.dart';

class TBButton extends StatefulWidget {
  final Widget child;
  final Function()? onClick;
  const TBButton({this.onClick, required this.child, super.key});

  @override
  State<TBButton> createState() => _TBButtonState();
}

class _TBButtonState extends State<TBButton> {
  bool isPressed = false;

  @override
  Widget build(BuildContext context) {
    return MouseRegion(
      cursor: SystemMouseCursors.click,
      child: GestureDetector(
        onTapDown: (_) {
          setState(() {
            isPressed = true;
          });
        },
        onTapUp: (_) {
          setState(() {
            isPressed = false;
          });
        },
        onTapCancel: () {
          setState(() {
            isPressed = false;
          });
        },
        onTap: () {
          setState(() {
            isPressed = false;
          });
          widget.onClick?.call();
        },
        child: DefaultTextStyle.merge(
          style: const TextStyle(
            fontSize: 13,
          ),
          child: AnimatedOpacity(
            opacity: isPressed ? 0.8 : 1,
            duration: const Duration(milliseconds: 50),
            child: widget.child,
          ),
        ),
      ),
    );
  }
}
