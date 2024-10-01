Shared preferences are a simple key-value storage mechanism that can be used to store small amounts
of data. However, since shared preferences are stored in plain text, it is not suitable for storing
sensitive information. To address this issue, you can use AES encryption to encrypt the data before
saving it to shared preferences.

To use shared preferences with AES encryption support, you can add this package to your project as
dependency.

[Open pub.dev](https://pub.dev/packages/encrypt_shared_preferences)


Legacy EncryptedSharedPreferences

```dart
void main() async {
  final key = "";
  await EncryptedSharedPreferences.initialize(key: key);
  var sharedPref = EncryptedSharedPreferences.getInstance();

  await sharedPref.setString(
      'user_token', 'xxxxxxxxxxxx', notify: true); ////notify = true by default

  sharedPref.getString('user_token'); //xxxxxxxxxxxx

  await sharedPref.setInt('age', 99, notify: true); //notify = true by default

  sharedPref.getInt('age', defaultValue: 1001); //99

  await sharedPref.setDouble('pi', 3.14, notify: true); //notify = true by default

  sharedPref.getDouble('pi'); //3.14

  await sharedPref.setBoolean('isPremium', true, notify: true); //notify = true by default

  sharedPref.getBoolean('isPremium'); //true

  await sharedPref.remove('user_token', notify: true); //notify = true by default

  await sharedPref.clear(notify: true); //notify = true by default

  await sharedPref.reload();

  final badKeys = {
    "key1"
        "key2"
  };
  await sharedPref.removeWhere((key, value) => badKeys.contains(key),
      notifyEach: true); //notifyEach:true for notifying for each key update

  sharedPref.observe(key: 'token').listen((event) {
    // event = key
    print(event);
  });

  sharedPref.observeSet(keys: {'key1', 'key2', 'keyN'}).listen((event) {
    // event = key
    print(event);
  });
}
```


EncryptedSharedPreferencesAsync

```dart
void main() async {
  final key = "";
  await EncryptedSharedPreferencesAsync.initialize(key: key);
  var sharedPref = EncryptedSharedPreferencesAsync.getInstance();

  await sharedPref.setString(
      'user_token', 'xxxxxxxxxxxx', notify: true); ////notify = true by default

  await sharedPref.getString('user_token'); //xxxxxxxxxxxx

  await sharedPref.setInt('age', 99, notify: true); //notify = true by default

  await sharedPref.getInt('age', defaultValue: 1001); //99

  await sharedPref.setDouble('pi', 3.14, notify: true); //notify = true by default

  await sharedPref.getDouble('pi'); //3.14

  await sharedPref.setBoolean('isPremium', true, notify: true); //notify = true by default

  await sharedPref.getBoolean('isPremium'); //true

  await sharedPref.remove('user_token', notify: true); //notify = true by default

  await sharedPref.clear(notify: true); //notify = true by default

  await sharedPref.reload();

  final badKeys = {
    "key1"
        "key2"
  };
  await sharedPref.removeWhere((key, value) => badKeys.contains(key),
      notifyEach: true); //notifyEach:true for notifying for each key update

  sharedPref.observe(key: 'token').listen((event) {
    // event = key
    print(event);
  });

  sharedPref.observeSet(keys: {'key1', 'key2', 'keyN'}).listen((event) {
    // event = key
    print(event);
  });
}
```

[Shared builder] Here is example of how to use SharedBuilder widget

```dart
class _MyAppState extends State<MyApp> {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        body: SharedBuilder(
          listenKeys: const {"key1", "key2"}, //Optional
          builder: (EncryptedSharedPreferences encryptedSharedPreferences,String? updatedKey) {
            return Text("value : ${encryptedSharedPreferences.getString("key1")}");
          },
        ),
        floatingActionButton: FloatingActionButton(
          onPressed: () async {
            EncryptedSharedPreferences.getInstance()
                .setString('key1', 'dataValue');
            Future.delayed(const Duration(seconds: 3), () {
              EncryptedSharedPreferences.getInstance()
                  .setString('key2', 'dataValue');
            });
          },
        ),
      ),
    );
  }
}

```

[Shared builder async] Here is example of how to use SharedBuilder widget

```dart
class _MyAppState extends State<MyApp> {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        body: SharedBuilderAsync(
          listenKeys: const {"key1", "key2"}, //Optional
          builder: (EncryptedSharedPreferencesAsync encryptedSharedPreferences,String? updatedKey) {
            return Text("value : $updatedKey");
          },
        ),
        floatingActionButton: FloatingActionButton(
          onPressed: () async {
            EncryptedSharedPreferencesAsync.getInstance()
                .setString('key1', 'dataValue');
            Future.delayed(const Duration(seconds: 3), () {
              EncryptedSharedPreferencesAsync.getInstance()
                  .setString('key2', 'dataValue');
            });
          },
        ),
      ),
    );
  }
}

```

Also you can add custom external encryptor

```dart
class CustomEncryptor extends IEncryptor {
  @override
  String decrypt(String key, String encryptedData) {
    //decryption logic
  }

  @override
  String encrypt(String key, String plainText) {
    //encryption logic
  }
}

void main() {
  final key = "";
  await EncryptedSharedPreferences.initialize(key: key, encryptor: CustomEncryptor());
  var sharedPref = EncryptedSharedPreferences.getInstance();
}
```


Save using batch(Experimental)


```dart
    await EncryptedSharedPreferences.getInstance().batch((batch) async {
      //await all async preference operations
      await batch.setString('dataKey1', 'dataValue1');
      await batch.setString('dataKey2', 'dataValue2');
      await batch.setString('dataKey3', 'dataValue3');

      return Future(() => true);
    });
```