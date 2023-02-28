import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class ButtonComponent extends ConsumerWidget {
  @override
  Widget build(BuildContext context, WidgetRef ref) => ListTile(
      title: ElevatedButton(onPressed: () {}, child: Text('button')),
      trailing: Text('Shift+b'));
}
