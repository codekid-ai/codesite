import 'package:codekid/bar/app_bar.dart';
import 'package:codekid/common.dart';
import 'package:codekid/drawer.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_firestore_providers/providers.dart';
import 'ckgame_widget.dart';
import 'code_context_panel.dart';
import 'coding_panel.dart';
import 'output_panel.dart';

class EditorPage extends ConsumerWidget {
  final TextEditingController searchCtrl = TextEditingController();
  final String uid = FirebaseAuth.instance.currentUser!.uid;
  final String projectId;
  FocusNode focusNode = FocusNode();
  FocusNode keyboardFocusNode = FocusNode();

  EditorPage(this.projectId);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    print('load project editor for ${projectId}');

    return Scaffold(
      appBar: MyAppBar.getBar(context, ref),
      drawer: (MediaQuery.of(context).size.width < WIDE_SCREEN_WIDTH)
          ? TheDrawer.buildDrawer(context)
          : null,
      body: ref.watch(docFP('project/${projectId}')).when(
          loading: () => Container(),
          error: (e, s) => ErrorWidget(e),
          data: (projectDoc) => Stack(
                children: [
                  Positioned(
                      left: 0,
                      top: 0,
                      width: MediaQuery.of(context).size.width / 2,
                      height: MediaQuery.of(context).size.height / 2,
                      child: ClipRect(
                          child: Container(
                              width: MediaQuery.of(context).size.width / 2,
                              height: MediaQuery.of(context).size.height / 2,
                              child: CKGameWidget(projectId: projectId)))),
                  Positioned(
                    top: 0,
                    left: MediaQuery.of(context).size.width / 2,
                    right: 0,
                    bottom: 0,
                    child: Container(
                        width: MediaQuery.of(context).size.width / 2,
                        height: MediaQuery.of(context).size.height / 2,
                        child: CodingPanel(projectId, projectDoc)),
                  ),
                  Positioned(
                    top: MediaQuery.of(context).size.height / 2,
                    left: 0,
                    right: 0,
                    bottom: 0,
                    child: Container(
                        width: MediaQuery.of(context).size.width / 2,
                        height: MediaQuery.of(context).size.height / 2,
                        child: OutputPanel(projectId)),
                  ),
                  Positioned(
                    top: MediaQuery.of(context).size.height / 2,
                    left: MediaQuery.of(context).size.width / 2,
                    right: 0,
                    bottom: 0,
                    child: Container(
                        width: MediaQuery.of(context).size.width / 2,
                        height: MediaQuery.of(context).size.height / 2,
                        child: CodeContextPanel(projectId)),
                  ),
                ],
              )),
    );
  }
}
