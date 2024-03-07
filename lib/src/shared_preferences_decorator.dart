import 'dart:async';

import 'package:encrypt/encrypt.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'crypto/encryptor.dart';

class SharedPreferencesDecorator implements SharedPreferences {
  final SharedPreferences _preferences;
  final Encryptor _encryptor;
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
    final cleared = _preferences.clear();
    _notify('', notify);
    return cleared;
  }

  @override
  Future<bool> commit() => _preferences.commit();

  @override
  bool containsKey(String key) =>
      _preferences.containsKey(_encryptor.encrypt(_key, key).base64);

  @override
  Object? get(String key) {
    final value = _preferences.getString(_encryptor.encrypt(_key, key).base64);
    if (value != null) {
      String type = value.substring(0, 1);

      if (type == "s") {
        return getString(key);
      } else if (type == "b") {
        return getBool(key);
      } else if (type == "i") {
        return getInt(key);
      } else if (type == "d") {
        return getDouble(key);
      } else {
        return getStringList(key);
      }
    } else {
      return null;
    }
  }

  @override
  bool? getBool(String key) {
    final value = _preferences.getString(_encryptor.encrypt(_key, key).base64);
    if (value != null) {
      return _encryptor.decrypt(
              _key, Encrypted.fromBase64(value.substring(1))) ==
          "true";
    } else {
      return null;
    }
  }

  @override
  double? getDouble(String key) {
    final value = _preferences.getString(_encryptor.encrypt(_key, key).base64);
    if (value != null) {
      return double.parse(
          _encryptor.decrypt(_key, Encrypted.fromBase64(value.substring(1))));
    } else {
      return null;
    }
  }

  @override
  int? getInt(String key) {
    final value = _preferences.getString(_encryptor.encrypt(_key, key).base64);
    if (value != null) {
      return int.parse(
          _encryptor.decrypt(_key, Encrypted.fromBase64(value.substring(1))));
    } else {
      return null;
    }
  }

  @override
  Set<String> getKeys() {
    final set = _preferences.getKeys();
    return set
        .map((e) => _encryptor.decrypt(_key, Encrypted.fromBase64(e)))
        .toSet();
  }

  @override
  String? getString(String key) {
    final value = _preferences.getString(_encryptor.encrypt(_key, key).base64);
    if (value != null) {
      if (value == "") {
        return "";
      }
      return _encryptor.decrypt(_key, Encrypted.fromBase64(value.substring(1)));
    } else {
      return null;
    }
  }

  @override
  List<String>? getStringList(String key) {
    final set =
        _preferences.getStringList(_encryptor.encrypt(_key, key).base64);
    return set
        ?.map((e) => _encryptor.decrypt(_key, Encrypted.fromBase64(e)))
        .toList();
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

  _notify(String value, bool notify) {
    if (notify) listenable.add(value);
  }

  @override
  Future<bool> remove(String key, {bool notify = true}) {
    _notify(key, notify);
    return _preferences.remove(_encryptor.encrypt(_key, key).base64);
  }

  @override
  Future<bool> setBool(String key, bool? value, {bool notify = true}) {
    return save(key, "b", value, notify: notify);
  }

  @override
  Future<bool> setDouble(String key, double? value, {bool notify = true}) {
    return save(key, "d", value, notify: notify);
  }

  @override
  Future<bool> setInt(String key, int? value, {bool notify = true}) {
    return save(key, "i", value, notify: notify);
  }

  @override
  Future<bool> setString(String key, String? value, {bool notify = true}) {
    return save(key, "s", value, notify: notify);
  }

  Future<bool> save(String key, String type, dynamic value,
      {required bool notify}) {
    _notify(key, notify);
    if (value != null) {
      var enKey = _encryptor.encrypt(_key, key).base64;
      if (value == "") {
        return _preferences.setString(enKey, value);
      }
      return _preferences.setString(
          enKey, "${type}${_encryptor.encrypt(_key, value.toString()).base64}");
    } else {
      return remove(key);
    }
  }

  @override
  Future<bool> setStringList(String key, List<String>? value,
      {bool notify = true}) {
    return save(key, "", value, notify: notify);
  }

  SharedPreferencesDecorator({
    required SharedPreferences preferences,
    required Encryptor encryptor,
    required String key,
  })  : _preferences = preferences,
        _encryptor = encryptor,
        _key = key;
}
