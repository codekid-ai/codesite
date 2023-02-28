import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:codekid/editor/properties/properties_widget.dart';
import 'package:codekid/state/current_selector.dart';

import 'editor_page.dart';

final FocusNode propertiesFocusNode = FocusNode();

class Properties extends ConsumerWidget {
  AutoDisposeStreamProvider<Map<String, dynamic>?> activeObject;

  Properties(this.activeObject);

  @override
  Widget build(BuildContext context, WidgetRef ref) => GestureDetector(
      onTap: () {
        editorPageFocusNode.unfocus();
        propertiesFocusNode.requestFocus();
      },
      child: RawKeyboardListener(
          focusNode: propertiesFocusNode,
          autofocus: true,
          onKey: (event) async {
            print('properties key event ${event}');
            if (event is RawKeyDownEvent) {
              if (event.logicalKey.keyLabel == 'Enter') {
                print('move focus back to grid');
                propertiesFocusNode.unfocus();
                editorPageFocusNode.requestFocus();
              }
            }
          },
          child: Stack(children: [
            Positioned(
                // right: 0,
                // top: 500,
                child: Container(
                    //decoration: cellBorderSelected,
                    color: Colors.black, // Color.fromARGB(255, 50, 50, 50),
                    width: 500,
                    height: 1000,
                    child: Column(children: [
                      Text('Properties'),
                      ref.watch(activeObject).value == null
                          ? Text('selected: none')
                          : Text('selected: ${ref.watch(activeObject).value}'),
                      ref.watch(activeObject).value == null
                          ? Container()
                          : PropertiesWidget(
                              ref.watch(activeObject).value!['path'],
                              ref.watch(activeObject).value!['data']['type'])
                    ])))
          ])));
}
