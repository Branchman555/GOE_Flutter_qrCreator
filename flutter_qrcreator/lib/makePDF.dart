import 'package:flutter_qrcreator/constants.dart';
import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart' as pw;
import 'dart:async';
import 'dart:io';

class myPdfModule {
  var pdf = pw.Document();

  myPdfModule();

  Future savePdf(String dlDir, String fileName) async {
    final file = File("$dlDir/$fileName.pdf");
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
          width: qrMargin,
          child: pw.Column(children: [
            pw.Image(image, width: qrWidth, height: qrHeight),
            pw.Text("${row[i * 4 + j]}"),
          ]),
        ));
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
        width: qrMargin,
        child: pw.Column(children: [
          pw.Image(image, width: qrWidth, height: qrHeight),
          pw.Text("${row[rowLen * 4 + j]}")
        ]),
      ));
    }
    result.add(
      pw.Container(
        child: pw.Row(
          crossAxisAlignment: pw.CrossAxisAlignment.start,
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

  void _resetPDF() {
    pdf = pw.Document();
  }

  void genPage(List<String> allRow) {
    _resetPDF();
    final int rowLen = allRow.length;
    final int pages = rowLen ~/ maxPageImg;
    final int remainLen = rowLen % maxPageImg;
    for (int i = 0; i < pages; i++) {
      var editList =
          allRow.sublist(0 + i * maxPageImg, maxPageImg + i * maxPageImg);
      var temp = ContainerFromList(editList);
      pdf.addPage(
        pw.Page(
          pageFormat: PdfPageFormat.a4,
          build: (pw.Context context) {
            return pw.Center(child: temp);
          },
        ),
      ); // Page
    }

    var editList2 = allRow.sublist(rowLen - remainLen);
    var temp = ContainerFromList(editList2);
    pdf.addPage(
      pw.Page(
        pageFormat: PdfPageFormat.a4,
        build: (pw.Context context) {
          return pw.Center(
            child: temp,
          );
        },
      ),
    ); // Page
  }
}
