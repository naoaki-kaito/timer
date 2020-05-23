import 'package:flutter/material.dart';

class AppButton {
  static final Color textColor = Colors.black;
  static final Color backgroundColor = Colors.white;

  static textButton(String text, Function callback) {
    return SizedBox(
        height: 60,
        child: RawMaterialButton(
          onPressed: callback,
          child: Text(text, style: TextStyle(fontSize: 20, color: textColor)),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(30.0),
          ),
          elevation: 3.0,
          fillColor: backgroundColor,
          padding: const EdgeInsets.all(15.0),
        ));
  }

  static textIconButton(String text, IconData iconData, Function callback) {
    return RaisedButton.icon(
      label: Text(text, style: TextStyle(fontSize: 20, color: textColor)),
      icon: Icon(iconData, color: textColor),
      onPressed: callback,
      shape: StadiumBorder(),
      color: backgroundColor,
      padding: const EdgeInsets.fromLTRB(15, 15, 26, 15),
    );
  }
}
