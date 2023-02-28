import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class CheckboxComponent extends ConsumerWidget {
  @override
  Widget build(BuildContext context, WidgetRef ref) => ListTile(
      title: Checkbox(onChanged: (e) {}, value: true),
      trailing: Text('Shift+c'));
}
