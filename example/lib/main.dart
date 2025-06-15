import 'dart:math';

import 'package:encrypt_shared_preferences/provider.dart';
import 'package:flutter/material.dart';

class CustomEncryptorAlgorithm implements IEncryptor {
  @override
  String decrypt(String key, String encryptedData) {
    const decryptedData = "";

    return decryptedData;
  }

  @override
  String encrypt(String key, String plainText) {
    const encryptedTextBase64 = "";
    return encryptedTextBase64;
  }
}

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  final EncryptedSharedPreferences legacyPrefs = await EncryptedSharedPreferences.create('1111111111111111');
  legacyPrefs.setString('dataKey1', 'dataValue');
  legacyPrefs.setString('dataKey2', 'dataValue');
  legacyPrefs.setString('dataKey3', 'dataValue');
  runApp(const MyApp());
}

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  late EncryptedSharedPreferences legacyPrefs;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
  }

  Future setInstance() async {
    legacyPrefs = await EncryptedSharedPreferences.create('1111111111111111');
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
          body: SharedBuilder(
            listenKeys: const {"key1", "key2"}, //Optional
            builder: (EncryptedSharedPreferences encryptedSharedPreferences, String? updatedKey) {
              return Text("value : ${encryptedSharedPreferences.getString("key1")}");
            },
          ),
          appBar: AppBar(
            title: const Text('Shared Builder Demo'),
          ),
          floatingActionButton: Column(
            children: [
              FloatingActionButton(
                onPressed: () async {
                  legacyPrefs.setString('key1', Random().nextInt(100).toString());
                  Future.delayed(const Duration(seconds: 3), () {
                    legacyPrefs.setString('key2', 'dataValue');
                  });
                },
              ),
              FloatingActionButton(onPressed: () async {
                legacyPrefs.setString('Random key ${Random().nextInt(100)}', Random().nextInt(100).toString());
              }),
            ],
          )),
    );
  }
}
