import 'dart:async';
import 'package:encrypt_shared_preferences/src/batch.dart';
import 'package:encrypt_shared_preferences/src/crypto/aes.dart';
import 'package:encrypt_shared_preferences/src/crypto/encryptor.dart';
import 'package:encrypt_shared_preferences/src/decorators/shared_preferences_async_decorator.dart';

class EncryptedSharedPreferencesAsync {
  EncryptedSharedPreferencesAsync._();

  static String? _key;

  static late SharedPreferencesDecoratorAsync _decorator;

  static final EncryptedSharedPreferencesAsync _instance =
      EncryptedSharedPreferencesAsync._();

  static EncryptedSharedPreferencesAsync getInstance() {
    assert(_key != null);
    return _instance;
  }

  /// Stream that emits a new value whenever the SharedPreferences data changes.
  Stream<String> get stream => _decorator.listenable.stream;

  /// Initialize the EncryptedSharedPreferences with the provided encryption key.
  static Future<void> initialize(String key, {IEncryptor? encryptor}) async {
    _key = key;
    _decorator = SharedPreferencesDecoratorAsync(
        encryptor: encryptor ?? AESEncryptor(), key: _key!);
  }

  /// Clear all key-valure pairs from SharedPreferences.
  Future<bool> clear({bool notify = true, Set<String>? allowList}) async {
    assert(_key != null);
    return _decorator.clear(notify: notify, allowList: allowList);
  }

  /// Remove by checking condition.
  Future<bool> removeWhere(
      {bool notify = true,
      bool notifyEach = false,
      required Function(String key) condition}) async {
    assert(_key != null);
    return _decorator.removeWhere(
        condition: condition, notify: notify, notifyEach: notifyEach);
  }

  /// Remove the value associated with the specified key from SharedPreferences.
  Future<bool> remove(String key, {bool notify = true}) async {
    assert(_key != null);
    _decorator.remove(key, notify: notify);
    return true;
  }

  /// Get the set of all keys stored in SharedPreferences.
  Future<Set<String>> getKeys({Set<String>? allowList}) async {
    assert(_key != null);
    return _decorator.getKeys(allowList: allowList);
  }

  /// Set the string value for the specified key in SharedPreferences.
  Future<bool> setString(String dataKey, String? dataValue,
      {bool notify = true}) async {
    assert(_key != null);
    return _decorator.setString(dataKey, dataValue, notify: notify);
  }

  /// Set the integer value for the specified key in SharedPreferences.
  Future<bool> setInt(String dataKey, int? dataValue,
      {bool notify = true}) async {
    assert(_key != null);
    return _decorator.setInt(dataKey, dataValue, notify: notify);
  }

  /// Set the double value for the specified key in SharedPreferences.
  Future<bool> setDouble(String dataKey, double? dataValue,
      {bool notify = true}) async {
    assert(_key != null);
    return _decorator.setDouble(dataKey, dataValue, notify: notify);
  }

  /// Set the boolean value for the specified key in SharedPreferences.
  Future<bool> setBoolean(String dataKey, bool? dataValue,
      {bool notify = true}) async {
    assert(_key != null);
    return _decorator.setBool(dataKey, dataValue, notify: notify);
  }

  /// Get the string value associated with the specified key.
  Future<String?> getString(String key, {String? defaultValue}) {
    assert(_key != null);
    return _decorator.getString(key, defaultValue: defaultValue);
  }

  /// Get the integer value associated with the specified key.
  Future<int?> getInt(String key, {int? defaultValue}) {
    assert(_key != null);
    return _decorator.getInt(key, defaultValue: defaultValue);
  }

  /// Get the double value associated with the specified key.
  Future<double?> getDouble(String key, {double? defaultValue}) {
    assert(_key != null);
    return _decorator.getDouble(key, defaultValue: defaultValue);
  }

  /// Get the boolean value associated with the specified key.
  Future<bool?> getBoolean(String key, {bool? defaultValue}) {
    assert(_key != null);
    return _decorator.getBool(key, defaultValue: defaultValue);
  }

  /// Observe changes to the value associated with the specified key in SharedPreferences.
  Stream<String> observe({String? key}) {
    assert(_key != null);
    return _decorator.listen(key: key);
  }

  /// Observe changes to the values associated with the specified set of keys in SharedPreferences.
  Stream<String> observeSet({required Set<String> keys}) {
    assert(_key != null);
    return _decorator.listenSet(keys: keys);
  }

  /// @deprecated Use the observe() instead.
  @Deprecated('Use the observe() instead.')
  Stream<String> listen({String? key}) {
    assert(_key != null);
    return _decorator.listen(key: key);
  }

  /// @deprecated Use the observeSet() instead.
  @Deprecated('Use the observeSet() instead.')
  Stream<String> listenSet({required Set<String> keys}) {
    assert(_key != null);
    return _decorator.listenSet(keys: keys);
  }

  /// Notify listeners
  Stream<String> notifyObservers() {
    assert(_key != null);
    return _decorator.notifyObservers();
  }

  ///Save map
  Future<void> setMap(Map<String, dynamic> map, {bool notify = true}) =>
      _decorator.setMap(map);
}
