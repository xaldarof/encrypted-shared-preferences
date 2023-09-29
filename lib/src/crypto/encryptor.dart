import 'package:encrypt/encrypt.dart';

enum EncryptionAlgorithm {
  aes,
  salsa20,
}

abstract class Encryptor {
  Encrypted encrypt(String key, String plainText);

  String decrypt(String key, Encrypted encryptedData);
}

class AESEncryptor extends Encryptor {
  @override
  Encrypted encrypt(String key, String plainText) {
    assert(key.length == 16);
    final cipherKey = Key.fromUtf8(key);
    final encryptService = Encrypter(AES(cipherKey));
    final initVector = IV.fromUtf8(key.substring(0, 16));

    Encrypted encryptedData = encryptService.encrypt(plainText, iv: initVector);
    return encryptedData;
  }

  @override
  String decrypt(String key, Encrypted encryptedData) {
    assert(key.length == 16);
    final cipherKey = Key.fromUtf8(key);
    final encryptService = Encrypter(AES(cipherKey));
    final initVector = IV.fromUtf8(key.substring(0, 16));

    return encryptService.decrypt(encryptedData, iv: initVector);
  }
}

class Salsa20Encryptor extends Encryptor {
  @override
  Encrypted encrypt(String key, String plainText) {
    assert(key.length == 16);
    final cipherKey = Key.fromUtf8(key);
    final encryptService = Encrypter(Salsa20(cipherKey));
    final initVector = IV.fromUtf8(key.substring(0, 16));

    Encrypted encryptedData = encryptService.encrypt(plainText, iv: initVector);
    return encryptedData;
  }

  @override
  String decrypt(String key, Encrypted encryptedData) {
    assert(key.length == 16);
    final cipherKey = Key.fromUtf8(key);
    final encryptService = Encrypter(Salsa20(cipherKey));
    final initVector = IV.fromUtf8(key.substring(0, 16));

    return encryptService.decrypt(encryptedData, iv: initVector);
  }
}
