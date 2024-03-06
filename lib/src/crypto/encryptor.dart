import 'package:encrypt/encrypt.dart';

abstract class Encryptor {
  Encrypted encrypt(String key, String plainText);

  String decrypt(String key, Encrypted encryptedData);
}
