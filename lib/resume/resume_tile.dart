import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_firestore_providers/providers.dart';

class ResumeTile extends ConsumerWidget {
  final DocumentReference searchRef;
  final TextEditingController ctrl = TextEditingController();

  ResumeTile(this.searchRef, {Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return ref.watch(docSP(searchRef.path)).when(
        loading: () => Container(),
        error: (e, s) => ErrorWidget(e),
        data: (searchDoc) => Card(
                child: Column(
              children: [
                ListTile(
                  title: Row(
                    mainAxisSize: MainAxisSize.max,
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      //Flexible(flex: 1, child: Text('vac ')),
                      Flexible(
                        flex: 1,
                        child: Text((searchDoc.data()!['jobTitle'] ?? ''),
                            style: TextStyle(fontSize: 18)),
                      ),
                    ],
                  ),
                  onTap: () {},
                )
              ],
            )));
  }
}
