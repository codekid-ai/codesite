import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:codekid/common.dart';
import 'package:flutter_firestore_providers/providers.dart';

import 'package:codekid/editor/editor_page.dart';

Color Function(String color) getColor = (String color) {
  // color comes as a string  4294967295
  // 0xFF000000
  // return Color(int.parse(color));
  try {
    return Color(int.parse(color));
  } catch (e) {
    return Colors.black;
  }
};

class DropdownWidget extends ConsumerWidget {
  final DocumentReference doc;

  DropdownWidget(this.doc);

  @override
  Widget build(BuildContext context, WidgetRef ref) => ref
      .watch(docSP(doc.path))
      .when(
        loading: () => Container(),
        error: (err, stack) => ErrorWidget(err),
        data: (object) => Positioned(
            top: CELL_SIZE * object.data()!['top'],
            left: CELL_SIZE * object.data()!['left'],
            child: SizedBox(
              // width and height should not be less than 1 CELL_SIZE
              width: object.data()!['width'] * CELL_SIZE < CELL_SIZE
                  ? CELL_SIZE
                  : object.data()!['width'] * CELL_SIZE,
              height: object.data()!['height'] * CELL_SIZE < CELL_SIZE
                  ? CELL_SIZE
                  : object.data()!['height'] * CELL_SIZE,
              child: Theme(
                data: Theme.of(context).copyWith(
                  disabledColor:
                      getColor(object.data()!['font_color'] ?? 'black'),
                ),
                child: Container(
                  decoration: BoxDecoration(
                    color:
                        getColor(object.data()!['background_color'] ?? 'white'),
                    borderRadius: BorderRadius.circular(5),
                  ),
                  height: object.data()!['height'] * CELL_SIZE,
                  child: InputDecorator(
                    decoration: InputDecoration(
                      contentPadding: const EdgeInsets.only(
                          top: 0, bottom: 0, left: 10, right: 10),
                      fillColor: getColor(
                          object.data()!['background_color'] ?? 'white'),
                      disabledBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(5),
                        borderSide: BorderSide(
                          color: getColor(
                              object.data()!['border_color'] ?? 'black'),
                          width: object.data()!['border_width'] ?? 1,
                        ),
                      ),
                      enabledBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(5),
                        borderSide: BorderSide(
                          color: getColor(
                              object.data()!['border_color'] ?? 'black'),
                          width: object.data()!['border_width'] ?? 1,
                        ),
                      ),
                      focusedBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(5),
                        borderSide: BorderSide(
                          color: getColor(
                              object.data()!['border_color'] ?? 'black'),
                          width: object.data()!['border_width'] ?? 1,
                        ),
                      ),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(5),
                        borderSide: BorderSide(
                          color: getColor(
                              object.data()!['border_color'] ?? 'black'),
                          width: object.data()!['border_width'] ?? 1,
                        ),
                      ),
                    ),
                    child: DropdownButtonHideUnderline(
                      child: DropdownButton(
                        itemHeight: null,
                        items: [
                          DropdownMenuItem(
                            value: object.data()!['text'] ?? "dropdown",
                            child: Text(object.data()!['text'] ?? "dropdown"),
                          )
                        ],
                        isExpanded: true,
                        onChanged: null,
                        value: object.data()!['text'] ?? "dropdown",
                        elevation: 0,
                        style: TextStyle(
                          color:
                              getColor(object.data()!['font_color'] ?? 'black'),
                          decorationColor:
                              getColor(object.data()!['font_color'] ?? 'black'),
                          fontSize: object.data()!['font_size'] ?? 16,
                        ),
                        iconDisabledColor:
                            getColor(object.data()!['font_color'] ?? 'black'),
                        iconEnabledColor:
                            getColor(object.data()!['font_color'] ?? 'black'),
                        isDense: true,
                      ),
                    ),
                  ),
                ),
              ),
            )),
      );
}
