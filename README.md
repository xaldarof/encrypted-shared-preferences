Wraps platform-specific persistent storage for simple data (NSUserDefaults on iOS and macOS,
SharedPreferences on Android, etc.). Data may be persisted to disk asynchronously, and there is no
guarantee that writes will be persisted to disk after returning, so this plugin must be used for
storing critical data.

[Open pub.dev](https://pub.dev/packages/encrypt_shared_preferences)

```dart
void main() {
  EncryptedSharedPreferences.initialize(key 16 length);
  var sharedPref = await EncryptedSharedPreferences.getInstance();

  sharedPref.setString('user_token', 'xxxxxxxxxxxx');

  await sharedPref.getString('user_token'); //xxxxxxxxxxxx
  
  
  sharedPref.setInt('age', 99);
  
  await sharedPref.getInt('age'); //99
  
  
  sharedPref.setDouble('pi', 3.14);
  
  await sharedPref.getDouble('pi'); //3.14
  
  
  sharedPref.setBoolean('isPremium', true);
  
  
  await sharedPref.getBoolean('isPremium'); //true

  await sharedPref.remove('user_token'); //true/false

  await sharedPref.clear(); //true/false

  sharedPref.listenKey('token').listen((event) { //event = key
    print(event);
  });
}
