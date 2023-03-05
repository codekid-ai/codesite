import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:flutter_firestore_providers/providers.dart';

class CodeViewer extends ConsumerWidget {
  final DocumentReference docRef;

  CodeViewer({required this.docRef, super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) => Container(
        child: ref.watch(docSP(docRef.path)).when(
            loading: () => Text('loading'),
            error: (e, s) => Text('error'),
            data: (doc) => Text(doc['code'])),
      );
}
