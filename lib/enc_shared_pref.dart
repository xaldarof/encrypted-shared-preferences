import 'dart:async';
import 'package:encrypt/encrypt.dart';
import 'package:encrypt_shared_preferences/stream_data.dart';
import 'package:encrypt_shared_preferences/strings.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'encryptor.dart';
import 'listener.dart';

class EncryptedSharedPreferences {
  EncryptedSharedPreferences._();

  String? _key;
  AESMode? _aesMode;

  static late SharedPreferences? _sharedPreferences;
  final List<OnValueChangeListener> _listeners = [];
  final AESEncryptor _aes = const AESEncryptor();
  final StreamController<StreamData> _streamSingle =
      StreamController.broadcast();
  final StreamController<Map<String, dynamic>> _stream =
      StreamController.broadcast();

  static final EncryptedSharedPreferences _instance =
      EncryptedSharedPreferences._();

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
    final cleared = await _sharedPreferences!.clear();
    _invokeListeners('', null, null);
    return cleared;
  }

  Future<bool> remove(String key) async {
    assert(_sharedPreferences != null);
    String dataKey = _aes.encrypt(_key!, key.enc, mode: _aesMode).base64;
    final removed = await _sharedPreferences!.remove(dataKey);
    _invokeListeners(key.enc, null, null);
    return removed;
  }

  Future<Set<String>> getKeys() async {
    assert(_sharedPreferences != null);
    return _sharedPreferences!.getKeys().map((e) {
      String dataKey =
          _aes.decrypt(_key!, Encrypted.fromBase64(e), mode: _aesMode);
      return dataKey.replaceFirst(identifier, "");
    }).toSet();
  }

  Future<Map<String, String>> getKeyValues() async {
    assert(_sharedPreferences != null);

    var keyValues = <String, String>{};
    if (_sharedPreferences!.getKeys().isNotEmpty) {
      keyValues = Map<String, String>.fromIterable(key: (v) {
        if (v.toString().startsWith(identifier)) {
          String dataKey =
              _aes.decrypt(_key!, Encrypted.fromBase64(v), mode: _aesMode);
          return dataKey;
        } else {
          return v;
        }
      }, value: (v) {
        if (v.toString().startsWith(identifier)) {
          String dataValue = _aes.decrypt(
              _key!, Encrypted.fromBase64(_sharedPreferences!.getString(v)!),
              mode: _aesMode);
          return dataValue;
        } else {
          return v;
        }
      }, _sharedPreferences!.getKeys());
    }
    return keyValues;
  }

  Future<bool> setString(String dataKey, String? dataValue) async {
    assert(_sharedPreferences != null);
    assert(_key != null,
        "Encryption key must not be null ! To fix it use .setEncryptionKey(key) method");
    Encrypted encryptedKey = _aes.encrypt(_key!, dataKey.enc, mode: _aesMode);
    String encryptedBase64Key = encryptedKey.base64;

    if (dataValue?.isEmpty == true && dataValue != null) {
      Encrypted encryptedData = _aes.encrypt(_key!, dataValue, mode: _aesMode);
      String encryptedBase64Value = encryptedData.base64;

      var oldValue = getString(dataKey.enc);
      var result = await _sharedPreferences!
          .setString(encryptedBase64Key, encryptedBase64Value);
      if (result) _invokeListeners(dataKey.enc, dataValue, oldValue);
      return result;
    } else {
      await _sharedPreferences?.remove(dataKey);
    }
    return true;
  }

  Future<bool> setInt(String dataKey, int? dataValue) async {
    assert(_sharedPreferences != null);
    assert(_key != null,
        "Encryption key must not be null ! To fix it use .setEncryptionKey(key) method");
    Encrypted encryptedKey = _aes.encrypt(_key!, dataKey.enc, mode: _aesMode);
    String encryptedBase64Key = encryptedKey.base64;
    if (dataValue != null) {
      Encrypted encryptedData =
          _aes.encrypt(_key!, dataValue.toString(), mode: _aesMode);
      String encryptedBase64Value = encryptedData.base64;

      var oldValue = getInt(dataKey.enc);
      var result = await _sharedPreferences!
          .setString(encryptedBase64Key, encryptedBase64Value);
      if (result) _invokeListeners(dataKey.enc, dataValue, oldValue);
      return result;
    } else {
      await _sharedPreferences?.remove(dataKey);
    }
    return true;
  }

  Future<bool> setDouble(String dataKey, double? dataValue) async {
    assert(_sharedPreferences != null);
    assert(_key != null,
        "Encryption key must not be null ! To fix it use .setEncryptionKey(key) method");
    Encrypted encryptedKey = _aes.encrypt(_key!, dataKey.enc, mode: _aesMode);
    String encryptedBase64Key = encryptedKey.base64;
    if (dataValue != null) {
      Encrypted encryptedData =
          _aes.encrypt(_key!, dataValue.toString(), mode: _aesMode);
      String encryptedBase64Value = encryptedData.base64;

      var oldValue = getDouble(dataKey.enc);
      var result = await _sharedPreferences!
          .setString(encryptedBase64Key, encryptedBase64Value);
      if (result) _invokeListeners(dataKey.enc, dataValue, oldValue);

      return result;
    } else {
      await _sharedPreferences?.remove(dataKey);
      return true;
    }
    return true;
  }

  Future<bool> setBoolean(String dataKey, bool? dataValue) async {
    assert(_sharedPreferences != null);
    assert(_key != null,
        "Encryption key must not be null ! To fix it use .setEncryptionKey(key) method");
    Encrypted encryptedKey = _aes.encrypt(_key!, dataKey.enc, mode: _aesMode);
    String encryptedBase64Key = encryptedKey.base64;
    if (dataValue != null) {
      Encrypted encryptedData =
          _aes.encrypt(_key!, dataValue.toString(), mode: _aesMode);
      String encryptedBase64Value = encryptedData.base64;

      var oldValue = getBoolean(dataKey.enc);
      var result = await _sharedPreferences!
          .setString(encryptedBase64Key, encryptedBase64Value);
      if (result) _invokeListeners(dataKey.enc, dataValue, oldValue);

      return result;
    } else {
      await _sharedPreferences?.remove(dataKey);
    }
    return true;
  }

  String? getString(String key, {String? defaultValue}) {
    assert(_sharedPreferences != null);
    assert(_key != null,
        "Encryption key must not be null ! To fix it use .setEncryptionKey(key) method");
    String dataKey = _aes.encrypt(_key!, key.enc, mode: _aesMode).base64;
    var value = _sharedPreferences!.getString(dataKey);
    if (value != null) {
      var decrypted =
          _aes.decrypt(_key!, Encrypted.fromBase64(value), mode: _aesMode);
      return decrypted;
    } else {
      return defaultValue;
    }
  }

  int? getInt(String key, {int? defaultValue}) {
    assert(_sharedPreferences != null);
    assert(_key != null,
        "Encryption key must not be null ! To fix it use .setEncryptionKey(key) method");
    String dataKey = _aes.encrypt(_key!, key.enc, mode: _aesMode).base64;
    var value = _sharedPreferences!.getString(dataKey);
    if (value != null) {
      var decrypted =
          _aes.decrypt(_key!, Encrypted.fromBase64(value), mode: _aesMode);
      try {
        return int.parse(decrypted);
      } catch (e) {
        throw Exception(
            "Value with current key found, but is not subtype of int");
      }
    } else {
      return defaultValue;
    }
  }

  double? getDouble(String key, {double? defaultValue}) {
    assert(_sharedPreferences != null);
    assert(_key != null,
        "Encryption key must not be null ! To fix it use .setEncryptionKey(key) method");
    String dataKey = _aes.encrypt(_key!, key.enc, mode: _aesMode).base64;
    var value = _sharedPreferences!.getString(dataKey);
    if (value != null) {
      var decrypted =
          _aes.decrypt(_key!, Encrypted.fromBase64(value), mode: _aesMode);
      try {
        return double.parse(decrypted);
      } catch (e) {
        throw Exception(
            "Value with current key found, but is not subtype of double");
      }
    } else {
      return defaultValue;
    }
  }

  bool? getBoolean(String key, {bool? defaultValue}) {
    assert(_sharedPreferences != null);
    assert(_key != null,
        "Encryption key must not be null ! To fix it use .setEncryptionKey(key) method");
    String dataKey = _aes.encrypt(_key!, key.enc, mode: _aesMode).base64;
    var value = _sharedPreferences!.getString(dataKey);
    if (value != null) {
      var decrypted =
          _aes.decrypt(_key!, Encrypted.fromBase64(value), mode: _aesMode);
      return decrypted == "true";
    } else {
      return defaultValue;
    }
  }

  _invokeListeners(String key, dynamic value, dynamic oldValue) async {
    _stream.add(await getKeyValues());
    _streamSingle.add(StreamData(key: key, value: value, oldValue: oldValue));
    for (var element in _listeners) {
      element.call(key.replaceFirst(identifier, ""), value, oldValue);
    }
  }

  void addListener(OnValueChangeListener listener) {
    _listeners.add(listener);
  }

  Stream<StreamData> listenKey(String key) async* {
    await for (final event in listenableSingle) {
      if (event.key == key.enc) {
        yield StreamData(
            key: key, value: event.value, oldValue: event.oldValue);
      }
    }
  }

  void removeListener(OnValueChangeListener listener) {
    _listeners.remove(listener);
  }

  void removeAllListeners() {
    _listeners.clear();
  }

  int get listeners => _listeners.length;

  Stream<StreamData> get listenableSingle => _streamSingle.stream;

  Stream<Map<String, dynamic>> get listenable => _stream.stream;
}
