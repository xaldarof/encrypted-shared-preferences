import 'dart:async';

import 'package:encrypt/encrypt.dart';
import 'package:encrypt_shared_preferences/stream_data.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'encryptor.dart';
import 'listener.dart';

class EncryptedSharedPreferences {
  EncryptedSharedPreferences._();

  String? _key;
  AESMode? _aesMode;

  static late SharedPreferences? _sharedPreferences;
  final List<OnValueChangeListener> _listeners = [];
  bool _canListen = true;
  bool _canListenSingle = true;
  final AESEncryptor _aes = const AESEncryptor();
  final StreamController<StreamData> _streamSingle =
      StreamController.broadcast();
  final StreamController<Map<String, dynamic>> _stream =
      StreamController.broadcast();

  static final EncryptedSharedPreferences _instance =
      EncryptedSharedPreferences._();

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
      String dataKey =
          _aes.decrypt(_key!, Encrypted.fromBase64(e), mode: _aesMode);
      return dataKey;
    }).toSet();
  }

  Future<Map<String, String>> getKeyValues() async {
    assert(_sharedPreferences != null);

    var keyValues = Map<String, String>.fromIterable(key: (v) {
      String dataKey =
          _aes.decrypt(_key!, Encrypted.fromBase64(v), mode: _aesMode);
      return dataKey;
    }, value: (v) {
      String dataValue = _aes.decrypt(
          _key!, Encrypted.fromBase64(_sharedPreferences!.getString(v)!),
          mode: _aesMode);
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

    var oldValue = getString(dataKey);
    var result = await _sharedPreferences!
        .setString(encryptedBase64Key, encryptedBase64Value);
    if (result) _invokeListeners(dataKey, dataValue, oldValue);
    return result;
  }

  Future<bool> setInt(String dataKey, int dataValue) async {
    assert(_sharedPreferences != null);
    assert(_key != null,
        "Encryption key must not be null ! To fix it use .setEncryptionKey(key) method");
    Encrypted encryptedKey = _aes.encrypt(_key!, dataKey, mode: _aesMode);
    String encryptedBase64Key = encryptedKey.base64;
    Encrypted encryptedData =
        _aes.encrypt(_key!, dataValue.toString(), mode: _aesMode);
    String encryptedBase64Value = encryptedData.base64;

    var oldValue = getInt(dataKey);
    var result = await _sharedPreferences!
        .setString(encryptedBase64Key, encryptedBase64Value);
    if (result) _invokeListeners(dataKey, dataValue, oldValue);

    return result;
  }

  Future<bool> setDouble(String dataKey, double dataValue) async {
    assert(_sharedPreferences != null);
    assert(_key != null,
        "Encryption key must not be null ! To fix it use .setEncryptionKey(key) method");
    Encrypted encryptedKey = _aes.encrypt(_key!, dataKey, mode: _aesMode);
    String encryptedBase64Key = encryptedKey.base64;
    Encrypted encryptedData =
        _aes.encrypt(_key!, dataValue.toString(), mode: _aesMode);
    String encryptedBase64Value = encryptedData.base64;

    var oldValue = getDouble(dataKey);
    var result = await _sharedPreferences!
        .setString(encryptedBase64Key, encryptedBase64Value);
    if (result) _invokeListeners(dataKey, dataValue, oldValue);

    return result;
  }

  Future<bool> setBoolean(String dataKey, bool dataValue) async {
    assert(_sharedPreferences != null);
    assert(_key != null,
        "Encryption key must not be null ! To fix it use .setEncryptionKey(key) method");
    Encrypted encryptedKey = _aes.encrypt(_key!, dataKey, mode: _aesMode);
    String encryptedBase64Key = encryptedKey.base64;
    Encrypted encryptedData =
        _aes.encrypt(_key!, dataValue.toString(), mode: _aesMode);
    String encryptedBase64Value = encryptedData.base64;

    var oldValue = getBoolean(dataKey);
    var result = await _sharedPreferences!
        .setString(encryptedBase64Key, encryptedBase64Value);
    if (result) _invokeListeners(dataKey, dataValue, oldValue);

    return result;
  }

  String? getString(String key, {String? defaultValue}) {
    assert(_sharedPreferences != null);
    assert(_key != null,
        "Encryption key must not be null ! To fix it use .setEncryptionKey(key) method");
    String dataKey = _aes.encrypt(_key!, key, mode: _aesMode).base64;
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
    String dataKey = _aes.encrypt(_key!, key, mode: _aesMode).base64;
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
    String dataKey = _aes.encrypt(_key!, key, mode: _aesMode).base64;
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
    String dataKey = _aes.encrypt(_key!, key, mode: _aesMode).base64;
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
    if(_canListen) {
      _stream.add(await getKeyValues());
    }
    if(_canListenSingle) {
      _streamSingle.add(StreamData(key: key, value: value, oldValue: oldValue));
    }
    for (var element in _listeners) {
      element.call(key, value, oldValue);
    }
  }

  void addListener(OnValueChangeListener listener) {
    _listeners.add(listener);
  }

  void removeListener(OnValueChangeListener listener) {
    _listeners.remove(listener);
  }

  void removeAllListeners() {
    _listeners.clear();
  }

  void setCanStreamListen(bool canListen) {
    _canListen = canListen;
  }

  void setCanListenSingle(bool canListen) {
    _canListenSingle = canListen;
  }

  int get listeners => _listeners.length;

  Stream<StreamData> get listenableSingle => _streamSingle.stream;

  Stream<Map<String, dynamic>> get listenable => _stream.stream;
}
