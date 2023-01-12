
```dart
    var sharedPref = await EncryptedSharedPreferences.getInstance();
    await sharedPref.setString('user_token', 'xxxxxxxxxxxx');
    await sharedPref.getString('user_token'); //xxxxxxxxxxxx
    await sharedPref.remove('user_token'); //true/false
    await sharedPref.clear(); //true/false
```

