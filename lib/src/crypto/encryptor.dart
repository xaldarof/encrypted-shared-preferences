import 'package:encrypt/encrypt.dart';

enum EncryptionAlgorithm {
  aes,
  salsa20,
}

abstract class Encryptor {
  Encrypted encrypt(String key, String plainText);

  String decrypt(String key, Encrypted encryptedData);
}
