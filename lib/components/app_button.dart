import 'package:flutter/material.dart';

class AppButton {
  static final Color _textColor = Colors.white;
  static final Color _backgroundColor = Colors.black;

  static textButton(String text, Function callback) {
    return SizedBox(
        height: 60,
        child: RawMaterialButton(
          onPressed: callback,
          child: Text(text, style: TextStyle(fontSize: 20, color: _textColor)),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(30.0),
          ),
          elevation: 3.0,
          fillColor: _backgroundColor,
          padding: const EdgeInsets.all(15.0),
        ));
  }

  static textIconButton(String text, IconData iconData, Function callback) {
    return RaisedButton.icon(
      label: Text(text, style: TextStyle(fontSize: 20, color: _textColor)),
      icon: Icon(iconData, color: _textColor),
      onPressed: callback,
      shape: StadiumBorder(),
      color: _backgroundColor,
      padding: const EdgeInsets.fromLTRB(15, 15, 26, 15),
    );
  }
}
