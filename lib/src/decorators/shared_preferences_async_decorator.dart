import 'dart:async';

import 'package:shared_preferences/shared_preferences.dart';

import '../crypto/encryptor.dart';

class SharedPreferencesDecoratorAsync extends SharedPreferencesAsync {
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
  Future<bool> clear({bool notify = true, Set<String>? allowList}) async {
    try {
      final keys = await getKeys();
      await super.clear(allowList: allowList);
      for (var k in keys) {
        _notify(k, notify);
      }
      return true;
    } catch (e) {
      return false;
    }
  }

  @override
  Future<bool> containsKey(String key) =>
      super.containsKey(_encryptor.encrypt(_key, key));

  @override
  Future<bool?> getBool(String key, {bool? defaultValue}) async {
    final value = await super.getString(_encryptor.encrypt(_key, key));
    if (value != null) {
      return _encryptor.decrypt(_key, value) == "true";
    } else {
      return defaultValue;
    }
  }

  @override
  Future<double?> getDouble(String key, {double? defaultValue}) async {
    final value = await super.getString(_encryptor.encrypt(_key, key));
    if (value != null) {
      return double.parse(_encryptor.decrypt(_key, value));
    } else {
      return defaultValue;
    }
  }

  @override
  Future<int?> getInt(String key, {int? defaultValue}) async {
    final value = await super.getString(_encryptor.encrypt(_key, key));
    if (value != null) {
      return int.parse(_encryptor.decrypt(_key, value));
    } else {
      return defaultValue;
    }
  }

  @override
  Future<Set<String>> getKeys({Set<String>? allowList}) async {
    final set = await super.getKeys();
    return set.map((e) => _encryptor.decrypt(_key, e)).toSet();
  }

  @override
  Future<String?> getString(String key, {String? defaultValue}) async {
    final value = await super.getString(_encryptor.encrypt(_key, key));
    if (value != null) {
      return _encryptor.decrypt(_key, value);
    } else {
      return defaultValue;
    }
  }

  @override
  Future<List<String>?> getStringList(String key) async {
    final set = await super.getStringList(_encryptor.encrypt(_key, key));
    return set?.map((e) => _encryptor.decrypt(_key, e)).toList();
  }

  _notify(String key, bool notify) {
    if (notify) listenable.add(key);
  }

  @override
  Future<bool> remove(String key, {bool notify = true}) async {
    try {
      final keys = await getKeys();
      await super.remove(_encryptor.encrypt(_key, key));
      for (var k in keys) {
        _notify(k, notify);
      }
      return true;
    } catch (e) {
      return false;
    }
  }

  Future<bool> removeWhere(
      {bool notify = true, required Function(String key) condition}) async {
    try {
      await Future.forEach(await getKeys(), (key) async {
        if (condition(key)) {
          await super.remove(_encryptor.encrypt(_key, key));
          if (notify) {
            _notify(key, notify);
          }
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
      var encryptedKey = _encryptor.encrypt(_key, key);
      bool isSuccess = false;
      if (value is List<String>) {
        await super.setStringList(encryptedKey,
            value.map((e) => _encryptor.encrypt(_key, e)).toList());
        isSuccess = true;
      } else if (value is String && value.isEmpty) {
        await super.setString(encryptedKey, value);
        isSuccess = true;
      } else {
        await super.setString(
            encryptedKey, _encryptor.encrypt(_key, value.toString()));
        isSuccess = true;
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

  SharedPreferencesDecoratorAsync({
    required IEncryptor encryptor,
    required String key,
  })  : _encryptor = encryptor,
        _key = key;

  Future<void> setMap(Map<String, dynamic> map, {bool notify = true}) async {
    await Future.forEach(map.keys.toList(), (element) async {
      final key = _encryptor.encrypt(_key, element);
      final value = _encryptor.encrypt(_key, map[element]);
      await super.setString(key, value);
    });
    for (var k in map.keys) {
      _notify(k, notify);
    }
  }

  Future<Map<String, dynamic>> getAsMap() async {
    Map<String, dynamic> map = {};
    for (var element in (await super.getKeys())) {
      map[element] = super.getString(element);
    }
    return map;
  }
}
