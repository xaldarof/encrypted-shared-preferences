import 'package:encrypt_shared_preferences/provider.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:shared_preferences/shared_preferences.dart';

void main() async {
  TestWidgetsFlutterBinding.ensureInitialized();
  SharedPreferences.setMockInitialValues({});
  await EncryptedSharedPreferences.initialize("1111111111111111",
      algorithm: EncryptionAlgorithm.salsa20);
  final sharedPref = EncryptedSharedPreferences.getInstance();
  await sharedPref.clear();

  test('test listen key', () async {
    sharedPref.listen(key: 'singleKey').listen(
      expectAsync1(
        (event) {
          expect(event, 'singleKey');
        },
      ),
    );
    await sharedPref.setString('singleKey', "Hi");
    await sharedPref.setString('singleKey', "Hi");
  });

  test('test listen set of keys', () async {
    sharedPref.listenSet(keys: {"keySet1", 'keySet2'}).listen(
      expectAsync1(
        (event) {
          expect(event, 'keySet1');
        },
      ),
    );
    await sharedPref.setString('keySet1', "Hi");
  });

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
}
