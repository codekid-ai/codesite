import 'package:codekid/common.dart';
import 'package:codekid/editor/code_editor.dart';
import 'package:codekid/editor/code_snippet_editor.dart';
import 'package:codekid/editor/virtual_keyboard_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter_code_editor/flutter_code_editor.dart';
import 'package:flutter_firestore_providers/providers.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:highlight/languages/javascript.dart';
import 'package:jiffy/jiffy.dart';

import '../interop.dart';

class CodeContextPanel extends ConsumerWidget {
  final String projectId;

  CodeContextPanel(this.projectId);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    // final controller = CodeController(
    //   text: '...', // Initial code
    //   // language: Language.dart, // Language
    // );

    return Column(
        mainAxisAlignment: MainAxisAlignment.start,
        mainAxisSize: MainAxisSize.max,
        children: [
          Flexible(child: Text('Code Context')),
          Expanded(
              child: SingleChildScrollView(
                  child: ref.watch(docFP('project/${projectId}')).when(
                        loading: () => Container(),
                        error: (e, s) => Container(),
                        data: (projectDoc) =>
                            projectDoc.data()!['codeContext'] == null
                                ? Container()
                                : //Text(projectDoc.data()!['codeContext'])
                                CodeField(
                                    controller: CodeController(
                                      text: projectDoc.data()![
                                          'codeContext'], // Initial code
                                      language: javascript,
                                    ),
                                    onChanged: (v) {
                                      print('onChanged');
                                      kDB.doc('project/${projectId}').update({
                                        'codeContext': v,
                                        'lastModified': Jiffy().format()
                                      });
                                    },
                                  ),
                      )))
        ]);
  }
}
