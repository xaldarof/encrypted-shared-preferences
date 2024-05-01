import 'package:encrypt_shared_preferences/provider.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:shared_preferences/shared_preferences.dart';

void main() async {
  SharedPreferences.setMockInitialValues({});
  await EncryptedSharedPreferences.initialize("1111111111111111");
  final sharedPref = EncryptedSharedPreferences.getInstance();
  await sharedPref.clear();

  test('test batch save', () async {
    await EncryptedSharedPreferences.getInstance()
        .setString('dataKey', 'dataValueBefore');

    await EncryptedSharedPreferences.getInstance().batch((batch) async {
      await batch.setString('dataKey1', 'dataValue1');
      await batch.setString('dataKey2', 'dataValue2');
      await batch.setString('dataKey3', 'dataValue3');
      await batch.setString('dataKey', 'updated');

      return Future(() => true);
    });

    expect(EncryptedSharedPreferences.getInstance().getString('dataKey'),
        'updated');

    await EncryptedSharedPreferences.getInstance()
        .setString('dataKey', 'dataValueBeforeTest2');

    await EncryptedSharedPreferences.getInstance().batch((batch) async {
      await batch.setString('dataKey1', 'dataValue1');
      await batch.setString('dataKey2', 'dataValue2');
      await batch.setString('dataKey3', 'dataValue3');
      await batch.setString('dataKey', 'updated');

      return Future(() => false);
    });

    expect(EncryptedSharedPreferences.getInstance().getString('dataKey'),
        'dataValueBeforeTest2');
  });
}
