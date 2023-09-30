import 'package:encrypt/encrypt.dart';
import 'package:encrypt_shared_preferences/provider.dart';



class AESEncryptor extends Encryptor {
  @override
  Encrypted encrypt(String key, String plainText) {
    assert(key.length == 16);
    final cipherKey = Key.fromUtf8(key);
    final encryptService = Encrypter(AES(cipherKey));
    final initVector = IV.fromLength(16);

    Encrypted encryptedData = encryptService.encrypt(plainText, iv: initVector);
    return encryptedData;
  }

  @override
  String decrypt(String key, Encrypted encryptedData) {
    assert(key.length == 16);
    final cipherKey = Key.fromUtf8(key);
    final encryptService = Encrypter(AES(cipherKey));
    final initVector = IV.fromLength(16);

    return encryptService.decrypt(encryptedData, iv: initVector);
  }
}
