import 'package:encrypt/encrypt.dart';

class AESEncryptor {
  Encrypted encrypt(String key, String plainText, {AESMode? mode}) {
    final cipherKey = Key.fromUtf8(key);
    final encryptService = Encrypter(AES(cipherKey, mode: mode ?? AESMode.cbc));
    final initVector = IV.fromUtf8(key.substring(0, 16));

    Encrypted encryptedData = encryptService.encrypt(plainText, iv: initVector);
    return encryptedData;
  }

  String decrypt(String key, Encrypted encryptedData, {AESMode? mode}) {
    final cipherKey = Key.fromUtf8(key);
    final encryptService = Encrypter(AES(cipherKey, mode: mode ?? AESMode.cbc));
    final initVector = IV.fromUtf8(key.substring(0, 16));

    return encryptService.decrypt(encryptedData, iv: initVector);
  }

  const AESEncryptor();
}
