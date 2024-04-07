import 'package:encrypt/encrypt.dart';
import 'package:encrypt_shared_preferences/provider.dart';

class AESEncryptor extends IEncryptor {
  @override
  String encrypt(String key, String plainText) {
    assert(key.length == 16);
    final cipherKey = Key.fromUtf8(key);
    final encryptService = Encrypter(AES(cipherKey));
    final initVector = IV.fromUtf8(key);

    Encrypted encryptedData = encryptService.encrypt(plainText, iv: initVector);
    return encryptedData.base64;
  }

  @override
  String decrypt(String key, String encryptedDataBase64) {
    assert(key.length == 16);
    final cipherKey = Key.fromUtf8(key);
    final encryptService = Encrypter(AES(cipherKey));
    final initVector = IV.fromUtf8(key);

    return encryptService.decrypt(Encrypted.fromBase64(encryptedDataBase64), iv: initVector);
  }
}
