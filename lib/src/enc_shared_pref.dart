import 'dart:async';
import 'package:encrypt_shared_preferences/src/crypto/aes.dart';
import 'package:encrypt_shared_preferences/src/crypto/encryptor.dart';
import 'package:encrypt_shared_preferences/src/decorators/shared_preferences_decorator.dart';
import 'package:shared_preferences/shared_preferences.dart';

class EncryptedSharedPreferences {
  EncryptedSharedPreferences._();

  static String? _key;

  static late SharedPreferencesDecorator _decorator;

  static final EncryptedSharedPreferences _instance =
      EncryptedSharedPreferences._();

  static EncryptedSharedPreferences getInstance() {
    assert(_key != null);
    return _instance;
  }

  /// Stream that emits a new value whenever the SharedPreferences data changes.
  Stream<String> get stream => _decorator.listenable.stream;

  /// Initialize the EncryptedSharedPreferences with the provided encryption key.
  static Future<void> initialize(String key, {IEncryptor? encryptor}) async {
    _key = key;
    _decorator = SharedPreferencesDecorator(
      encryptor: encryptor ?? AESEncryptor(),
      key: _key!,
      preferences: await SharedPreferences.getInstance(),
    );
  }

  /// Clear all key-valure pairs from SharedPreferences.
  Future<bool> clear({bool notify = true}) async {
    assert(_key != null);
    return _decorator.clear(notify: notify);
  }

  /// Remove by checking condition.
  Future<bool> removeWhere(
      {bool notify = true,
      required Function(String key, String value) condition}) async {
    assert(_key != null);
    return _decorator.removeWhere(condition: condition, notify: notify);
  }

  /// Remove the value associated with the specified key from SharedPreferences.
  Future<bool> remove(String key, {bool notify = true}) async {
    assert(_key != null);
    _decorator.remove(key, notify: notify);
    return true;
  }

  /// Get the set of all keys stored in SharedPreferences.
  Set<String> getKeys() {
    assert(_key != null);
    return _decorator.getKeys();
  }

  /// Get the string value associated with the specified key.
  String? get(String key, {String? defaultValue}) {
    assert(_key != null);
    return _decorator.get(key, defaultValue: defaultValue);
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

  /// Set the boolean value for the specified key in SharedPreferences.
  /// Added for better integration with SharedPreferences
  Future<bool> setBool(String dataKey, bool? dataValue,
      {bool notify = true}) async {
    assert(_key != null);
    return _decorator.setBool(dataKey, dataValue, notify: notify);
  }

  /// Set the List<String> value for the specified key in SharedPreferences.
  Future<bool> setStringList(String dataKey, List<String>? dataValue,
      {bool notify = true}) async {
    assert(_key != null);
    return _decorator.setStringList(dataKey, dataValue, notify: notify);
  }

  /// Get the List<String> value for the specified key in SharedPreferences.
  List<String>? getStringList(String key, {String? defaultValue}) {
    assert(_key != null);
    return _decorator.getStringList(key);
  }

  /// Get the string value associated with the specified key.
  String? getString(String key, {String? defaultValue}) {
    assert(_key != null);
    return _decorator.getString(key, defaultValue: defaultValue);
  }

  /// Get the integer value associated with the specified key.
  int? getInt(String key, {int? defaultValue}) {
    assert(_key != null);
    return _decorator.getInt(key, defaultValue: defaultValue);
  }

  /// Get the double value associated with the specified key.
  double? getDouble(String key, {double? defaultValue}) {
    assert(_key != null);
    return _decorator.getDouble(key, defaultValue: defaultValue);
  }

  /// Get the boolean value associated with the specified key.
  bool? getBoolean(String key, {bool? defaultValue}) {
    assert(_key != null);
    return _decorator.getBool(key, defaultValue: defaultValue);
  }

  /// Get the boolean value associated with the specified key.
  /// Added for better integration with SharedPreferences
  bool? getBool(String key, {bool? defaultValue}) {
    assert(_key != null);
    return _decorator.getBool(key, defaultValue: defaultValue);
  }

  /// Reload SharedPreferences data from disk.
  Future<void> reload() {
    assert(_key != null);
    return _decorator.reload();
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

  ///Save map
  Future<void> setMap(Map<String, dynamic> map, {bool notify = true}) =>
      _decorator.setMap(map);
}
