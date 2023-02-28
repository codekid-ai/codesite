import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class IconComponent extends ConsumerWidget {
  @override
  Widget build(BuildContext context, WidgetRef ref) => const ListTile(
        leading: Text("Icon"),
        title: Icon(
          Icons.info,
          size: 30,
          color: Colors.white,
        ),
        trailing: Text("Shift+Q"),
      );
}
