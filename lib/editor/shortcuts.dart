import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:codekid/common.dart';
import 'package:codekid/editor/editor_page.dart';
import 'package:codekid/editor/keyboard_processor.dart';
import 'package:codekid/state/current_selector.dart';
import '../library/image_component.dart';
import '../library/button_component.dart';
import '../library/checkbox_component.dart';
import '../library/frame_component.dart';
import '../library/icon_component.dart';
import '../library/text_component.dart';
import '../providers/firestore.dart';
import '../library/dropdown_component.dart';
import '../library/radiobutton_component.dart';

class ShortcutsWidget extends ConsumerWidget {
  final String projectId;
  final String id;

  ShortcutsWidget(this.projectId, this.id);

  @override
  Widget build(BuildContext context, WidgetRef ref) => Stack(children: [
        // Positioned(right: 400, top: 0, child: Text('Shortcuts')),
        // Positioned(
        //     right: 400,
        //     top: 20,
        //     child: ref.watch(activeObjectSP).when(
        //         loading: () => Text(''),
        //         error: (e, s) => Text('error'),
        //         data: (doc) => Text('Active Element: ${doc!['id'] ?? 'N/A'}'))),
        Positioned(
          // right: 0,
          // top: 0,
          child: Container(
              //decoration: cellBorderSelected,
              color: Colors.black, // Color.fromARGB(255, 50, 50, 50),
              width: 400,
              height: 1000,
              child: Column(
                children: [
                  Flexible(child: Text('Components')),
                  Expanded(
                      child: ListView(
                    children: ref.watch(colSP('lib')).when(
                        loading: () => [],
                        error: (e, s) => [],
                        data: (comps) => comps.docs.map((compDoc) {
                              print('compDoc: ${compDoc.data()}');
                              switch (compDoc.data()['type']) {
                                case 'button':
                                  return ButtonComponent();
                                case 'text':
                                  return TextComponent();
                                case 'checkbox':
                                  return CheckboxComponent();
                                case 'dropdown':
                                  return DropdownComponent();
                                case 'frame':
                                  return FrameComponent();
                                case 'icon':
                                  return IconComponent();
                                case 'radio':
                                  return RadioButtonComponent();
                                case 'image':
                                  return DropdownComponent();
                              }
                              return Text('unknown');
                            }).toList()

                        // ListTile(
                        //     title: Container(
                        //       decoration: cellBorder,
                        //       width: 25,
                        //       height: 25,
                        //     ),
                        //     trailing: Text('Shift+b'),
                        //     onTap: () => FirebaseFirestore.instance
                        //             .collection(
                        //                 '/project/${projectId}/page/${id}/object')
                        //             .add({
                        //           'type': 'box',
                        //           'width': 1,
                        //           'height': 1,
                        //           'top': ref.read(activeCellTop.notifier).value,
                        //           'left': ref.read(activeCellLeft.notifier).value
                        //         })),
                        // ListTile(
                        //     title: Container(
                        //       decoration: cellBorder,
                        //       width: 25,
                        //       height: 25,
                        //     ),
                        //     trailing: Text('Shift+f'),
                        //     onTap: () => FirebaseFirestore.instance
                        //             .collection(
                        //                 '/project/${projectId}/page/${id}/object')
                        //             .add({
                        //           'type': 'frame',
                        //           'width': 1,
                        //           'height': 1,
                        //           'top': ref.read(activeCellTop.notifier).value,
                        //           'left': ref.read(activeCellLeft.notifier).value
                        //         })),

                        ),
                  ))
                ],
              )),
        )
      ]);
}
