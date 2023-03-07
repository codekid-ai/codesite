import 'package:codekid/common.dart';
import 'package:codekid/editor/code_editor.dart';
import 'package:codekid/editor/code_snippet_editor.dart';
import 'package:codekid/editor/virtual_keyboard_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter_firestore_providers/providers.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:jiffy/jiffy.dart';

import '../interop.dart';

class OutputPanel extends ConsumerWidget {
  final String projectId;

  OutputPanel(this.projectId);

  @override
  Widget build(BuildContext context, WidgetRef ref) => true
      ? Container()
      : Container(
          // color: Colors.red,
          child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              mainAxisSize: MainAxisSize.max,
              children: [
              Flexible(child: Text('Output')),
              Expanded(
                  child: SingleChildScrollView(
                      child: Column(
                          children: ref
                              .watch(colSPfiltered(
                                  'project/${projectId}/output',
                                  orderBy: 'timestamp',
                                  isOrderDesc: true))
                              .when(
                                loading: () => [],
                                error: (e, s) => [],
                                data: (output) => output.docs
                                    .map((output) => Row(children: [
                                          SizedBox(
                                              width: 40,
                                              child: Text(
                                                output.data()['count'] == null
                                                    ? ''
                                                    : (output.data()['count'] ==
                                                            1
                                                        ? ''
                                                        : output
                                                            .data()['count']!
                                                            .toString()),
                                              )),
                                          Expanded(
                                            child: Text(
                                                output.data()['message'],
                                                style: TextStyle(
                                                    color: output.data()[
                                                                'error'] ==
                                                            null
                                                        ? Theme.of(context)
                                                            .primaryColor
                                                        : Colors.red)),
                                          )
                                        ]))
                                    .toList(),
                              ))))
            ]));
}
