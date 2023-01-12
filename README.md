Wraps platform-specific persistent storage for simple data (NSUserDefaults on iOS and macOS,
SharedPreferences on Android, etc.). Data may be persisted to disk asynchronously, and there is no
guarantee that writes will be persisted to disk after returning, so this plugin must be used for
storing critical data. See: [View](https://pub.dev/packages/encrypt_shared_preferences)

```dart
void main() {
  var sharedPref = await EncryptedSharedPreferences.getInstance();
  sharedPref.setEncryptionKey("key 16 length");
  await sharedPref.setString('user_token', 'xxxxxxxxxxxx');
  await sharedPref.getString('user_token'); //xxxxxxxxxxxx
  await sharedPref.remove('user_token'); //true/false
  await sharedPref.clear(); //true/false
}

```

