import 'dart:async';

import 'package:encrypt_shared_preferences/src/batch.dart';
import 'package:flutter/foundation.dart';
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
      await clear(notify: notify, allowList: allowList);
      _notify('', notify);
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
      await super.remove(_encryptor.encrypt(_key, key));
      _notify(key, notify);
      return true;
    } catch (e) {
      return false;
    }
  }

  Future<bool> removeWhere(
      {bool notify = true,
      bool notifyEach = false,
      required Function(String key) condition}) async {
    try {
      await Future.forEach(await getKeys(), (key) async {
        if (condition(key)) {
          await super.remove(_encryptor.encrypt(_key, key));
          if (notifyEach) {
            _notify(key, true);
          }
        }
      });
      _notify('', notify);
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
    try {
      if (value != null) {
        var enKey = _encryptor.encrypt(_key, key);
        if (value == "") {
          await super.setString(enKey, value);
          return true;
        }
        await super
            .setString(enKey, _encryptor.encrypt(_key, value.toString()));
        _notify(key, notify);
        return true;
      } else {
        return remove(key);
      }
    } catch (e) {
      return false;
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

  notifyObservers() {
    _notify('', true);
  }

  Future<void> setMap(Map<String, dynamic> map, {bool notify = true}) async {
    await Future.forEach(map.keys.toList(), (element) async {
      final key = _encryptor.encrypt(_key, element);
      final value = _encryptor.encrypt(_key, map[element]);
      await super.setString(key, value);
    });
    _notify('', notify);
  }

  Future<void> batch(Future<bool> Function(BatchSharedPreferences batch) invoke,
      {bool notify = true}) async {
    final Map<String, dynamic> map = {};
    final keys = await super.getKeys();
    for (var element in keys) {
      final value = _encryptor.decrypt(_key, (await super.getString(element))!);
      map[_encryptor.decrypt(_key, element)] = value;
    }

    BatchSharedPreferences batchSharedPreferences =
        BatchSharedPreferences(batch: map);
    if (await invoke(batchSharedPreferences) == true) {
      await setMap(batchSharedPreferences.batch, notify: notify);
    } else {
      if (kDebugMode) print('Batch return false');
    }
  }
}
