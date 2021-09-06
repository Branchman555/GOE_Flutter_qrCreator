import 'dart:ui';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_qrcreator/constants.dart';
import 'dart:async';
import 'package:flutter_qrcreator/components/ScreenData.dart';
import 'dart:io';

class modeSelectPage extends StatelessWidget {
  String schoolName = "";
  String schoolRegText = defaultSchoolName;

  @override
  Widget build(BuildContext context) {
    if (ModalRoute.of(context)!.settings.arguments.toString() != 'null') {
      final args = ModalRoute.of(context)!.settings.arguments as screen_data;
      if (_isSchoolName(args.name)) {
        schoolName = args.name;
        schoolRegText = "현재 등록된 학교 : $schoolName";
      } else {
        schoolRegText = defaultSchoolName;
      }
    }
    return Scaffold(
        body: Container(
            alignment: Alignment.center,
            color: Colors.white,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                SizedBox(
                  height: 20,
                ),
                Container(
                  color: Colors.blue,
                  width: 500,
                  height: 300,
                  child: Column(
                    children: [
                      SizedBox(
                        height: 30,
                      ),
                      Image.asset(
                        "assets/GOE_BI.png",
                      ),
                      Text("물품 QR코드 변환 시스템",
                          style: TextStyle(
                              color: Colors.black,
                              fontSize: 40.0,
                              fontWeight: FontWeight.bold)),
                      SizedBox(
                        height: 30,
                      ),
                      Text(schoolRegText,
                          style: TextStyle(
                              color: Colors.black54,
                              fontSize: 20.0,
                              fontWeight: FontWeight.bold)),
                    ],
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.all(25.0),
                  child: Container(
                    width: 500,
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Spacer(),
                        TextButton(
                          onPressed: () {
                            Navigator.pushNamed(context, "/Register");
                          },
                          child: Text("학교등록"),
                        ),
                        Spacer(),
                        TextButton(
                          onPressed: () {
                            if (_isSchoolName(schoolName) == true) {
                              Navigator.pushNamed(context, "/fileLoad",
                                  arguments: screen_data(schoolName));
                            } else {
                              showCupertinoDialog(
                                context: context,
                                builder: (context) => CupertinoAlertDialog(
                                  title: Text("학교를 등록해주세요"),
                                  actions: [
                                    CupertinoDialogAction(
                                      child: Text("확인"),
                                      onPressed: () {
                                        Navigator.pop(context);
                                      },
                                    )
                                  ],
                                ),
                              );
                            }
                          },
                          child: Text("파일변환"),
                        ),
                        Spacer(),
                        TextButton(
                          onPressed: () {
                            Navigator.pushNamed(context, "/howTo");
                          },
                          child: Text("사용방법"),
                        ),
                        Spacer(),
                      ],
                    ),
                  ),
                ),
              ],
            )));
  }

  bool _isSchoolName(String text) {
    var result = true;
    result &= text.contains("학교");
    result &= text.isNotEmpty;

    return result;
  }
}
