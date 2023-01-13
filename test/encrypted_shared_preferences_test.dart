import 'dart:math';

import 'package:encrypt_shared_preferences/enc_shared_pref.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  test('check data saved', () async {
    final sharedPref = await EncryptedSharedPreferences.getInstance();
    sharedPref.setEncryptionKey("xxxx xxxx xxxxxx");
    sharedPref.setString("dataKey", "dataValue");
    expect(sharedPref.getString('dataKey'), "dataValue");
    var res = await sharedPref.clear();
    expect(res, true);
    expect(sharedPref.getString('dataKey'), null);
  });
}
