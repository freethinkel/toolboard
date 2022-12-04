import 'package:flutter/material.dart';
import 'package:toolboard/shared/channel/app_channel.dart';
import 'package:toolboard/statusbar/components/button.dart';

class QuitInfo extends StatefulWidget {
  const QuitInfo({super.key});

  @override
  State<QuitInfo> createState() => _QuitInfoState();
}

class _QuitInfoState extends State<QuitInfo> {
  Widget buildText(String text) {
    return Text(
      text,
      style: TextStyle(
        fontSize: 13,
        color: DefaultTextStyle.of(context).style.color?.withOpacity(0.7),
      ),
    );
  }

  void onExit() {
    AppChannel.instance.exitApp();
  }

  @override
  Widget build(BuildContext context) {
    var color = Theme.of(context).hoverColor;

    return Container(
      padding: const EdgeInsets.only(left: 10, right: 10, top: 4, bottom: 7),
      decoration: BoxDecoration(
          color: color.withOpacity(0.05),
          border: Border(top: BorderSide(color: color.withOpacity(0.12)))),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          buildText('Quit Toolboard'),
          TBButton(onClick: onExit, child: buildText('⌘ Q'))
        ],
      ),
    );
  }
}
