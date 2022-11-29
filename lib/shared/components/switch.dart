import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class TBSwitch extends StatelessWidget {
  final bool value;
  final Widget? child;
  final Function(bool)? onChange;

  const TBSwitch({this.child, this.onChange, this.value = false, super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.only(top: 4, bottom: 4, left: 10, right: 5),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          if (child != null) child!,
          SizedBox(
            width: 40,
            height: 23,
            child: Transform.scale(
              scale: 0.7,
              child: CupertinoSwitch(
                value: value,
                onChanged: onChange,
                activeColor: Theme.of(context).primaryColor,
              ),
            ),
          )
        ],
      ),
    );
  }
}
