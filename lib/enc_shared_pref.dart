import 'package:encrypt/encrypt.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'encryptor.dart';

class EncryptedSharedPreferences {
  EncryptedSharedPreferences._();

  String? _key;
  AESMode? _aesMode;

  static late SharedPreferences? _sharedPreferences;
  final AESEncryptor _aes = const AESEncryptor();

  static final EncryptedSharedPreferences _instance = EncryptedSharedPreferences._();

  factory EncryptedSharedPreferences() {
    return _instance;
  }

  static Future<EncryptedSharedPreferences> getInstance() async {
    _sharedPreferences = await SharedPreferences.getInstance();
    return _instance;
  }

  void setEncryptionKey(String key) {
    _key = key;
  }

  void setEncryptionMode(AESMode mode) {
    _aesMode = mode;
  }

  Future<bool> clear() async {
    assert(_sharedPreferences != null);
    return _sharedPreferences!.clear();
  }

  Future<bool> remove(String key) async {
    assert(_sharedPreferences != null);
    String dataKey = _aes.encrypt(_key!, key, mode: _aesMode).base64;
    return _sharedPreferences!.remove(dataKey);
  }

  Future<Set<String>> getKeys() async {
    assert(_sharedPreferences != null);
    return _sharedPreferences!.getKeys().map((e) {
      String dataKey = _aes.decrypt(_key!, Encrypted.fromBase64(e), mode: _aesMode);
      return dataKey;
    }).toSet();
  }

  Future<Map<String, String>> getKeyValues() async {
    assert(_sharedPreferences != null);

    var keyValues = Map<String, String>.fromIterable(key: (v) {
      String dataKey = _aes.decrypt(_key!, Encrypted.fromBase64(v), mode: _aesMode);
      return dataKey;
    }, value: (v) {
      String dataValue = _aes
          .decrypt(_key!, Encrypted.fromBase64(_sharedPreferences!.getString(v)!), mode: _aesMode);
      return dataValue;
    }, _sharedPreferences!.getKeys());

    return keyValues;
  }

  Future<bool> setString(String dataKey, String dataValue) async {
    assert(_sharedPreferences != null);
    assert(_key != null,
        "Encryption key must not be null ! To fix it use .setEncryptionKey(key) method");
    Encrypted encryptedKey = _aes.encrypt(_key!, dataKey, mode: _aesMode);
    String encryptedBase64Key = encryptedKey.base64;
    Encrypted encryptedData = _aes.encrypt(_key!, dataValue, mode: _aesMode);
    String encryptedBase64Value = encryptedData.base64;

    return _sharedPreferences!.setString(encryptedBase64Key, encryptedBase64Value);
  }

  Future<bool> setInt(String dataKey, int dataValue) async {
    assert(_sharedPreferences != null);
    assert(_key != null,
        "Encryption key must not be null ! To fix it use .setEncryptionKey(key) method");
    Encrypted encryptedKey = _aes.encrypt(_key!, dataKey, mode: _aesMode);
    String encryptedBase64Key = encryptedKey.base64;
    Encrypted encryptedData = _aes.encrypt(_key!, dataValue.toString(), mode: _aesMode);
    String encryptedBase64Value = encryptedData.base64;

    return _sharedPreferences!.setString(encryptedBase64Key, encryptedBase64Value);
  }

  Future<bool> setDouble(String dataKey, double dataValue) async {
    assert(_sharedPreferences != null);
    assert(_key != null,
        "Encryption key must not be null ! To fix it use .setEncryptionKey(key) method");
    Encrypted encryptedKey = _aes.encrypt(_key!, dataKey, mode: _aesMode);
    String encryptedBase64Key = encryptedKey.base64;
    Encrypted encryptedData = _aes.encrypt(_key!, dataValue.toString(), mode: _aesMode);
    String encryptedBase64Value = encryptedData.base64;

    return _sharedPreferences!.setString(encryptedBase64Key, encryptedBase64Value);
  }

  Future<bool> setBoolean(String dataKey, bool dataValue) async {
    assert(_sharedPreferences != null);
    assert(_key != null,
        "Encryption key must not be null ! To fix it use .setEncryptionKey(key) method");
    Encrypted encryptedKey = _aes.encrypt(_key!, dataKey, mode: _aesMode);
    String encryptedBase64Key = encryptedKey.base64;
    Encrypted encryptedData = _aes.encrypt(_key!, dataValue.toString(), mode: _aesMode);
    String encryptedBase64Value = encryptedData.base64;

    return _sharedPreferences!.setString(encryptedBase64Key, encryptedBase64Value);
  }

  String? getString(String key) {
    assert(_sharedPreferences != null);
    assert(_key != null,
        "Encryption key must not be null ! To fix it use .setEncryptionKey(key) method");
    String dataKey = _aes.encrypt(_key!, key, mode: _aesMode).base64;
    var value = _sharedPreferences!.getString(dataKey);
    if (value != null) {
      var decrypted = _aes.decrypt(_key!, Encrypted.fromBase64(value), mode: _aesMode);
      return decrypted;
    } else {
      return null;
    }
  }

  int? getInt(String key) {
    assert(_sharedPreferences != null);
    assert(_key != null,
        "Encryption key must not be null ! To fix it use .setEncryptionKey(key) method");
    String dataKey = _aes.encrypt(_key!, key, mode: _aesMode).base64;
    var value = _sharedPreferences!.getString(dataKey);
    if (value != null) {
      var decrypted = _aes.decrypt(_key!, Encrypted.fromBase64(value), mode: _aesMode);
      try {
        return int.parse(decrypted);
      } catch (e) {
        throw Exception("Value with current key found, but is not subtype of int");
      }
    } else {
      return null;
    }
  }

  double? getDouble(String key) {
    assert(_sharedPreferences != null);
    assert(_key != null,
        "Encryption key must not be null ! To fix it use .setEncryptionKey(key) method");
    String dataKey = _aes.encrypt(_key!, key, mode: _aesMode).base64;
    var value = _sharedPreferences!.getString(dataKey);
    if (value != null) {
      var decrypted = _aes.decrypt(_key!, Encrypted.fromBase64(value), mode: _aesMode);
      try {
        return double.parse(decrypted);
      } catch (e) {
        throw Exception("Value with current key found, but is not subtype of double");
      }
    } else {
      return null;
    }
  }

  bool? getBoolean(String key) {
    assert(_sharedPreferences != null);
    assert(_key != null,
        "Encryption key must not be null ! To fix it use .setEncryptionKey(key) method");
    String dataKey = _aes.encrypt(_key!, key, mode: _aesMode).base64;
    var value = _sharedPreferences!.getString(dataKey);
    if (value != null) {
      var decrypted = _aes.decrypt(_key!, Encrypted.fromBase64(value), mode: _aesMode);
      return decrypted == "true";
    } else {
      return null;
    }
  }
}
