import 'package:flutter/material.dart';

class AppButton {
  static textButton(String text, Function callback) {
    return SizedBox(
        height: 60,
        child: RawMaterialButton(
          onPressed: callback,
          child:
              Text(text, style: TextStyle(fontSize: 20, color: Colors.white)),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(30.0),
          ),
          elevation: 3.0,
          fillColor: Colors.black,
          padding: const EdgeInsets.all(15.0),
        ));
  }
}
