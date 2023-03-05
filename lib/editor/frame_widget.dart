import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:codekid/common.dart';
import 'package:flutter_firestore_providers/providers.dart';

import 'package:codekid/editor/editor_page.dart';

class FrameWidget extends ConsumerWidget {
  final DocumentReference doc;

  FrameWidget(this.doc);

  @override
  Widget build(BuildContext context, WidgetRef ref) =>
      ref.watch(docSP(doc.path)).when(
          loading: () => Container(),
          error: (e, s) => ErrorWidget(e),
          data: (object) => Positioned(
              top: CELL_SIZE * object.data()!['top'],
              left: CELL_SIZE * object.data()!['left'],
              child: Container(
                  width: CELL_SIZE * object.data()!['width'],
                  height: CELL_SIZE * object.data()!['height'],
                  decoration: BoxDecoration(
                      border: Border(
                    right: BorderSide(color: CELL_BORDER_COLOR, width: 2),
                    left: BorderSide(color: CELL_BORDER_COLOR, width: 2),
                    top: BorderSide(color: CELL_BORDER_COLOR, width: 2),
                    bottom: BorderSide(color: CELL_BORDER_COLOR, width: 2),
                  )))));
}
