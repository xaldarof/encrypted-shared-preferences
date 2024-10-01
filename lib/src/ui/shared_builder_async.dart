import 'package:encrypt_shared_preferences/provider.dart';
import 'package:flutter/cupertino.dart';

class SharedBuilderAsync extends StatelessWidget {
  final Set<String>? listenKeys;
  final Widget Function(
      EncryptedSharedPreferencesAsync preferences, String? updatedKey) builder;

  final EncryptedSharedPreferencesAsync _preferences =
  EncryptedSharedPreferencesAsync.getInstance();

  @override
  Widget build(BuildContext context) {
    return StreamBuilder(
      stream: listenKeys != null
          ? _preferences.observeSet(keys: listenKeys!)
          : _preferences.observe(),
      builder: (BuildContext context, AsyncSnapshot<String> snapshot) {
        return builder(_preferences, snapshot.data);
      },
    );
  }

  SharedBuilderAsync({
    super.key,
    this.listenKeys,
    required this.builder,
  });
}
