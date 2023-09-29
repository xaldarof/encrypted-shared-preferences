import 'package:encrypt_shared_preferences/provider.dart';
import 'package:flutter/cupertino.dart';

class SharedBuilder extends StatelessWidget {
  final Set<String>? listenKeys;
  final Widget child;

  final EncryptedSharedPreferences _preferences =
      EncryptedSharedPreferences.getInstance();

  @override
  Widget build(BuildContext context) {
    return StreamBuilder(
      stream: listenKeys != null
          ? _preferences.listenSet(keys: listenKeys!)
          : _preferences.listen(),
      builder: (BuildContext context, AsyncSnapshot<String> snapshot) {
        return child;
      },
    );
  }

  SharedBuilder({
    super.key,
    this.listenKeys,
    required this.child,
  });
}
