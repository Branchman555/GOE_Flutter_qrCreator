import 'package:flutter_qrcreator/constants.dart';
import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart' as pw;
import 'package:flutter/material.dart';
import 'dart:async';
import 'dart:io';

void main() {
  final myPdf = myPdfModule();

  final image = pw.MemoryImage(
    File('$imageTempDir/_0.png').readAsBytesSync(),
  );

  List<String> test = [
    '1',
    '2',
    '1',
    '2',
    '1',
    '2',
    '1',
    '2',
    '1',
    '2',
    '1',
    '2',
    '1'
  ];
  myPdf.genPage(test);
  myPdf.savePdf("GG");
}

class myPdfModule {
  final pdf = pw.Document();

  myPdfModule();

  Future savePdf(String fileName) async {
    final file = File("$imageTempDir/$fileName.pdf");
    await file.writeAsBytes(await pdf.save());
  }

  pw.Container ContainerFromList(List<String> row) {
    final listLen = row.length;
    final rowLen = listLen ~/ 4;
    final remainLen = listLen % 4;
    var image;
    List<pw.Widget> result = [];
    List<pw.Widget> bufferWidget = [];

    for (int i = 0; i < rowLen; i++) {
      bufferWidget = [];
      for (int j = 0; j < 4; j++) {
        image = pw.MemoryImage(
          File('$imageTempDir/_${i * 4 + j}.png').readAsBytesSync(),
        );
        bufferWidget.add(pw.Container(
          child: pw.Column(children: [
            pw.Image(image, width: qrWidth, height: qrHeight),
            pw.Text("${row[i * 4 + j]}"),
          ]),
        ));
        bufferWidget.add(pw.Spacer());
      }
      result.add(
        pw.Container(
          child: pw.Row(
            children: bufferWidget,
          ),
        ),
      );
      result.add(pw.SizedBox(
        height: 30,
      ));
    }

    bufferWidget = [];
    for (int j = 0; j < remainLen; j++) {
      image = pw.MemoryImage(
        File('$imageTempDir/_${rowLen * 4 + j}.png').readAsBytesSync(),
      );
      bufferWidget.add(pw.Container(
        child: pw.Column(children: [
          pw.Image(image, width: qrWidth, height: qrHeight),
          pw.Text("${rowLen * 4 + j}")
        ]),
      ));
      bufferWidget.add(pw.Spacer());
    }
    result.add(
      pw.Container(
        child: pw.Row(
          children: bufferWidget,
        ),
      ),
    );

    return pw.Container(
      child: pw.Column(
        children: result,
      ),
    );
  }

  void genPage(List<String> allRow) {
    final int rowLen = allRow.length;
    final int pages = rowLen ~/ maxPageImg;
    final int remainLen = rowLen % maxPageImg;
    List<String> editList = [];
    for (int i = 0; i < pages; i++) {
      editList =
          allRow.sublist(0 + i * maxPageImg, maxPageImg + i * maxPageImg);
      pdf.addPage(pw.Page(
          pageFormat: PdfPageFormat.a4,
          build: (pw.Context context) {
            return pw.Center(
              child: ContainerFromList(editList),
            ); // Center
          })); // Page
    }

    editList = allRow.sublist(rowLen - remainLen);
    pdf.addPage(pw.Page(
        pageFormat: PdfPageFormat.a4,
        build: (pw.Context context) {
          return pw.Center(
            child: ContainerFromList(editList),
          ); // Center
        })); // Page
  }
}
