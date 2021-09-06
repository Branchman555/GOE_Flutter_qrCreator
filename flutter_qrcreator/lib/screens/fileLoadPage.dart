import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:file_picker/file_picker.dart';

import 'dart:io';
import 'package:excel/excel.dart';

import 'package:flutter_qrcreator/keyBox.dart';

import 'package:flutter_qrcreator/makeQR.dart';
import 'dart:async';
import 'package:flutter_qrcreator/constants.dart';

import 'package:flutter_qrcreator/makePDF.dart';
import 'package:flutter_qrcreator/components/ScreenData.dart';

class fileLoadPage extends StatefulWidget {
  @override
  _fileLoadPageState createState() => _fileLoadPageState();
}

class _fileLoadPageState extends State<fileLoadPage> {
  double percent = 0.0;
  List<List<String>> excelData = [];
  List<String> qrTitle = [];

  bool excelReadResult = false;
  bool qrConvertResult = false;

  String excelFileName = "";
  int excelSheetCount = 0;
  int excelRows = 0;
  int excelCols = 0;

  MaterialColor qrCvtBtnColor = qrButtonColor;
  MaterialColor qrCvtBackColor = Colors.grey;

  String downloadPath = "";
  String notiString = customFileLoadPage_2;

  final myEncrypter = encryptModule();
  final myPDF = myPdfModule();

  @override
  Widget build(BuildContext context) {
    final args = ModalRoute.of(context)!.settings.arguments as screen_data;
    if (args.name != null) {
      myEncrypter.registerKey(args.name);
    }
    if (excelReadResult == true) {
      notiString = customFileLoadPage_2;
      qrCvtBtnColor = Colors.green;
      qrCvtBackColor = Colors.grey;
      if (qrConvertResult == true) {
        notiString = customFileLoadPage_3;
        qrCvtBackColor = Colors.green;
      }
    } else {
      notiString = customFileLoadPage_1;
      qrCvtBtnColor = Colors.grey;
    }
    return Scaffold(
      body: Container(
        alignment: Alignment.center,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Container(
              child: Column(
                children: [
                  SizedBox(
                    height: 20,
                  ),
                  Container(
                    height: 3,
                    width: winWidth,
                    color: qrButtonColor,
                  ),
                  SizedBox(
                    height: 20,
                  ),
                ],
              ),
            ),
            Container(
              decoration: BoxDecoration(
                  border: Border.all(color: Colors.black54, width: 2)),
              alignment: Alignment.center,
              width: winShowWidth - 30,
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Spacer(),
                  Container(
                    child: Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Text(notiString,
                          style: TextStyle(
                              color: Colors.black,
                              fontSize: 20.0,
                              fontWeight: FontWeight.bold)),
                    ),
                    width: 260,
                    height: 75,
                  ),
                  Spacer(),
                  Container(
                    width: 2,
                    height: 75,
                    color: Colors.black54,
                  ),
                  Spacer(),
                  Container(
                    alignment: Alignment.center,
                    //width: winShowWidth - 300,
                    height: 75,
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        TextButton(
                            onPressed: () {
                              _getFile();
                            },
                            child: Text(
                              "EXCEL 불러오기",
                              style: TextStyle(
                                fontSize: 16,
                              ),
                            )),
                        SizedBox(
                          width: 10,
                        ),
                        TextButton(
                            style: TextButton.styleFrom(
                              backgroundColor: qrCvtBtnColor,
                            ),
                            onPressed: () {
                              if (excelReadResult) {
                                _totalConvert();
                              } else {
                                showCupertinoDialog(
                                  context: context,
                                  builder: (context) => CupertinoAlertDialog(
                                    title: Text("Excel 파일을 불러와주세요"),
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
                            child: Text("QR변환"))
                      ],
                    ),
                  ),
                  Spacer(),
                ],
              ),
            ),
            SizedBox(
              height: 20,
            ),
            Container(
              width: winShowWidth - 30,
              height: 230,
              color: qrCvtBackColor,
              child: Padding(
                padding: const EdgeInsets.all(10.0),
                child: makeTextCont(qrConvertResult),
              ),
            ),
            SizedBox(
              height: 10,
            ),
            Container(
                width: winShowWidth - 30,
                alignment: Alignment.centerRight,
                child: TextButton(
                  style: TextButton.styleFrom(
                    backgroundColor: qrCancelButtonColor,
                  ),
                  onPressed: () {
                    Navigator.pop(context);
                  },
                  child: Text("뒤로가기"),
                ))
          ],
        ),
      ),
    );
  }

  Column makeTextCont(bool qrCvtState) {
    List<Widget> resultWidget = [];

    resultWidget.add(Text("파일명 : $excelFileName"));
    resultWidget.add(Text("Sheet 수 : $excelSheetCount"));
    resultWidget.add(Text("전체 행 : $excelRows 행"));
    resultWidget.add(Text("전체 열 : $excelCols 열"));

    if (qrCvtState == true) {
      resultWidget.add(Text("==" * 30));
      resultWidget.add(Text("총 QR코드 개수 : ${qrTitle.length} 개"));
      resultWidget.add(Text("1Page 내 최대 QR코드 : 16 개"));
      resultWidget.add(Text(
          "총 Page : ${(qrTitle.length % 16) > 0 ? qrTitle.length ~/ 16 + 1 : qrTitle.length ~/ 16} 장"));
    }
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: resultWidget,
    );
  }

  Future _getFile() async {
    final fileExtensions = ['xlsx', 'xls'];
    FilePickerResult? result = await FilePicker.platform
        .pickFiles(type: FileType.custom, allowedExtensions: fileExtensions);
    bool myresult = true;
    if (result != null) {
      PlatformFile file = result.files.first;
      if (!fileExtensions.contains(file.extension)) {
        return;
      }

      var bytes = File(file.path!).readAsBytesSync();
      var excel = Excel.decodeBytes(bytes);

      var saveFlag = false;
      excelData = [];
      qrTitle = [];

      for (var table in excel.tables.keys) {
        excelSheetCount = excel.tables.length;
        for (var row in excel.tables[table]!.rows) {
          // var cvtRow = row.map((e) => e.value).toList();
          //print("$cvtRow");
          //print(cvtRow[0].runtimeType);
          if (row.isNotEmpty) {
            if (row[0] != null) {
              if (row[0]!.value.toString() == 'G2B목록번호' && saveFlag != true) {
                excelCols = row.length;
                saveFlag = true;
              } else if (saveFlag == true) {
                excelData.add(_cvtData(row));
                //print(row[0]!.value.toString());
              }
            }
          }
        }
      }
      if (excelData.length > 0) {
        myresult = true;
      } else {
        myresult = false;
      }
      setState(() {
        excelRows = excelData.length;
        excelFileName = file.name;
        excelReadResult = myresult;
        qrConvertResult = false;
      });
    } else {
      // User canceled the picker
    }
  }

  void _totalConvert() async {
    String? result = await FilePicker.platform
        .getDirectoryPath(dialogTitle: "다운로드 경로를 선택하세요");
    if (result == null) {
      setState(() {
        downloadPath = "";
      });
    } else {
      downloadPath = result;
      await _makeQRCode();
      myPDF.genPage(qrTitle);
      await myPDF.savePdf(downloadPath, "QR리스트_${excelFileName.split(".")[0]}");
      await _deleteFile();

      setState(() {
        downloadPath = result;
        qrConvertResult = true;
      });
    }
  }

  Future _deleteFile() async {
    try {
      int i = 0;
      for (var row in excelData) {
        final file = File("$imageTempDir/_$i.png");
        await file.delete();
        i++;
      }
    } catch (e) {
      print(e);
      return 0;
    }
  }

  List<String> _cvtData(List<Data?> plainData) {
    List<String> temp = [];

    if (plainData.length >= 19) {
      temp.add(plainData[0] != null ? plainData[0]!.value.toString() : "#");
      temp.add(plainData[1] != null ? plainData[1]!.value.toString() : "#");
      temp.add(plainData[9] != null ? plainData[9]!.value.toString() : "#");
      temp.add(plainData[17] != null ? plainData[17]!.value.toString() : "#");
      temp.add(plainData[18] != null ? plainData[18]!.value.toString() : "#");
      temp.add(plainData[3] != null ? plainData[3]!.value.toString() : "#");
      temp.add(plainData[2] != null ? plainData[2]!.value.toString() : "#");
      qrTitle.add(plainData[2]!.value.toString());

      temp.add(plainData[6] != null
          ? _cvtPrice(plainData[6]!.value.toString())
          : "#");
      temp.add(plainData[7] != null
          ? _cvtYear(plainData[7]!.value.toString())
          : "#");
    }

    return temp;
  }

  String _cvtPrice(String plainString) {
    String editBuffer;
    editBuffer = plainString.substring(0, plainString.length - 2);
    editBuffer = editBuffer.substring(0, editBuffer.length - 3) +
        "," +
        editBuffer.substring(editBuffer.length - 3);
    if (editBuffer.length > 7) {
      editBuffer = editBuffer.substring(0, editBuffer.length - 7) +
          "," +
          editBuffer.substring(editBuffer.length - 7);
    }
    return editBuffer;
  }

  String _cvtYear(String plainString) {
    String editBuffer;
    editBuffer = plainString.substring(0, plainString.length - 2);
    return editBuffer;
  }

  Future _makeQRCode() async {
    int i = 0;
    for (var row in excelData) {
      await makeQR(
          myEncrypter.encryptText(_stringfy(row)), "$imageTempDir/_$i");
      i++;
    }
  }

  String _stringfy(List<String> row) {
    return row.join('%');
  }
}

// TextButton(
// onPressed: () {
// Navigator.pop(context);
// },
// child: Text("EXIT"),
// ),
