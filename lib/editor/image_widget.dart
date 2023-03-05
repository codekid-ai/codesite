import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:codekid/common.dart';
import 'package:flutter_firestore_providers/providers.dart';

import 'package:codekid/editor/editor_page.dart';

class ImageWidget extends ConsumerWidget {
  final DocumentReference doc;

  ImageWidget(this.doc);

  @override
  Widget build(BuildContext context, WidgetRef ref) =>
      ref.watch(docSP(doc.path)).when(
          loading: () => Container(),
          error: (err, stack) => ErrorWidget(err),
          data: (object) => Positioned(
              top: CELL_SIZE * object.data()!['top'],
              left: CELL_SIZE * object.data()!['left'],
              child: Center(
                  child: Container(
                      width: CELL_SIZE * object.data()!['width'],
                      height: CELL_SIZE * object.data()!['height'],
                      child: const Image(
                        image: NetworkImage(
                            'https://flutter.github.io/assets-for-api-docs/assets/widgets/owl.jpg'),
                      )))));
}
