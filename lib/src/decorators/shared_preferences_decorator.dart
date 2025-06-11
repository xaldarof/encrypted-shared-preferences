import 'dart:async';

import 'package:flutter/cupertino.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../crypto/encryptor.dart';

class SharedPreferencesDecorator implements SharedPreferences {
  final SharedPreferences _preferences;
  final IEncryptor _encryptor;
  final String _key;
  final StreamController<String> listenable =
      StreamController<String>.broadcast();

  Stream<String> listen({String? key}) async* {
    await for (final event in listenable.stream) {
      if (key != null) {
        if (event == key) {
          yield event;
        }
      } else {
        yield event;
      }
    }
  }

  Stream<String> listenSet({required Set<String> keys}) async* {
    assert(keys.isNotEmpty);
    await for (final event in listenable.stream) {
      if (keys.contains(event)) {
        yield event;
      }
    }
  }

  @override
  Future<bool> clear({bool notify = true}) {
    final Set<String> keys = getKeys();
    final cleared = _preferences.clear();
    for (var k in keys) {
      _notify(k, notify);
    }
    return cleared;
  }

  @Deprecated("This method is now a no-op, and should no longer be called.")
  @override
  Future<bool> commit() => Future.value(true);

  @override
  bool containsKey(String key) =>
      _preferences.containsKey(_encryptor.encrypt(_key, key));

  @override
  String? get(String key, {String? defaultValue}) {
    final cacheValue = _preferences.get(_encryptor.encrypt(_key, key));
    if (cacheValue == null) return defaultValue;
    final value = _encryptor.decrypt(_key, cacheValue.toString());
    return value;
  }

  @override
  bool? getBool(String key, {bool? defaultValue}) {
    final value = _preferences.getString(_encryptor.encrypt(_key, key));
    if (value != null) {
      return _encryptor.decrypt(_key, value) == "true";
    } else {
      return defaultValue;
    }
  }

  @override
  double? getDouble(String key, {double? defaultValue}) {
    final value = _preferences.getString(_encryptor.encrypt(_key, key));
    if (value != null) {
      return double.parse(_encryptor.decrypt(_key, value));
    } else {
      return defaultValue;
    }
  }

  @override
  int? getInt(String key, {int? defaultValue}) {
    final value = _preferences.getString(_encryptor.encrypt(_key, key));
    if (value != null) {
      return int.parse(_encryptor.decrypt(_key, value));
    } else {
      return defaultValue;
    }
  }

  @override
  Set<String> getKeys() {
    final set = _preferences.getKeys();
    return set.map((e) => _encryptor.decrypt(_key, e)).toSet();
  }

  @override
  String? getString(String key, {String? defaultValue}) {
    final value = _preferences.getString(_encryptor.encrypt(_key, key));
    if (value != null) {
      return _encryptor.decrypt(_key, value);
    } else {
      return defaultValue;
    }
  }

  @override
  List<String>? getStringList(String key, {List<String>? defaultValue}) {
    final set = _preferences.getStringList(_encryptor.encrypt(_key, key));
    if (set != null) {
      return set.map((e) {
        return _encryptor.decrypt(_key, e);
      }).toList();
    }
    return defaultValue;
  }

  @override
  Future<void> reload() => _preferences.reload();

  Map<String, dynamic> getAsMap() {
    Map<String, dynamic> map = {};
    getKeys().forEach((element) {
      map[element] = _preferences.getString(element);
    });
    return map;
  }

  _notify(String key, bool notify) {
    if (notify) listenable.add(key);
  }

  @override
  Future<bool> remove(String key, {bool notify = true}) {
    _notify(key, notify);
    return _preferences.remove(_encryptor.encrypt(_key, key));
  }

  Future<bool> removeWhere(
      {bool notify = true,
      required Function(String key, String value) condition}) async {
    try {
      await Future.forEach(getKeys(), (key) async {
        try {
          if (condition(key, get(key)!)) {
            await _preferences.remove(_encryptor.encrypt(_key, key));
            _notify(key, notify);
          }
        } catch (e) {
          debugPrint(e.toString());
        }
      });
      return true;
    } catch (e) {
      return false;
    }
  }

  @override
  Future<bool> setBool(String key, bool? value, {bool notify = true}) {
    return save(key, value, notify: notify);
  }

  @override
  Future<bool> setDouble(String key, double? value, {bool notify = true}) {
    return save(key, value, notify: notify);
  }

  @override
  Future<bool> setInt(String key, int? value, {bool notify = true}) {
    return save(key, value, notify: notify);
  }

  @override
  Future<bool> setString(String key, String? value, {bool notify = true}) {
    return save(key, value, notify: notify);
  }

  Future<bool> save(String key, dynamic value, {required bool notify}) async {
    if (value != null) {
      bool isSuccess = false;
      var encryptedKey = _encryptor.encrypt(_key, key);
      if (value is List<String>) {
        isSuccess = await _preferences.setStringList(encryptedKey,
            value.map((e) => _encryptor.encrypt(_key, e)).toList());
      } else if (value is String && value.isEmpty) {
        isSuccess = await _preferences.setString(encryptedKey, value);
      } else {
        isSuccess = await _preferences.setString(
            encryptedKey, _encryptor.encrypt(_key, value.toString()));
      }
      _notify(key, notify);
      return isSuccess;
    } else {
      final isSuccess = await remove(key);
      _notify(key, notify);
      return isSuccess;
    }
  }

  @override
  Future<bool> setStringList(String key, List<String>? value,
      {bool notify = true}) {
    return save(key, value, notify: notify);
  }

  SharedPreferencesDecorator({
    required SharedPreferences preferences,
    required IEncryptor encryptor,
    required String key,
  })  : _preferences = preferences,
        _encryptor = encryptor,
        _key = key;

  Future<void> setMap(Map<String, dynamic> map, {bool notify = true}) async {
    await Future.forEach(map.keys.toList(), (element) async {
      final key = _encryptor.encrypt(_key, element);
      final value = _encryptor.encrypt(_key, map[element]);
      await _preferences.setString(key, value);
    });
    for (var k in map.keys) {
      _notify(k, notify);
    }
  }
}
