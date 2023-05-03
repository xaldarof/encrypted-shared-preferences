import 'dart:async';
import 'package:encrypt_shared_preferences/src/shared_preferences_decorator.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'encryptor.dart';

class EncryptedSharedPreferences {
  EncryptedSharedPreferences._();

  static String? _key;

  static late SharedPreferencesDecorator _decorator;
  static const AESEncryptor _aes = AESEncryptor();

  static final EncryptedSharedPreferences _instance =
      EncryptedSharedPreferences._();

  static EncryptedSharedPreferences getInstance() {
    assert(_key != null);
    return _instance;
  }

  Stream<String> get stream => _decorator.listenable.stream;

  static Future<void> initialize(String key) async {
    _key = key;
    _decorator = SharedPreferencesDecorator(
        preferences: await SharedPreferences.getInstance(),
        encryptor: _aes,
        key: _key!);
  }

  Future<bool> clear() async {
    assert(_key != null);
    return _decorator.clear();
  }

  Future<bool> remove(String key) async {
    assert(_key != null);
    _decorator.remove(key);
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

  Future<bool> setString(String dataKey, String? dataValue) async {
    assert(_key != null);
    return _decorator.setString(dataKey, dataValue);
  }

  Future<bool> setInt(String dataKey, int? dataValue) async {
    assert(_key != null);
    return _decorator.setInt(dataKey, dataValue);
  }

  Future<bool> setDouble(String dataKey, double? dataValue) async {
    assert(_key != null);
    return _decorator.setDouble(dataKey, dataValue);
  }

  Future<bool> setBoolean(String dataKey, bool? dataValue) async {
    assert(_key != null);
    return _decorator.setBool(dataKey, dataValue);
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

  Stream<String> listen({String? key}) {
    assert(_key != null);
    return _decorator.listen(key: key);
  }
}
