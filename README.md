Wraps platform-specific persistent storage for simple data (NSUserDefaults on iOS and macOS,
SharedPreferences on Android, etc.). Data may be persisted to disk asynchronously, and there is no
guarantee that writes will be persisted to disk after returning, so this plugin must be used for
storing critical data.

[Open pub.dev](https://pub.dev/packages/encrypt_shared_preferences)

```dart
void main() {
  var sharedPref = await EncryptedSharedPreferences.getInstance();
  sharedPref.setEncryptionKey("key 16 length");
  sharedPref.setEncryptionMode(AESMode.cbc); //optional (default : AESMode.cbc)

  await sharedPref.setString('user_token', 'xxxxxxxxxxxx');

  await sharedPref.getString('user_token'); //xxxxxxxxxxxx
  
  
  await sharedPref.setInt('age', 99);
  
  await sharedPref.getInt('age'); //99
  
  
  await sharedPref.setDouble('pi', 3.14);
  
  await sharedPref.getDouble('pi'); //3.14
  
  
  await sharedPref.setBoolean('isPremium', true); //3.14
  
  
  await sharedPref.getBoolean('isPremium'); //3.14

  await sharedPref.remove('user_token'); //true/false

  await sharedPref.clear(); //true/false
}

```

#### Supported modes :

- CBC `AESMode.cbc` (default)
- CFB-64 `AESMode.cfb64`
- CTR `AESMode.ctr`
- ECB `AESMode.ecb`
- OFB-64/GCTR `AESMode.ofb64Gctr`
- OFB-64 `AESMode.ofb64`
- SIC `AESMode.sic`
