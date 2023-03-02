import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:codekid/bar/app_bar.dart';
import 'package:codekid/common.dart';
import 'package:codekid/drawer.dart';
import 'package:codekid/editor/grid.dart';
import 'package:codekid/editor/objects.dart';
import 'package:codekid/editor/properties.dart';
import 'package:codekid/editor/selected_object_frame.dart';
import 'package:codekid/editor/selector.dart';
import 'package:codekid/editor/components_lib.dart';
import 'package:codekid/editor/tree.dart';
import 'package:codekid/library/navigation_component.dart';

import '../providers/firestore.dart';
import '../state/active_object_state_notifier.dart';
import '../state/current_selector.dart';
import '../state/generic_state_notifier.dart';
import 'coding_panel.dart';
import 'keyboard_processor.dart';

final selectedObjectSNP = StateNotifierProvider<
        GenericStateNotifier<Map<String, dynamic>?>, Map<String, dynamic>?>(
    (ref) => GenericStateNotifier<Map<String, dynamic>?>(null));

final selectedResizeObjectSNP = StateNotifierProvider<
        GenericStateNotifier<Map<String, dynamic>?>, Map<String, dynamic>?>(
    (ref) => GenericStateNotifier<Map<String, dynamic>?>(null));

final editorPageFocusNode = FocusNode();

class EditorPage extends ConsumerWidget {
  final TextEditingController searchCtrl = TextEditingController();
  final String uid = FirebaseAuth.instance.currentUser!.uid;
  final String? projectId;
  final String pageId;
  final activeCellLeft =
      StateNotifierProvider<GenericStateNotifier<int?>, int?>(
          (ref) => GenericStateNotifier<int?>(null));
  final activeCellTop = StateNotifierProvider<GenericStateNotifier<int?>, int?>(
      (ref) => GenericStateNotifier<int?>(null));

  late final selectedObjectStateNotifierProvider;

  late final AutoDisposeStreamProvider<Map<String, dynamic>?>
      //AutoDisposeStreamProviderFamily<Map<String, dynamic>?, String>
      activeObject;

  EditorPage(this.projectId, this.pageId) {
    selectedObjectStateNotifierProvider = StateNotifierProvider<
        SelectedObjectStateNotifier, Map<String, dynamic>?>((ref) {
      return SelectedObjectStateNotifier(ref.watch(activeCellLeft),
          ref.watch(activeCellTop), 'project/$projectId/page/$pageId/object');
    }, dependencies: [activeCellLeft, activeCellTop]);

    final AutoDisposeStreamProviderFamily<Map<String, dynamic>?, String>
        activeObjectFamilySP = StreamProvider.autoDispose
            .family<Map<String, dynamic>?, String>((ref, objectColPath) {
      final activeCellL = ref.watch(activeCellLeft);
      final activeCellT = ref.watch(activeCellTop);

      var objects =
          FirebaseFirestore.instance.collection(objectColPath).snapshots();

      print('check col: ${objectColPath}');

      if (activeCellL == null || activeCellT == null) {
        print('no active cell L or T');
        return Stream.value(null);
      }

      return objects.map<Map<String, dynamic>?>(
          (event) => event.docs.fold<Map<String, dynamic>?>(null, (prev, el) {
                if (prev == null) {
                  if (activeCellL >= el.data()['left'] &&
                      (activeCellL < el.data()['left'] + el.data()['width']) &&
                      activeCellT >= el.data()['top'] &&
                      (activeCellT < el.data()['top'] + el.data()['height'])) {
                    print('found item: ${el.id}');
                    return {
                      'id': el.id,
                      'data': el.data(),
                      'path': el.reference.path
                    };
                  } else {
                    return null;
                  }
                } else {
                  return prev;
                }
              }));
    });
    activeObject =
        activeObjectFamilySP('project/$projectId/page/$pageId/object');
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    print('load project editor for ${projectId}');
    return Scaffold(
      appBar: MyAppBar.getBar(context, ref),
      drawer: (MediaQuery.of(context).size.width < WIDE_SCREEN_WIDTH)
          ? TheDrawer.buildDrawer(context)
          : null,
      body: projectId == null
          ? Container()
          : ref.watch(docSP('project/${projectId}')).when(
              loading: () => Container(),
              error: (e, s) => ErrorWidget(e),
              data: (projectDoc) => KeyboardProcessor(projectId, pageId,
                  activeCellLeft, activeCellTop, activeObject,
                  child: GestureDetector(
                      onTap: () => editorPageFocusNode.requestFocus(),
                      child: Container(
                          alignment: Alignment.topLeft,
                          child: Column(
                            mainAxisSize: MainAxisSize.max,
                            mainAxisAlignment: MainAxisAlignment.start,
                            children: [
                              Text(pageId),
                              Expanded(
                                  child: Stack(
                                children: [
                                  Grid(uid),
                                  if (projectDoc.exists &&
                                      projectDoc.data()!['type'] != null &&
                                      projectDoc.data()!['type'] ==
                                          'experimental')
                                    Tree(projectId!, pageId, projectDoc)
                                  else
                                    Objects(projectId!, pageId),
                                  Selector(activeCellLeft, activeCellTop),
                                  SelectedObjectFrame(
                                      activeCellLeft, activeCellTop),
                                  // here goes navigation widget
                                  // Positioned(
                                  //   top: 0,
                                  //   right: 0,
                                  //   width: 300,
                                  //   child: Column(
                                  //     mainAxisSize: MainAxisSize.max,
                                  //     children: [
                                  //       NavigationComponent(),
                                  //       ComponentsLibWidget(projectId!, pageId),
                                  //       Properties(activeObject),
                                  //     ],
                                  //   ),
                                  // ),
                                  Positioned(
                                    // top: 0,
                                    top: MediaQuery.of(context).size.height -
                                        600,
                                    left: 0,
                                    right: 0,
                                    bottom: 0,
                                    child: 
                                        CodingPanel(projectId!, pageId),
                                  )
                                ],
                              )),
                            ],
                          ))))),
    );
  }
}
