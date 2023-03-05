// import 'package:cloud_firestore/cloud_firestore.dart';
// import 'package:flutter/material.dart';
// import 'package:flutter/services.dart';
// import 'package:flutter_riverpod/flutter_riverpod.dart';
// import 'package:codekid/common.dart';
// import 'package:codekid/editor/properties.dart';
// import 'package:codekid/state/generic_state_notifier.dart';
// import '../state/current_selector.dart';
// import 'editor_page.dart';

// class KeyboardProcessor extends ConsumerWidget {
//   final Widget child;
//   final String? projectId;
//   final String pageId;
//   final AutoDisposeStreamProvider<Map<String, dynamic>?> activeObject;
//   final activeCellTop;
//   //  = StateNotifierProvider<GenericStateNotifier<int?>, int?>(
//   //     (ref) => GenericStateNotifier<int?>(null));
//   final activeCellLeft;
//   //  =
//   //     StateNotifierProvider<GenericStateNotifier<int?>, int?>(
//   //         (ref) => GenericStateNotifier<int?>(null));

//   KeyboardProcessor(this.projectId, this.pageId, this.activeCellLeft,
//       this.activeCellTop, this.activeObject,
//       {required this.child});

//   @override
//   Widget build(BuildContext context, WidgetRef ref) => RawKeyboardListener(
//       focusNode: editorPageFocusNode,
//       autofocus: true,
//       onKey: (event) async {
//         //print('grid key event ${event}');
//         // print(
//         //     'current selection: ${ref.read(activeObject).value} for ${'project/$projectId/page/$pageId/object'}');

//         if (event is RawKeyUpEvent) {
//           //print('unpressed : ${event}');
//           // unlock object from moving
//           if (event.logicalKey.keyLabel == "Shift Left") {
//             print('unpressed : ${ref.read(selectedObjectSNP)}');

//             if (ref.read(selectedObjectSNP) != null) {
//               String path =
//                   '/project/${projectId}/page/${pageId}/object/${ref.read(selectedObjectSNP)!['id']}';
//               print(' writing ${ref.read(activeCellTop)} to ${path}');
//               // TODO: Figure out why this doesn't work!
//               // await FirebaseFirestore.instance.doc(path).update({
//               //   'top': ref.read(activeCellTop),
//               //   'left': ref.read(activeCellLeft),
//               // });
//               await FirebaseFirestore.instance.doc(path).set({
//                 'top': ref.read(activeCellTop),
//                 'left': ref.read(activeCellLeft),
//               }, SetOptions(merge: true));
//               ref.read(selectedObjectSNP.notifier).value = null;
//             }
//           }
//           return;
//         }

//         if (event is RawKeyUpEvent) {
//           //print('unpressed : ${event}');
//           // unlock object from resizing
//           if (event.logicalKey.keyLabel == "Alt Left") {
//             print('unpressed : ${ref.read(selectedObjectSNP)}');

//             if (ref.read(selectedObjectSNP) != null) {
//               FirebaseFirestore.instance
//                   .doc(
//                       '/project/${projectId}/page/${pageId}/object/${ref.read(selectedResizeObjectSNP)!['id']}')
//                   .set(
//                       {
//                     'height': ref.read(activeCellTop),
//                     'width': ref.read(activeCellLeft),
//                   },
//                       SetOptions(
//                         merge: true,
//                       ));
//               ref.read(selectedResizeObjectSNP.notifier).value = null;
//             }
//           }
//           return;
//         }

//         if (event is RawKeyDownEvent) {
//           //   print(
//           //       'key pressed: ${event.isKeyPressed(LogicalKeyboardKey.metaLeft)}');

//           //   if (event.logicalKey.keyLabel == "Shift Left") {
//           //     print('pressed shift: ${ref.read(selectedObjectSNP)}');

//           //     if (ref.read(selectedObjectSNP) != null) {
//           //       FirebaseFirestore.instance
//           //           .doc(
//           //               '/project/${projectId}/page/${pageId}/object/${ref.read(selectedObjectSNP)!['id']}')
//           //           .update({
//           //         'top': ref.read(activeCellTop),
//           //         'left': ref.read(activeCellLeft),
//           //       });
//           //       ref.read(selectedObjectSNP.notifier).value = null;
//           //     }
//           //   }

//           //moving selector only
//           if (!event.isKeyPressed(LogicalKeyboardKey.shiftLeft) &&
//               !event.isKeyPressed(LogicalKeyboardKey.altLeft)) {
//             ref.read(activeCellTop.notifier).value =
//                 (ref.read(activeCellTop.notifier).value ?? 0) +
//                     (event.logicalKey.keyLabel == 'Arrow Down'
//                         ? 1
//                         : (event.logicalKey.keyLabel == 'Arrow Up'
//                             ? (ref.read(activeCellTop.notifier).value <= 0
//                                 ? 0
//                                 : -1)
//                             : 0));

//             ref.read(activeCellLeft.notifier).value =
//                 (ref.read(activeCellLeft.notifier).value ?? 0) +
//                     (event.logicalKey.keyLabel == 'Arrow Right'
//                         ? 1
//                         : (event.logicalKey.keyLabel == 'Arrow Left'
//                             ? (ref.read(activeCellLeft.notifier).value <= 0
//                                 ? 0
//                                 : -1)
//                             : 0));
//           }

//           if (event.logicalKey.keyLabel == 'Enter') {
//             print('move focus to properties');
//             editorPageFocusNode.unfocus();
//             propertiesFocusNode.requestFocus();
//           }

//           if (event.isKeyPressed(LogicalKeyboardKey.shiftLeft) &&
//               (['B', 'C', 'F', 'T', 'E'].indexOf(event.logicalKey.keyLabel) >
//                   -1)) {
//             // print('add object');

//             final objectRef = await FirebaseFirestore.instance
//                 .collection('/project/${projectId}/page/${pageId}/object')
//                 .add({
//               'width': 2,
//               'height': 1,
//               'top': ref.read(activeCellTop.notifier).value ?? 0,
//               'left': ref.read(activeCellLeft.notifier).value ?? 0,
//               'type': objectTypeByKey(event.logicalKey.keyLabel),
//               'parent': ref.read(selectedObjectSNP) != null
//                   ? ref.read(selectedObjectSNP)!['id']
//                   : '_',
//             });
//             if (ref.read(selectedObjectSNP) != null) {
//               print(
//                   'adding child to parent at ${'/project/${projectId}/page/${pageId}/object/${ref.read(selectedObjectSNP)!['id']}'}');
//               FirebaseFirestore.instance
//                   .doc(
//                       '/project/${projectId}/page/${pageId}/object/${ref.read(selectedObjectSNP)!['id']}')
//                   .set({
//                 'children': FieldValue.arrayUnion([objectRef.id])
//               }, SetOptions(merge: true));
//             }
//           }
//           if (event.isKeyPressed(LogicalKeyboardKey.shiftLeft) &&
//               event.logicalKey.keyLabel == 'D') {
//             // print('add object');
//             FirebaseFirestore.instance
//                 .collection('/project/${projectId}/page/${pageId}/object')
//                 .add({
//               'width': 4,
//               'height': 2,
//               'top': ref.read(activeCellTop.notifier).value,
//               'left': ref.read(activeCellLeft.notifier).value,
//               'type': 'dropdown'
//             });
//           }
//           if (event.isKeyPressed(LogicalKeyboardKey.shiftLeft) &&
//               event.logicalKey.keyLabel == 'Q') {
//             // print('add object');
//             FirebaseFirestore.instance
//                 .collection('/project/${projectId}/page/${pageId}/object')
//                 .add({
//               'width': 1,
//               'height': 1,
//               'top': ref.read(activeCellTop.notifier).value,
//               'left': ref.read(activeCellLeft.notifier).value,
//               'type': 'icon'
//             });
//           }
//           if (event.isKeyPressed(LogicalKeyboardKey.shiftLeft) &&
//               event.logicalKey.keyLabel == 'O') {
//             // temporary set to "L" key
//             FirebaseFirestore.instance
//                 .collection('/project/${projectId}/page/${pageId}/object')
//                 .add({
//               'width': 3,
//               'height': 1,
//               'top': ref.read(activeCellTop.notifier).value,
//               'left': ref.read(activeCellLeft.notifier).value,
//               'type': 'radio'
//             });
//           }

//           if (event.isKeyPressed(LogicalKeyboardKey.shiftLeft) &&
//               event.logicalKey.keyLabel == 'U') {
//             // print('add object');
//             FirebaseFirestore.instance
//                 .collection('/project/${projectId}/page/${pageId}/object')
//                 .add({
//               'width': 1,
//               'height': 1,
//               'top': ref.read(activeCellTop.notifier).value,
//               'left': ref.read(activeCellLeft.notifier).value,
//               'type': 'image'
//             });
//           }

//           // lock object for moving
//           if (event.isKeyPressed(LogicalKeyboardKey.shiftLeft) &&
//               event.logicalKey.keyLabel == "Shift Left") {
//             // print(event);
//             if (ref.read(activeObject).value != null) {
//               print('set selectedObject to ${ref.read(activeObject).value}');
//               ref.read(selectedObjectSNP.notifier).value =
//                   ref.read(activeObject).value;
//             }
//           }

//           // lock object for resizing
//           if ( //event.isKeyPressed(LogicalKeyboardKey.shiftLeft) &&
//               event.logicalKey.keyLabel == "Alt Left") {
//             print('lock for resizing');
//             if (ref.read(activeObject).value != null) {
//               // print('set selectedObject to ${ref.read(activeObject).value}');
//               ref.read(selectedResizeObjectSNP.notifier).value =
//                   ref.read(activeObject).value;
//             }
//           }

//           // move object
//           if (event.isKeyPressed(LogicalKeyboardKey.shiftLeft) &&
//               event.logicalKey.keyLabel == 'Arrow Left') {
//             ref.read(activeCellLeft.notifier).value =
//                 ref.read(activeCellLeft.notifier).value <= 0
//                     ? 0
//                     : (ref.read(activeCellLeft.notifier).value ?? 0) + -1;
//           }
//           if (event.isKeyPressed(LogicalKeyboardKey.shiftLeft) &&
//               event.logicalKey.keyLabel == 'Arrow Right') {
//             ref.read(activeCellLeft.notifier).value =
//                 (ref.read(activeCellLeft.notifier).value ?? 0) + 1;
//           }

//           if (event.isKeyPressed(LogicalKeyboardKey.shiftLeft) &&
//               event.logicalKey.keyLabel == 'Arrow Up') {
//             ref.read(activeCellTop.notifier).value =
//                 ref.read(activeCellTop.notifier).value <= 0
//                     ? 0
//                     : ((ref.read(activeCellTop.notifier).value ?? 0) + -1);
//           }
//           if (event.isKeyPressed(LogicalKeyboardKey.shiftLeft) &&
//               event.logicalKey.keyLabel == 'Arrow Down') {
//             ref.read(activeCellTop.notifier).value =
//                 (ref.read(activeCellTop.notifier).value ?? 0) + 1;
//           }

//           // resize object
//           if (event.isKeyPressed(LogicalKeyboardKey.altLeft)) {
//             if (event.logicalKey.keyLabel == 'Arrow Right') {
//               print(
//                   'resize object at: /project/${projectId}/page/${pageId}/object/${ref.read(selectedResizeObjectSNP)}');
//               await FirebaseFirestore.instance
//                   .doc(
//                       '/project/${projectId}/page/${pageId}/object/${ref.read(selectedResizeObjectSNP)!["id"]}')
//                   .set({'width': FieldValue.increment(1)},
//                       SetOptions(merge: true));
//             }
//             if (event.logicalKey.keyLabel == 'Arrow Left') {
//               print(
//                   'resize object at: /project/${projectId}/page/${pageId}/object/${ref.read(selectedResizeObjectSNP)}');
//               await FirebaseFirestore.instance
//                   .doc(
//                       '/project/${projectId}/page/${pageId}/object/${ref.read(selectedResizeObjectSNP)!["id"]}')
//                   .set({'width': FieldValue.increment(-1)},
//                       SetOptions(merge: true));
//             }
//             if (event.logicalKey.keyLabel == 'Arrow Down') {
//               print(
//                   'resize object at: /project/${projectId}/page/${pageId}/object/${ref.read(selectedResizeObjectSNP)}');
//               await FirebaseFirestore.instance
//                   .doc(
//                       '/project/${projectId}/page/${pageId}/object/${ref.read(selectedResizeObjectSNP)!["id"]}')
//                   .set({'height': FieldValue.increment(1)},
//                       SetOptions(merge: true));
//             }
//             if (event.logicalKey.keyLabel == 'Arrow Up') {
//               print(
//                   'resize object at: /project/${projectId}/page/${pageId}/object/${ref.read(selectedResizeObjectSNP)}');
//               await FirebaseFirestore.instance
//                   .doc(
//                       '/project/${projectId}/page/${pageId}/object/${ref.read(selectedResizeObjectSNP)!["id"]}')
//                   .set({'height': FieldValue.increment(-1)},
//                       SetOptions(merge: true));
//             }
//           }
//         }
//       },
//       child: child);
// }
