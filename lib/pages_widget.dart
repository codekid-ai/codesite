import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:codekid/providers/firestore.dart';
import 'package:codekid/resume/user_resume_page.dart';
import 'package:codekid/editor/editor_page.dart';
import 'package:codekid/state/active_project.dart';

class PagesWidget extends ConsumerWidget {
  final String? projectId;
  const PagesWidget(this.projectId, {super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return ref.watch(colSP('project/${projectId}/page')).when(
        loading: () => Container(),
        error: (e, s) => ErrorWidget(e),
        data: (pages) => DefaultTabController(
            initialIndex: 0,
            length: pages.size,
            child: Navigator(
              onGenerateRoute: (RouteSettings settings) {
                print('onGenerateRoute: ${settings}');
                // if (settings.name == '/' || settings.name == 'search') {
                if (settings.name == '/' || settings.name == 'page') {
                  return PageRouteBuilder(
                      pageBuilder: (_, __, ___) => settings.arguments == null
                          ? EditorPage(
                              projectId,
                              pages.size > 0
                                  ? (ref.watch(activeProjectPageSNP) == null
                                      ? pages.docs.first.id
                                      : ref.watch(activeProjectPageSNP)!)
                                  : 'no page found')
                          : EditorPage(projectId,
                              (settings.arguments! as dynamic)['id']));
                }
                if (settings.name == 'resumes') {
                  return PageRouteBuilder(
                      pageBuilder: (_, __, ___) => UserResumePage());
                } else {
                  throw 'no page to show';
                }
              },
            )));
  }
}
