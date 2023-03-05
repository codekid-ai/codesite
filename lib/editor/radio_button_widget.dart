import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:codekid/common.dart';
import 'package:flutter_firestore_providers/providers.dart';

import 'package:codekid/editor/editor_page.dart';

class RadioButtonWidget extends ConsumerWidget {
  final DocumentReference doc;

  RadioButtonWidget(this.doc);

  @override
  Widget build(BuildContext context, WidgetRef ref) =>
      ref.watch(docSP(doc.path)).when(
          loading: () => Container(),
          error: (e, s) => ErrorWidget(e),
          data: (object) => Positioned(
                top: CELL_SIZE * object.data()!['top'] -
                    (CELL_SIZE - object.data()!['height']) / 6.5,
                left: CELL_SIZE * object.data()!['left'] -
                    (CELL_SIZE - object.data()!['width']) / 7,
                child: Row(
                  children: [
                    Radio(
                      value: "Checked",
                      groupValue: object.data()!['checked'] == true
                          ? "Checked"
                          : "Unchecked",
                      onChanged: (value) {},
                    ),
                    Text(object.data()!['text'] ?? 'Radio'),

                    // set color of radio button
                  ],
                ),
              ));
}
