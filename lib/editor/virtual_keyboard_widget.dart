import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:virtual_keyboard_multi_language/virtual_keyboard_multi_language.dart';

import '../common.dart';
import '../state/generic_state_notifier.dart';

class VirtualKeyboardWidget extends ConsumerWidget {
  final CR colRef;
  final selectedKeySNP =
      StateNotifierProvider<GenericStateNotifier<String?>, String?>(
          (ref) => GenericStateNotifier<String?>(null));
  final keyPressedSNP = StateNotifierProvider<GenericStateNotifier<bool>, bool>(
      (ref) => GenericStateNotifier<bool>(true));

  VirtualKeyboardWidget(this.colRef, {super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return AlertDialog(
        content: Column(
          children: [
            VirtualKeyboard(
                // Default height is 300
                height: 350,
                // Default height is will screen width
                width: 600,
                // Default is black
                textColor: Colors.white,
                // Default 14
                fontSize: 20,
                // the layouts supported
                defaultLayouts: [VirtualKeyboardDefaultLayouts.English],
                // [A-Z, 0-9]
                type: VirtualKeyboardType.Alphanumeric,
                // Callback for key press event
                onKeyPress: (VirtualKeyboardKey key) {
                  ref.read(selectedKeySNP.notifier).value = key.text;
                }),
            Row(
              children: [
                Text('Selected: ${ref.watch(selectedKeySNP)}'),
                Radio(
                    value: true,
                    groupValue: ref.watch(keyPressedSNP),
                    onChanged: (v) {
                      ref.read(keyPressedSNP.notifier).value = v as bool;
                    }),
                Text('Down'),
                Radio(
                    value: false,
                    groupValue: ref.watch(keyPressedSNP),
                    onChanged: (v) {
                      ref.read(keyPressedSNP.notifier).value = v as bool;
                    }),
                Text('Up'),
              ],
            )
          ],
        ),
        actions: <Widget>[
          TextButton(
            onPressed: () {
              colRef.add({
                'key': ref.read(selectedKeySNP),
                'code': '',
                'handler':
                    '${ref.read(selectedKeySNP)}_key_${ref.read(keyPressedSNP) ? 'down' : 'up'}',
              });
              Navigator.pop(context);
            },
            child: Text('Save'),
          ),
          TextButton(
            onPressed: () {
              Navigator.pop(context);
            },
            child: Text('Cancel'),
          )
        ]);
  }
}
