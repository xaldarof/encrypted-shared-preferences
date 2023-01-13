import 'dart:math';

import 'package:encrypt/encrypt.dart';
import 'package:encrypt_shared_preferences/enc_shared_pref.dart';
import 'package:flutter_test/flutter_test.dart';

void main() async {
  final sharedPref = await EncryptedSharedPreferences.getInstance();
  sharedPref.setEncryptionKey("xxxx xxxx xxxxxx");
  sharedPref.setEncryptionMode(AESMode.cfb64);

  test('check data saved', () async {
    sharedPref.setString("dataKey", "dataValue");
    expect(sharedPref.getString('dataKey'), "dataValue");
  });

  test('check data clear', () async {
    var res = await sharedPref.clear();
    expect(res, true);
    expect(sharedPref.getString('dataKey'), null);
  });

  test('check data removed', () async {
    sharedPref.setString("dataKey", "dataValue");
    expect(sharedPref.getString('dataKey'), "dataValue");
    await sharedPref.remove('dataKey');
    expect(sharedPref.getString('dataKey'), null);
  });

  test('check get all keys', () async {
    await sharedPref.clear();
    sharedPref.setString("dataKey", "dataValue");
    var keys = await sharedPref.getKeys();
    expect(keys.length, 1);
  });

  test('check get all key values', () async {
    await sharedPref.clear();
    await sharedPref.setString("dataKey", "dataValue");
    await sharedPref.setString("dataKey1", "dataValue1");
    var keys = await sharedPref.getKeyValues();
    expect(keys.length, 2);
  });
}
