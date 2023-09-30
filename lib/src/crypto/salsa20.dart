import 'package:encrypt/encrypt.dart';
import 'package:encrypt_shared_preferences/provider.dart';

class Salsa20Encryptor extends Encryptor {
  @override
  Encrypted encrypt(String key, String plainText) {
    assert(key.length == 16);
    final cipherKey = Key.fromUtf8(key);
    final encryptService = Encrypter(Salsa20(cipherKey));
    final initVector = IV.fromUtf8(key.substring(0, 8));

    Encrypted encryptedData = encryptService.encrypt(plainText, iv: initVector);
    return encryptedData;
  }

  @override
  String decrypt(String key, Encrypted encryptedData) {
    assert(key.length == 16);
    final cipherKey = Key.fromUtf8(key);
    final encryptService = Encrypter(Salsa20(cipherKey));
    final initVector = IV.fromUtf8(key.substring(0, 8));

    return encryptService.decrypt(encryptedData, iv: initVector);
  }
}
