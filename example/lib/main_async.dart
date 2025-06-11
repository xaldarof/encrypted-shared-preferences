import 'dart:math';

import 'package:encrypt_shared_preferences/provider.dart';
import 'package:flutter/material.dart';

const key = '1111111111111111';

void main() async {
  runApp(const MyApp());
}

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        body: SharedBuilderAsync(
          listenKeys: const {"key1", "key2"}, //Optional
          builder: (EncryptedSharedPreferencesAsync encryptedSharedPreferences,
              String? updatedKey) {
            return FutureBuilder(
              future: encryptedSharedPreferences.getString("key1"),
              builder: (BuildContext context, AsyncSnapshot<String?> snapshot) {
                return Text("value : ${snapshot.data}");
              },
            );
          },
        ),
        appBar: AppBar(
          title: const Text('Shared Builder Demo'),
        ),
        floatingActionButton: FloatingActionButton(
          onPressed: () async {
            EncryptedSharedPreferencesAsync(key).setString('key1', 'dataValue');
            Future.delayed(const Duration(seconds: 3), () {
              EncryptedSharedPreferencesAsync(key)
                  .setString('key1', 'dataValue:${Random().nextInt(100)}');
            });
          },
        ),
      ),
    );
  }
}
