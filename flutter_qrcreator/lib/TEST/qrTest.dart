import 'package:qr_flutter/qr_flutter.dart';
import 'dart:typed_data';
import 'dart:io';
import 'dart:async';
import 'package:flutter/material.dart';

void main() {
  // QrImage(
  //   data: 'This is a simple QR code',
  //   version: QrVersions.auto,
  //   size: 320,
  //   gapless: false,
  // )
  final myByte = makeQR(
      "8p+ee8E4bhYaFaljxvm98P4nhZax51GmbeZcTp0JcjGU/3L6c0JH09F9sYeL5Y5j2naxirXaiPf3vDAY6WgXcbi91O+EA5nEZoUsdb/8J++EFPd3lexDTh3c6xMUg0AjFV/aq/Drc/t/9li+OBEIoi2PT7Fxqgujlp69vEgw9nPNKqOprx8I1RbRunqTVDK65LAx5dLJqNaBq11ITSg=12345");
  return;
}

Future<ByteData?> makeQR(String data) async {
  ByteData? qrBytes = await QrPainter(
    data: data,
    gapless: true,
    version: QrVersions.auto,
    emptyColor: Colors.white,
  ).toImageData(250);

  saveImage(qrBytes!, "TestPIC");

  return qrBytes;
}

Future<File> saveImage(ByteData data, String name) async {
  //retrieve local path for device
  var path = "C:/Users/branc/Documents"; //<-- see below function

  final buffer = data.buffer;
  return new File('$path/$name.png')
      .writeAsBytes(buffer.asUint8List(data.offsetInBytes, data.lengthInBytes));
}
