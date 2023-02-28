import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class ImageComponent extends ConsumerWidget {
  @override
  Widget build(BuildContext context, WidgetRef ref) => const ListTile(
      title: Image(image: NetworkImage('https://flutter.github.io/assets-for-api-docs/assets/widgets/owl.jpg')),
      trailing: Text("Shift+u"));
}