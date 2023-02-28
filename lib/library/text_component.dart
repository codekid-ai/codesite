import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class TextComponent extends ConsumerWidget {
  @override
  Widget build(BuildContext context, WidgetRef ref) =>
      ListTile(title: Text('text'), trailing: Text('Shift+t'));
}
