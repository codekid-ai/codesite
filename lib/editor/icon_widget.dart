import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:codekid/common.dart';
import 'package:codekid/providers/firestore.dart';
import 'package:codekid/editor/editor_page.dart';

// IconData Function(String icon) getIcon = (String icon) =>
//     {
//       'add': Icons.add,
//       'remove': Icons.remove,
//       'edit': Icons.edit,
//       'delete': Icons.delete,
//       'save': Icons.save,
//       'cancel': Icons.cancel,
//       'search': Icons.search,
//       'settings': Icons.settings,
//       'menu': Icons.menu,
//     }[icon] ??
//     Icons.info;

Color Function(String color) getColor = (String color) {
  // color comes as a string  4294967295
  // 0xFF000000
  // return Color(int.parse(color));
  try {
    return Color(int.parse(color));
  } catch (e) {
    return Colors.white;
  }
};

class IconWidget extends ConsumerWidget {
  final DocumentReference doc;

  IconWidget(this.doc);

  @override
  Widget build(BuildContext context, WidgetRef ref) =>
      ref.watch(docSP(doc.path)).when(
          loading: () => Container(),
          error: (err, stack) => ErrorWidget(err),
          data: (object) => Positioned(
              top: CELL_SIZE * object.data()!['top'],
              left: CELL_SIZE * object.data()!['left'],
              child: Icon(
                // it's a string returned by flutter_iconpicker package in a format 'iconData!.codePoint'
                IconData(int.parse(object.data()!['icon'] ?? '58172'),
                    fontFamily: 'MaterialIcons'),
                size: object.data()!['width'] * CELL_SIZE,
                color: getColor(object.data()!['icon_color'] ?? 'white'),
              )));
}
