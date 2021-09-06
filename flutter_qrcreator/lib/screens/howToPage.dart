import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_qrcreator/constants.dart';
import 'dart:async';
import 'package:percent_indicator/percent_indicator.dart';

class howToPage extends StatefulWidget {
  @override
  _howToPageState createState() => _howToPageState();
}

class _howToPageState extends State<howToPage> {
  int pageNum = 1;

  MaterialColor leftColor = Colors.grey;
  MaterialColor rightColor = qrButtonColor;

  @override
  Widget build(BuildContext context) {
    if (pageNum == 1) {
      leftColor = Colors.grey;
      rightColor = qrButtonColor;
    } else if (pageNum == 9) {
      leftColor = qrButtonColor;
      rightColor = Colors.grey;
    } else {
      leftColor = qrButtonColor;
      rightColor = qrButtonColor;
    }
    return Scaffold(
        body: Container(
      alignment: Alignment.center,
      color: Colors.white,
      width: winWidth,
      height: winHeight,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Container(
                  alignment: Alignment.centerLeft,
                  child: Text("사용방법",
                      style:
                          TextStyle(fontSize: 30, fontWeight: FontWeight.bold)),
                ),
                Spacer(),
                TextButton(
                  style: TextButton.styleFrom(
                    backgroundColor: leftColor,
                    minimumSize: Size(70, 70),
                  ),
                  onPressed: () {
                    if (pageNum > 1) {
                      setState(() {
                        pageNum -= 1;
                      });
                    }
                  },
                  child: Text("<"),
                ),
                SizedBox(height: 210),
              ]),
          Container(
            //color: Colors.blue,
            width: 480,
            height: 480,
            child: Image.asset(
              "assets/$pageNum.png",
            ),
          ),
          Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                SizedBox(height: 175),
                TextButton(
                  style: TextButton.styleFrom(
                    backgroundColor: rightColor,
                    minimumSize: Size(70, 70),
                  ),
                  onPressed: () {
                    if (pageNum < 9) {
                      setState(() {
                        pageNum += 1;
                      });
                    }
                  },
                  child: Text(">"),
                ),
                Spacer(),
                TextButton(
                  style: TextButton.styleFrom(
                    backgroundColor: qrCancelButtonColor,
                    minimumSize: Size(100, 50),
                  ),
                  onPressed: () {
                    Navigator.pop(context);
                  },
                  child: Text("뒤로가기"),
                ),
                SizedBox(
                  height: 10,
                )
              ]),
        ],
      ),
    ));
  }

  void showImgDialog(BuildContext context) async {
    String result = await showDialog(
      context: context,
      barrierDismissible: false, // user must tap button!
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('사용방법 $pageNum Page'),
          content: Image.asset(
            "assets/$pageNum.png",
            width: 800,
            height: 800,
          ),
          actions: [
            TextButton(
              child: Text('OK'),
              onPressed: () {
                Navigator.pop(context, "OK");
              },
            ),
          ],
        );
      },
    );
  }
}
