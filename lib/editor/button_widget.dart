import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:codekid/common.dart';
import 'package:codekid/providers/firestore.dart';
import 'package:codekid/editor/editor_page.dart';

class ButtonWidget extends ConsumerWidget {
  final DocumentReference doc;

  ButtonWidget(this.doc);

  @override
  Widget build(BuildContext context, WidgetRef ref) =>
      ref.watch(docSP(doc.path)).when(
          loading: () => Container(),
          error: (e, s) => ErrorWidget(e),
          data: (object) => Positioned(
              top: CELL_SIZE * object.data()!['top'],
              left: CELL_SIZE * object.data()!['left'],
              child: SizedBox(
                  width: CELL_SIZE * object.data()!['width'],
                  height: CELL_SIZE * object.data()!['height'],
                  child: ElevatedButton(
                      child: Text(
                        object.data()!['text'] ?? "",
                        style: TextStyle(color: Colors.red),
                      ),
                      onPressed: () {}))));
}
