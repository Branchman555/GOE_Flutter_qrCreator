import 'package:crypto/crypto.dart';
import 'dart:convert' show utf8;
import 'package:encrypt/encrypt.dart';

// void main() {
//   final encrypter = encryptModule();
//   encrypter.registerKey("용수철중학교");
//   final encrypted = encrypter.encryptText("Test Text");
//   print(encrypted);
//   final decrypted = encrypter.decryptText(encrypted);
//   print(decrypted);
// }

class encryptModule {
  String? schoolKey;
  var encrypter;
  var iv = IV.fromLength(16);

  encryptModule();
  void registerKey(String plainText) {
    var bytes = utf8.encode(plainText);
    var digest = sha256.convert(bytes);
    schoolKey = digest.toString().substring(5, 29);
    encrypter = Encrypter(AES(Key.fromUtf8(schoolKey!), padding: null));
  }

  String encryptText(String plainText) {
    if (schoolKey!.isNotEmpty) {
      return encrypter.encrypt(plainText, iv: iv).base64 +
          schoolKey!.substring(0, 5);
    }
    return "";
  }

  String decryptText(String plainText) {
    if (schoolKey!.isNotEmpty) {
      if (plainText.substring(plainText.length - 5) ==
          schoolKey!.substring(0, 5)) {
        plainText = plainText.substring(0, plainText.length - 5);
        return encrypter.decrypt(Encrypted.fromBase64(plainText), iv: iv);
      }
    }
    return "";
  }
}
