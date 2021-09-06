import 'package:qr_flutter/qr_flutter.dart';
import 'dart:typed_data';
import 'dart:io';
import 'dart:async';
import 'package:flutter/material.dart';

Future<ByteData?> makeQR(String data, String fileName) async {
  ByteData? qrBytes = await QrPainter(
    data: data,
    gapless: true,
    version: QrVersions.auto,
    emptyColor: Colors.white,
  ).toImageData(270);

  saveImage(qrBytes!, fileName);

  return qrBytes;
}

Future<File> saveImage(ByteData data, String name) async {
  //retrieve local path for device
  //var path = "C:/Users/branc/Documents"; //<-- see below function

  final buffer = data.buffer;

  return new File('$name.png')
      .writeAsBytes(buffer.asUint8List(data.offsetInBytes, data.lengthInBytes));
}
