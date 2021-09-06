import 'package:flutter/material.dart';
import 'package:flutter_qrcreator/constants.dart';
import 'package:flutter_qrcreator/screens/modeSelectPage.dart';
import 'package:flutter_qrcreator/screens/registerPage.dart';
import 'package:flutter_qrcreator/screens/fileLoadPage.dart';
import 'package:flutter_qrcreator/screens/howToPage.dart';
import 'dart:io';
import 'package:flutter_qrcreator/theme.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatefulWidget {
  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  @override
  initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      theme: theme(),
      debugShowCheckedModeBanner: false,
      initialRoute: "/Home",
      routes: {
        "/Home": (context) => modeSelectPage(),
        "/Register": (context) => registerPage(),
        "/fileLoad": (context) => fileLoadPage(),
        "/howTo": (context) => howToPage(),
      },
    );
  }
}
