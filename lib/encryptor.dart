import 'package:encrypt/encrypt.dart';

class AESEncryptor {
  Encrypted encrypt(String key, String plainText) {
    final cipherKey = Key.fromUtf8(key);
    final encryptService = Encrypter(AES(cipherKey, mode: AESMode.cbc));
    final initVector = IV.fromUtf8(key.substring(0, 16));

    Encrypted encryptedData = encryptService.encrypt(plainText, iv: initVector);
    return encryptedData;
  }

  String decrypt(String key, Encrypted encryptedData) {
    final cipherKey = Key.fromUtf8(key);
    final encryptService = Encrypter(AES(cipherKey, mode: AESMode.cbc));
    final initVector = IV.fromUtf8(key.substring(0, 16));

    return encryptService.decrypt(encryptedData, iv: initVector);
  }
}
