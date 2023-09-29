import 'package:encrypt_shared_preferences/provider.dart';
import 'package:flutter/material.dart';

void main() async {
  await EncryptedSharedPreferences.initialize('1111111111111111');
  var sharedPref = EncryptedSharedPreferences.getInstance();

  await sharedPref.setString('user_token', 'xxxxxxxxxxxx');

  sharedPref.getString('user_token'); //xxxxxxxxxxxx


  await sharedPref.setInt('age', 99);

  sharedPref.getInt('age'); //99


  await sharedPref.setDouble('pi', 3.14);

  sharedPref.getDouble('pi'); //3.14


  await sharedPref.setBoolean('isPremium', true);


  sharedPref.getBoolean('isPremium'); //true

  await sharedPref.remove('user_token'); //true/false

  await sharedPref.clear(); //true/false

  sharedPref.listen(key: 'token').listen((event) { //event = key
    print(event);
  });

  sharedPref.listenSet(keys: {'key1', 'key2', 'keyN'}).listen((
      event) { //event = key
    print(event);
  });

  runApp(const MyApp());
}

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        body: SharedBuilder(child: Container()),
        appBar: AppBar(
          title: const Text('Native Packages'),
        ),
        floatingActionButton: FloatingActionButton(onPressed: () async {
          //
        }),
      ),
    );
  }
}