import 'package:encrypt_shared_preferences/src/enc_shared_pref_async.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:shared_preferences_platform_interface/shared_preferences_async_platform_interface.dart';
import 'package:shared_preferences_platform_interface/in_memory_shared_preferences_async.dart';

void main() async {
  SharedPreferencesAsyncPlatform.instance =
      InMemorySharedPreferencesAsync.empty();
  await EncryptedSharedPreferencesAsync.initialize("1111111111111111");
  final sharedPref = EncryptedSharedPreferencesAsync.getInstance();
  await sharedPref.clear();

  test('test listen key', () async {
    sharedPref.listen(key: 'singleKey').listen(
      expectAsync1(
        (event) {
          expect(event, 'singleKey');
        },
      ),
    );
    await Future.delayed(Duration.zero);
    await sharedPref.setString('singleKey', "Hi");
  });

  test('test listen key with observe method', () async {
    sharedPref.observe(key: 'singleKeyObserve').listen(
      expectAsync1(
        (event) {
          expect(event, 'singleKeyObserve');
        },
      ),
    );
    await Future.delayed(Duration.zero);
    await sharedPref.setString('singleKeyObserve', "Hi");
  });

  test('test listen set of keys', () async {
    sharedPref.observeSet(keys: {"keySet1", 'keySet2'}).listen(
      expectAsync1(
        (event) {
          expect(event, 'keySet1');
        },
      ),
    );
    await Future.delayed(Duration.zero);
    await sharedPref.setString('keySet1', "Hi");
  });
  test('test listen set of keys with observeSet method', () async {
    sharedPref.observeSet(keys: {"keySet1Observe", 'keySet2Observe'}).listen(
      expectAsync1(
        (event) {
          expect(event, 'keySet1Observe');
        },
      ),
    );
    await Future.delayed(Duration.zero);
    await sharedPref.setString('keySet1Observe', "Hi");
  });

  test('check data string saved', () async {
    await sharedPref.setString("dataKey", "dataValue");
    expect(await sharedPref.getString('dataKey'), "dataValue");
  });

  test('check empty string saved', () async {
    await sharedPref.setString("keyDataEmpty", "");
    expect(await sharedPref.getString("keyDataEmpty"), "");
  });

  test('check data int saved', () async {
    await sharedPref.setInt("age", 99);
    expect(await sharedPref.getInt('age'), 99);
  });

  test('check data double saved', () async {
    await sharedPref.setDouble("pi", 3.14);
    expect(await sharedPref.getDouble('pi'), 3.14);
  });

  test('check data boolean saved', () async {
    sharedPref.setBoolean("isPremium", true);
    expect(await sharedPref.getBoolean('isPremium'), true);
  });

  test('check data clear', () async {
    var res = await sharedPref.clear(notify: false);
    expect(res, true);
    expect(await sharedPref.getString('dataKey'), null);
  });

  test('check data removed', () async {
    await sharedPref.setString("dataKey", "dataValue");
    expect(await sharedPref.getString('dataKey'), "dataValue");
    await sharedPref.remove('dataKey');
    expect(await sharedPref.getString('dataKey'), null);
  });

  test('check get all keys', () async {
    await sharedPref.setString("dataKey", "dataValue");
    var keys = await sharedPref.getKeys();
    expect(keys.length, 1);
  });

  test('test remove where', () async {
    await sharedPref.setString('key1', "value1");
    await sharedPref.setString('key2', "value2");
    await sharedPref.setString('key3', "value3");
    final saveKeySet = {
      "key1"
          "key3"
    };
    await sharedPref.removeWhere(condition: (key) => saveKeySet.contains(key));
    expect(await sharedPref.getString("key2"), "value2");
  });

  test('test defaultValue', () async {
    final strValue =
        await sharedPref.getString("key10", defaultValue: "defaultKey10Value");
    final intValue = await sharedPref.getInt("key11", defaultValue: 1011);
    final doubleValue = await sharedPref.getDouble("key12", defaultValue: 1.23);
    final boolValue = await sharedPref.getBoolean("key13", defaultValue: false);

    expect(strValue, "defaultKey10Value");
    expect(intValue, 1011);
    expect(doubleValue, 1.23);
    expect(boolValue, false);
  });

  test('test saving string list value', () async {
    final strValue = await sharedPref
        .setStringList("stringList", ["apple", "orange", "boom"]);
    expect(strValue, true);
    final actual = await sharedPref.getStringList('stringList');
    expect(actual, ["apple", "orange", "boom"]);
  });
}
