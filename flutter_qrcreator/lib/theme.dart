import 'package:flutter/material.dart';
import 'package:flutter_qrcreator/constants.dart';

ThemeData theme() {
  return ThemeData(
    primaryColor: qrPrimaryColor,
    scaffoldBackgroundColor: qrPrimaryColor,
    textButtonTheme: TextButtonThemeData(
      style: TextButton.styleFrom(
        backgroundColor: qrButtonColor,
        primary: qrPrimaryColor,
        textStyle: TextStyle(fontSize: 20),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(10),
        ),
        minimumSize: Size(150, 50),
      ),
    ),
  );
}
