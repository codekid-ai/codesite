import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_colorpicker/flutter_colorpicker.dart';
import 'package:flutter_iconpicker/flutter_iconpicker.dart';

class PropertiesWidget extends ConsumerWidget {
  final String path;
  final String type;

  PropertiesWidget(this.path, this.type);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Column(children: [
      Text('props: ${type}'),
      Column(
          children: getPropsByType()
              .map((prop) => Row(
                    children: [
                      Text(prop['name']),
                      SizedBox(
                          width: 50,
                          child: {
                            'text': TextField(
                              onSubmitted: (v) {
                                FirebaseFirestore.instance
                                    .doc(path)
                                    .update({prop['name']: v});
                              },
                            ),
                            'color': PopupMenuButton(
                              itemBuilder: (context) => [
                                PopupMenuItem(
                                  child: SingleChildScrollView(
                                    child: ColorPicker(
                                      pickerColor: Colors.red,
                                      onColorChanged: (color) {
                                        FirebaseFirestore.instance
                                            .doc(path)
                                            .update({
                                          prop['name']: color.value.toString()
                                        });
                                      },
                                      paletteType: PaletteType.hsv,
                                      enableAlpha: true,
                                      displayThumbColor: true,
                                      colorPickerWidth: 300.0,
                                      pickerAreaHeightPercent: 0.7,
                                      pickerAreaBorderRadius:
                                          const BorderRadius.only(
                                        topLeft: Radius.circular(2.0),
                                        topRight: Radius.circular(2.0),
                                      ),
                                      portraitOnly: true,
                                    ),
                                  ),
                                )
                              ],
                            ),
                            'icon': ElevatedButton(
                              child: Icon(Icons.add),
                              onPressed: () async {
                                IconData? iconData =
                                    await FlutterIconPicker.showIconPicker(
                                  context,
                                  iconPackModes: [IconPack.material],
                                );
                                FirebaseFirestore.instance.doc(path).update({
                                  prop['name']: iconData!.codePoint.toString()
                                });
                              },
                            ),
                            'boolean': DropdownButton(
                              items: const [
                                DropdownMenuItem(
                                    value: true, child: Text('true')),
                                DropdownMenuItem(
                                    value: false, child: Text('false')),
                              ],
                              onChanged: (v) {
                                FirebaseFirestore.instance
                                    .doc(path)
                                    .update({prop['name']: v});
                              },
                            ),
                          }[prop['type']])
                    ],
                  ))
              // ListTile(
              //       leading: Text(prop['name']),
              //       title: TextField(
              //         onSubmitted: (v) {},
              //       ),
              //     ))
              .toList())
    ]);

    // return ObjectWidget(object.reference);
  }

  List<dynamic> getPropsByType() {
    switch (type) {
      case 'button':
        return [
          {'name': 'text', 'type': 'text'}
        ];
      case 'text':
        return [
          {'name': 'text', 'type': 'text'}
        ];
      case 'checkbox':
        return [
          {'name': 'text', 'type': 'text'}
        ];
      case 'frame':
        return [
          {'name': 'text', 'type': 'text'}
        ];
      case 'dropdown':
        return [
          {'name': 'text', 'type': 'text'},
          {'name': 'font_color', 'type': 'color'},
          {'name': 'background_color', 'type': 'color'},
          {'name': 'border_color', 'type': 'color'},
        ];
      case 'icon':
        return [
          {'name': 'icon', 'type': 'icon'},
          {'name': 'icon_color', 'type': 'color'},
        ];
      case 'radio':
        return [
          {'name': 'text', 'type': 'text'},
          {'name': 'checked', 'type': 'boolean'}
        ];
    }
    return [];
  }
}
