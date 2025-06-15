import 'package:encrypt_shared_preferences/provider.dart';
import 'package:flutter/material.dart';

class SharedBuilder extends StatefulWidget {
  final Set<String>? listenKeys;
  final Widget Function(EncryptedSharedPreferences preferences, String? updatedKey) builder;

  @override
  State<SharedBuilder> createState() => _SharedBuilderState();

  const SharedBuilder({
    super.key,
    this.listenKeys,
    required this.builder,
  });
}

class _SharedBuilderState extends State<SharedBuilder> {
  late EncryptedSharedPreferences _preferences;

  @override
  void initState() {
    setInsatnce();
    super.initState();
  }

  Future setInsatnce() async {
    _preferences = await EncryptedSharedPreferences.create("1111111111111111");
  }

  @override
  Widget build(BuildContext context) {
    return StreamBuilder(
      stream: widget.listenKeys != null ? _preferences.observeSet(keys: widget.listenKeys!) : _preferences.observe(),
      builder: (BuildContext context, AsyncSnapshot<String> snapshot) {
        return widget.builder(_preferences, snapshot.data);
      },
    );
  }
}
