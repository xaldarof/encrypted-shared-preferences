import 'dart:async';

import 'package:encrypt/encrypt.dart';
import 'package:encrypt_shared_preferences/encryptor.dart';
import 'package:shared_preferences/shared_preferences.dart';

class SharedPreferencesDecorator implements SharedPreferences {
  final SharedPreferences _preferences;
  final AESEncryptor _encryptor;
  final String _key;
  final StreamController<String> _listenable =
      StreamController<String>.broadcast();

  Stream<String> listen({String? key}) async* {
    await for (final event in _listenable.stream) {
      if (key != null) {
        if (event == key) {
          yield key;
        }
      } else {
        yield event;
      }
    }
  }

  @override
  Future<bool> clear() => _preferences.clear();

  @override
  Future<bool> commit() => _preferences.commit();

  @override
  bool containsKey(String key) =>
      _preferences.containsKey(_encryptor.encrypt(_key, key).base64);

  @override
  Object? get(String key) {
    // TODO: implement get
    throw UnimplementedError();
  }

  @override
  bool? getBool(String key) {
    final value = _preferences.getString(_encryptor.encrypt(_key, key).base64);
    if (value != null) {
      return _encryptor.decrypt(_key, Encrypted.fromBase64(value)) == "true";
    } else {
      return null;
    }
  }

  @override
  double? getDouble(String key) {
    final value = _preferences.getString(_encryptor.encrypt(_key, key).base64);
    if (value != null) {
      return double.parse(
          _encryptor.decrypt(_key, Encrypted.fromBase64(value)));
    } else {
      return null;
    }
  }

  @override
  int? getInt(String key) {
    final value = _preferences.getString(_encryptor.encrypt(_key, key).base64);
    if (value != null) {
      return int.parse(_encryptor.decrypt(_key, Encrypted.fromBase64(value)));
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
      return _encryptor.decrypt(_key, Encrypted.fromBase64(value));
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
  Future<void> reload() async {
    final all = getAsMap();
    await _preferences.clear();
    addAll(all);
  }

  void addAll(Map<String, dynamic> map) {
    map.forEach((key, value) {
      _preferences.setString(key, value);
    });
  }

  Map<String, dynamic> getAsMap() {
    Map<String, dynamic> map = {};
    getKeys().forEach((element) {
      map[element] = _preferences.getString(element);
    });
    return map;
  }

  @override
  Future<bool> remove(String key) {
    _listenable.add(key);
    return _preferences.remove(_encryptor.encrypt(_key, key).base64);
  }

  @override
  Future<bool> setBool(String key, bool? value) {
    return save(key, value);
  }

  @override
  Future<bool> setDouble(String key, double? value) {
    return save(key, value);
  }

  @override
  Future<bool> setInt(String key, int? value) {
    return save(key, value);
  }

  @override
  Future<bool> setString(String key, String? value) {
    _listenable.add(key);
    return save(key, value);
  }

  Future<bool> save(String key, dynamic value) {
    if (value != null) {
      return _preferences.setString(_encryptor.encrypt(_key, key).base64,
          _encryptor.encrypt(_key, value.toString()).base64);
    } else {
      return remove(key);
    }
  }

  @override
  Future<bool> setStringList(String key, List<String>? value) {
    return save(key, value);
  }

  SharedPreferencesDecorator({
    required SharedPreferences preferences,
    required AESEncryptor encryptor,
    required String key,
  })  : _preferences = preferences,
        _encryptor = encryptor,
        _key = key;
}
