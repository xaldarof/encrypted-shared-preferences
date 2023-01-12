import 'package:encrypt/encrypt.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'encryptor.dart';

class EncryptedSharedPreferences {
  EncryptedSharedPreferences._();

  final _key = "1212 12 1212 333 1234 256 124575";
  static late SharedPreferences? _sharedPreferences;
  final AESEncryptor _aes = AESEncryptor();

  static final EncryptedSharedPreferences _instance = EncryptedSharedPreferences._();

  factory EncryptedSharedPreferences() {
    return _instance;
  }

  static Future<EncryptedSharedPreferences> getInstance() async {
    _sharedPreferences = await SharedPreferences.getInstance();
    return _instance;
  }

  Future<bool> clear() async {
    assert(_sharedPreferences != null);
    return _sharedPreferences!.clear();
  }

  Future<bool> setString(String dataKey, String dataValue) async {
    assert(_sharedPreferences != null);
    Encrypted encryptedKey = _aes.encrypt(_key, dataKey);
    String encryptedBase64Key = encryptedKey.base64;
    Encrypted encryptedData = _aes.encrypt(_key, dataValue);
    String encryptedBase64Value = encryptedData.base64;

    return _sharedPreferences!.setString(encryptedBase64Key, encryptedBase64Value);
  }

  String? getString(String key) {
    assert(_sharedPreferences != null);
    String dataKey = _aes.encrypt(_key, key).base64;
    var value = _sharedPreferences!.getString(dataKey);
    if (value != null) {
      var decrypted = _aes.decrypt(_key, Encrypted.fromBase64(value));
      return decrypted;
    } else {
      return null;
    }
  }

  Future<bool> remove(String key) async {
    assert(_sharedPreferences != null);
    String dataKey = _aes.encrypt(_key, key).base64;
    var value = _sharedPreferences!.getString(dataKey);
    return _sharedPreferences!.remove(value!);
  }
}
