import 'package:codekid/common.dart';
import 'package:codekid/editor/code_snippet_editor.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../providers/firestore.dart';

class CodingPanel extends ConsumerWidget {
  final String projectId;
  final String id;

  CodingPanel(this.projectId, this.id);

  @override
  Widget build(BuildContext context, WidgetRef ref) => Column(
        mainAxisAlignment: MainAxisAlignment.start,
        mainAxisSize: MainAxisSize.max,
        children: [
          Flexible(child: Text('Coding')),
          Expanded(
              child:
                  //     TabBar(
                  //   controller: TabController(length: 2, vsync: this),
                  //   tabs: [Text('one'), Text('two')],
                  // ))
                  buildTabsFromCollectionWatch(context, ref))
        ],
      );

  Widget buildTabsFromCollectionWatch(BuildContext context, WidgetRef ref) {
    final List<DS> myTabs = ref
        .watch(colSP('project/${projectId}/page/${id}/code'))
        .when(
            loading: () => [],
            error: (e, s) => [],
            data: (comps) => comps.docs.map((e) => e).toList());
    return DefaultTabController(
      length: myTabs.length,
      child: Column(
        children: [
          TabBar(
            tabs: myTabs.map((t) => Tab(text: t['name'])).toList(),
          ),
          Expanded(
            child: TabBarView(
              children: myTabs
                  .map((t) => CodeSnippetEditor(docRef: t.reference))
                  .toList(),
            ),
          ),
        ],
      ),
    );
  }

  // Widget buildTabs() {
  //   final myTabs = [
  //     Tab(text: 'Tab 1'),
  //     Tab(text: 'Tab 2'),
  //     Tab(text: 'Tab 3'),
  //   ];

  //   return DefaultTabController(
  //     length: myTabs.length,
  //     child: Column(
  //       children: [
  //         TabBar(
  //           tabs: myTabs,
  //         ),
  //         Expanded(
  //           child: TabBarView(
  //             children: [
  //               Container(
  //                 child: Text('Tab 1 content'),
  //               ),
  //               Container(
  //                 child: Text('Tab 2 content'),
  //               ),
  //               Container(
  //                 child: Text('Tab 3 content'),
  //               ),
  //             ],
  //           ),
  //         ),
  //       ],
  //     ),
  //   );
  // }
}
