import 'package:codekid/editor/virtual_keyboard_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:providers/firestore.dart';
import '../common.dart';
import '../interop.dart';
import 'code_editor.dart';

class CodingPanel extends ConsumerWidget {
  final String projectId;
  final DS projectDoc;

  CodingPanel(this.projectId, this.projectDoc);

  @override
  Widget build(BuildContext context, WidgetRef ref) => Padding(
      padding: EdgeInsets.all(8),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        mainAxisSize: MainAxisSize.max,
        children: [
          Flexible(
              child: Row(
            children: [
              Text('Coding'),
              ElevatedButton(
                  onPressed: () {
                    showDialog(
                      context: context,
                      builder: (context) => VirtualKeyboardWidget(
                          kDB.collection('project/${projectId}/code')),
                    );
                  },
                  child: Text('Add Code Snippet')),
            ],
          )),
          // ElevatedButton(
          //     onPressed: () async {
          //       print('register events');
          //       final QS codes =
          //           await kDB.collection('project/${projectId}/code').get();
          //       codes.docs.forEach((e) {
          //         print(e.data());
          //         registerEvent(e.data()['name'], e.data()['code']);
          //       });
          //     },
          //     child: Text('load')),

          Expanded(
              child:
                  //     TabBar(
                  //   controller: TabController(length: 2, vsync: this),
                  //   tabs: [Text('one'), Text('two')],
                  // ))
                  buildTabsFromCollectionWatch(context, ref)),
          // ref.watch(colSP('project/${projectId}/page/${id}/code')).when(
          //     loading: () => Text('loading'),
          //     error: (e, s) => Text('error'),
          //     data: (comps) => Column(
          //           children: comps.docs
          //               .map(
          //                 (e) => CodeEditor(kDB.doc(
          //                     'project/${projectId}/page/${id}/code/${e.id}')),
          //               )
          //               .toList(),

          // ))
        ],
      ));

  Widget buildTabsFromCollectionWatch(BuildContext context, WidgetRef ref) {
    final List<DS> myTabs = ref
        .watch(colSPfiltered('project/${projectId}/code',
            distinct: (a, b) => a.size == b.size))
        .when(
            loading: () => [],
            error: (e, s) => [],
            data: (comps) => comps.docs.map((e) => e).toList());
    return DefaultTabController(
      length: myTabs.length,
      child: Column(
        mainAxisSize: MainAxisSize.max,
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          TabBar(
            tabs: myTabs.map((t) => Tab(text: t['handler'])).toList(),
          ),
          Expanded(
            child: TabBarView(
              children: myTabs
                  .map((t) => CodeEditor(
                      kDB.doc('project/${projectId}/code/${t.id}'), projectDoc))
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
