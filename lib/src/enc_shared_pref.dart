import 'dart:async';
import 'package:encrypt_shared_preferences/src/crypto/aes.dart';
import 'package:encrypt_shared_preferences/src/crypto/salsa20.dart';
import 'package:encrypt_shared_preferences/src/shared_preferences_decorator.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'crypto/encryptor.dart';

class EncryptedSharedPreferences {
  EncryptedSharedPreferences._();

  static String? _key;

  static late SharedPreferencesDecorator _decorator;
  static late Encryptor _encryptor;

  static final EncryptedSharedPreferences _instance =
      EncryptedSharedPreferences._();

  static EncryptedSharedPreferences getInstance() {
    assert(_key != null);
    return _instance;
  }

  Stream<String> get stream => _decorator.listenable.stream;

  static Future<void> initialize(String key,
      {EncryptionAlgorithm? algorithm = EncryptionAlgorithm.aes}) async {
    _key = key;
    if (algorithm == EncryptionAlgorithm.salsa20) {
      _encryptor = Salsa20Encryptor();
    }
    if (algorithm == EncryptionAlgorithm.aes) {
      _encryptor = AESEncryptor();
    }

    _decorator = SharedPreferencesDecorator(
        preferences: await SharedPreferences.getInstance(),
        encryptor: _encryptor,
        key: _key!);
  }

  Future<bool> clear({bool notify = true}) async {
    assert(_key != null);
    return _decorator.clear(notify: notify);
  }

  Future<bool> remove(String key, {bool notify = true}) async {
    assert(_key != null);
    _decorator.remove(key, notify: notify);
    return true;
  }

  Future<Set<String>> getKeys() async {
    assert(_key != null);
    return _decorator.getKeys();
  }

  dynamic get(String key) {
    assert(_key != null);
    return _decorator.get(key);
  }

  Future<bool> setString(String dataKey, String? dataValue,
      {bool notify = true}) async {
    assert(_key != null);
    return _decorator.setString(dataKey, dataValue, notify: notify);
  }

  Future<bool> setInt(String dataKey, int? dataValue,
      {bool notify = true}) async {
    assert(_key != null);
    return _decorator.setInt(dataKey, dataValue, notify: notify);
  }

  Future<bool> setDouble(String dataKey, double? dataValue,
      {bool notify = true}) async {
    assert(_key != null);
    return _decorator.setDouble(dataKey, dataValue, notify: notify);
  }

  Future<bool> setBoolean(String dataKey, bool? dataValue,
      {bool notify = true}) async {
    assert(_key != null);
    return _decorator.setBool(dataKey, dataValue, notify: notify);
  }

  String? getString(String key) {
    assert(_key != null);
    return _decorator.getString(key);
  }

  int? getInt(String key) {
    assert(_key != null);
    return _decorator.getInt(key);
  }

  double? getDouble(String key) {
    assert(_key != null);
    return _decorator.getDouble(key);
  }

  bool? getBoolean(String key) {
    assert(_key != null);
    return _decorator.getBool(key);
  }

  Future<void> reload() {
    assert(_key != null);
    return _decorator.reload();
  }

  @Deprecated('Use the observe() instead.')
  Stream<String> listen({String? key}) {
    assert(_key != null);
    return _decorator.listen(key: key);
  }

  Stream<String> observe({String? key}) {
    assert(_key != null);
    return _decorator.listen(key: key);
  }

  @Deprecated('Use the observeSet() instead.')
  Stream<String> listenSet({required Set<String> keys}) {
    assert(_key != null);
    return _decorator.listenSet(keys: keys);
  }

  Stream<String> observeSet({required Set<String> keys}) {
    assert(_key != null);
    return _decorator.listenSet(keys: keys);
  }
}
