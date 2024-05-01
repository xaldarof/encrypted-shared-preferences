class BatchSharedPreferences {
  late final Map<String, dynamic> _batch;

  Map<String, dynamic> get batch => _batch;

  Future<bool> clear({bool notify = true}) async {
    _batch.clear();
    return true;
  }

  String? get(String key) => _batch[key];

  bool? getBoolean(String key) => _batch[key];

  double? getDouble(String key) => _batch[key];

  int? getInt(String key) => _batch[key];

  Set<String> getKeys() => _batch.keys.toSet();

  String? getString(String key) => _batch[key];

  Future<bool> remove(String key, {bool notify = true}) async {
    _batch.remove(key);
    return true;
  }

  Future<bool> setBoolean(String dataKey, bool? dataValue,
      {bool notify = true}) async {
    _batch[dataKey] = dataValue;
    return true;
  }

  Future<bool> setDouble(String dataKey, double? dataValue,
      {bool notify = true}) async {
    _batch[dataKey] = dataValue;
    return true;
  }

  Future<bool> setInt(String dataKey, int? dataValue,
      {bool notify = true}) async {
    _batch[dataKey] = dataValue;
    return true;
  }

  Future<bool> setString(String dataKey, String? dataValue,
      {bool notify = true}) async {
    _batch[dataKey] = dataValue;
    return true;
  }

  bool containsKey(String key) => _batch.containsKey(key);

  bool? getBool(String key) => _batch[key];

  Future<bool> setBool(String key, bool value) async {
    _batch[key] = value;
    return true;
  }

  BatchSharedPreferences({
    required Map<String, dynamic> batch,
  }) : _batch = batch;
}
