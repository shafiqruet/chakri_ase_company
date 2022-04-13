import 'package:flutter/material.dart';

Widget createDrawerBodyItem({IconData? icon, String? text, GestureTapCallback? onTap, double paddingValue = 20}) {
  return ListTile(
    contentPadding: EdgeInsets.fromLTRB(paddingValue, 0, 0, 0),
    title: Row(
      children: <Widget>[
        Icon(icon),
        Padding(
          padding: EdgeInsets.only(left: 8),
          child: Text(text!),
        )
      ],
    ),
    onTap: onTap,
  );
}
