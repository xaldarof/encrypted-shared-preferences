import 'package:devtools_extensions/devtools_extensions.dart';
import 'package:flutter/material.dart';

void main() {
  runApp(const FooDevToolsExtension());
}

class FooDevToolsExtension extends StatefulWidget {
  const FooDevToolsExtension({super.key});

  @override
  State<FooDevToolsExtension> createState() => _FooDevToolsExtensionState();
}

class _FooDevToolsExtensionState extends State<FooDevToolsExtension> {
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return DevToolsExtension(
      child: ListView.builder(
          itemCount: 50,
          itemBuilder: (index, context) {
            return Text('data');
          }), // Build your extension here
    );
  }
}
