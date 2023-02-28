import 'dart:html';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:codekid/common.dart';
import 'package:codekid/editor/object_widget.dart';

import 'button_widget.dart';
import 'objects.dart';

class TreeNode extends ConsumerWidget {
  final List<DocumentSnapshot<Map<String, dynamic>>> docList;
  //final Map<String, DocumentSnapshot<Map<String, dynamic>>> docMap;
  final DocumentSnapshot<Map<String, dynamic>> nodeDoc;
  const TreeNode(this.nodeDoc, this.docList);

  @override
  Widget build(BuildContext context, WidgetRef ref) =>
      //THIS WORKS:
      // Stack(children: [
      //   Positioned(top: 50, left: 50, child: Text('parent')),
      //   Stack(children: [
      //     Stack(children: [
      //       Positioned(top: 150, left: 150, child: Text('child')),
      //       Stack(children: [
      //         Positioned(top: 200, left: 200, child: Text('grand child')),
      //         Stack(children: [
      //           Positioned(
      //               top: 200, left: 200, child: Text('grand-grand child'))
      //         ])
      //       ])
      //     ]),
      //     Stack(children: [
      //       Positioned(top: 250, left: 200, child: Text('child 2')),
      //       Stack(children: [
      //         Positioned(top: 250, left: 250, child: Text('grand child 2')),
      //         Stack(children: [
      //           Positioned(
      //               top: 250, left: 250, child: Text('grand-grand child 2'))
      //         ])
      //       ])
      //     ])
      //   ])
      // ]);
      Stack(children: [
        Positioned(
            top: (nodeDoc.data()!['top'] as double) * CELL_SIZE,
            left: (nodeDoc.data()!['left'] as double) * CELL_SIZE,
            child: ObjectWidget(
                nodeDoc.reference)), // ObjectWidget(nodeDoc.reference)),
        if (nodeDoc.data()!['children'] != null)
          ...nodeDoc
              .data()!['children']
              .map<Widget>((child) => TreeNode(
                  docList.firstWhere((element) => element.id == child,
                      orElse: () => throw Error()),
                  docList))
              .toList()
      ]);
}
