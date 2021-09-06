import 'dart:io';
import 'package:excel/excel.dart';

void main() {
  var file = "C:/Users/branc/Documents/카카오톡 받은 파일/물품목록정보_20210803.xlsx";
  var bytes = File(file).readAsBytesSync();
  var excel = Excel.decodeBytes(bytes);

  for (var table in excel.tables.keys) {
    print(table); //sheet Name
    print(excel.tables[table]!.maxCols);
    print(excel.tables[table]!.maxRows);
    for (var row in excel.tables[table]!.rows) {
      print("$row");
    }
  }
}
