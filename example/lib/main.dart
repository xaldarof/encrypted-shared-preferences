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
  await EncryptedSharedPreferences.initialize('1111111111111111',
      encryptor: CustomEncryptorAlgorithm());

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
        body: SharedBuilder(
          listenKeys: const {"key1", "key2"}, //Optional
          builder: (EncryptedSharedPreferences encryptedSharedPreferences) {
            return Text(
                "value : ${encryptedSharedPreferences.getString("key1")}");
          },
        ),
        appBar: AppBar(
          title: const Text('Shared Builder Demo'),
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
