abstract class IEncryptor {
  String encrypt(String key, String plainText);

  String decrypt(String key, String encryptedData);
}
