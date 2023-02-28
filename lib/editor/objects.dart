import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:codekid/editor/button_widget.dart';
import 'package:codekid/editor/text_widget.dart';
import 'package:codekid/editor/textfield_widget.dart';
import 'package:codekid/providers/firestore.dart';
import 'package:codekid/editor/object_widget.dart';
import 'package:codekid/editor/editor_page.dart';
import 'package:codekid/editor/dropdown_widget.dart';
import 'package:codekid/editor/icon_widget.dart';
import 'package:codekid/editor/radio_button_widget.dart';
import '../library/image_component.dart';
import '../library/button_component.dart';
import '../library/checkbox_component.dart';
import '../library/text_component.dart';
import '../library/radiobutton_component.dart';
import 'package:codekid/editor/image_widget.dart';
import '../library/dropdown_component.dart';
import 'checkbox_widget.dart';
import 'frame_widget.dart';

class ObjectWidget extends StatelessWidget {
  final DocumentReference<Map<String, dynamic>> objectReference;

  ObjectWidget(this.objectReference);

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<DocumentSnapshot<Map<String, dynamic>>>(
        stream: objectReference.snapshots(),
        builder: (context, snapshot) {
          if (snapshot.hasError) {
            return ErrorWidget(snapshot.error!);
          }
          if (!snapshot.hasData) {
            return Container();
          }

          final Map<String, dynamic> objectData = snapshot.data!.data()!;
          final objectType = objectData['type'];

          switch (objectType) {
            case 'button':
              return ButtonWidget(objectReference);
            case 'text':
              return TextWidget(objectReference);
            case 'checkbox':
              return CheckboxWidget(objectReference);
            case 'dropdown':
              return DropdownWidget(objectReference);
            case 'frame':
              return FrameWidget(objectReference);
            case 'textfield':
              return TextFieldWidget(objectReference);
            case 'icon':
              return IconWidget(objectReference);
            case 'radio':
              return RadioButtonWidget(objectReference);
            case 'image':
              return ImageWidget(objectReference);
            default:
              return Container();
          }
        });
  }
}

class Objects extends ConsumerWidget {
  final String projectId;
  final String pageId;

  Objects(this.projectId, this.pageId);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Stack(
        children: ref
            .watch(colSP('/project/${projectId}/page/${pageId}/object'))
            .when(
                loading: () => [Container()],
                error: (e, s) => [ErrorWidget(e)],
                data: (objects) => objects.docs
                    .map((object) => ObjectWidget(object.reference))
                    .toList()));
  }
}

// class Objects extends ConsumerWidget {
//   final String projectId;
//   final String pageId;

//   Objects(this.projectId, this.pageId);

//   @override
//   Widget build(BuildContext context, WidgetRef ref) => Stack(
//       children:
//           ref.watch(colSP('/project/${projectId}/page/${pageId}/object')).when(
//               loading: () => [Container()],
//               error: (e, s) => [ErrorWidget(e)],
//               data: (objects) => objects.docs.map<Widget>((object) {
//                     switch (object.data()['type']) {
//                       case 'button':
//                         return ButtonWidget(object.reference);
//                       case 'text':
//                         return TextWidget(object.reference);
//                       case 'checkbox':
//                         return CheckboxWidget(object.reference);
//                       case 'dropdown':
//                         return DropdownWidget(object.reference);
//                       case 'frame':
//                         return FrameWidget(object.reference);
//                       case 'textfield':
//                         return TextFieldWidget(object.reference);
//                       case 'icon':
//                         return IconWidget(object.reference);
//                       case 'radio':
//                         return RadioButtonWidget(object.reference);
//                       case 'image':
//                         return ImageWidget(object.reference);
//                     }
//                     return ObjectWidget(object.reference);
//                   }).toList()));
// }
