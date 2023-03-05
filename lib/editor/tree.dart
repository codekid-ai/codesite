import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:codekid/editor/tree_node.dart';
import 'package:flutter_firestore_providers/providers.dart';

class Tree extends ConsumerWidget {
  final String projectId;
  final String pageId;
  final DocumentSnapshot project;

  const Tree(this.projectId, this.pageId, this.project);

  @override
  Widget build(BuildContext context, WidgetRef ref) =>
      ref.watch(colSP('/project/${projectId}/page/${pageId}/object')).when(
          loading: () => Container(),
          error: (e, s) => ErrorWidget(e),
          data: (objects) {
            print('tree is: ${objects.docs.map((e) => e.data()).toList()}');
            return TreeNode(
                objects.docs
                    .firstWhere((element) => element.data()['parent'] == '_'),
                objects.docs);
          });
}
