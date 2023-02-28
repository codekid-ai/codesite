import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class RadioButtonComponent extends ConsumerWidget {
  @override
  Widget build(BuildContext context, WidgetRef ref) => ListTile(
      title: Row(
        children: [
          Radio(
            value: "Checked",
            groupValue: "Checked",
            onChanged: (value) {},
          ),
          const Text("Radio Button"),
        ],
      ),
      trailing: const Text("Shift+O"));
}
