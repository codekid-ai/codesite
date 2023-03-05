import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:codekid/common.dart';
import 'package:flutter_firestore_providers/providers.dart';

import 'package:codekid/editor/editor_page.dart';

class TextFieldWidget extends ConsumerWidget {
  final DocumentReference doc;

  TextFieldWidget(this.doc);

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
                  child: TextField(
                    decoration: InputDecoration(
                      border: OutlineInputBorder(),
                      labelText: 'Even Densed TextFiled',
                      isDense: true, // Added this
                      contentPadding: EdgeInsets.all(8), // Added this
                    ),
                    style: TextStyle(fontSize: 10.0, height: 2.0),

                    //decoration: ,
                  ))));
}
