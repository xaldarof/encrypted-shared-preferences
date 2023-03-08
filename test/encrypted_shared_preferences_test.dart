import 'package:encrypt/encrypt.dart';
import 'package:encrypt_shared_preferences/enc_shared_pref.dart';
import 'package:encrypt_shared_preferences/stream_data.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:shared_preferences/shared_preferences.dart';

void main() async {
  TestWidgetsFlutterBinding.ensureInitialized();
  SharedPreferences.setMockInitialValues({});
  final sharedPref = await EncryptedSharedPreferences.getInstance();
  sharedPref.setEncryptionKey("xxxx xxxx xxxxxx");
  sharedPref.setEncryptionMode(AESMode.cfb64);
  await sharedPref.clear();

  test('check data string saved', () async {
    await sharedPref.setString("dataKey", "dataValue");
    expect(sharedPref.getString('dataKey'), "dataValue");
  });

  test('check data int saved', () async {
    await sharedPref.setInt("age", 99);
    expect(sharedPref.getInt('age'), 99);
  });

  test('check data double saved', () async {
    await sharedPref.setDouble("pi", 3.14);
    expect(sharedPref.getDouble('pi'), 3.14);
  });

  test('check data boolean saved', () async {
    sharedPref.setBoolean("isPremium", true);
    expect(sharedPref.getBoolean('isPremium'), true);
  });

  test('check data clear', () async {
    var res = await sharedPref.clear();
    expect(res, true);
    expect(sharedPref.getString('dataKey'), null);
  });

  test('check data removed', () async {
    await sharedPref.setString("dataKey", "dataValue");
    expect(sharedPref.getString('dataKey'), "dataValue");
    await sharedPref.remove('dataKey');
    expect(sharedPref.getString('dataKey'), null);
  });

  test('check get all keys', () async {
    sharedPref.setString("dataKey", "dataValue");
    var keys = await sharedPref.getKeys();
    expect(keys.length, 1);
  });

  test('check get all key values', () async {
    await sharedPref.setString("dataKey", "dataValue");
    await sharedPref.setString("dataKey1", "dataValue1");
    var keys = await sharedPref.getKeyValues();
    expect(keys.length, 2);
  });

  test('check stream', () async {
    final stream = sharedPref.listenable.stream.map((event) => event?.key);
    stream.listen((event) {
      //
    });
    expectLater(stream, emits('dataKey'));

    await sharedPref.setString("dataKey", "dataValue");
  });

  test('check stream on clear', () async {
    final stream = sharedPref.listenable.stream.map((event) => event?.key);
    stream.listen(expectAsync1((event) {
      //
    }));
    expectLater(stream, emits(null));
    await sharedPref.clear();
  });
}
