Shared preferences are a simple key-value storage mechanism that can be used to store small amounts of data. However, since shared preferences are stored in plain text, it is not suitable for storing sensitive information. To address this issue, you can use AES encryption to encrypt the data before saving it to shared preferences.

To use shared preferences with AES encryption support, you can add this package to your project as dependency.



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
