import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:codekid/state/active_project.dart';
import 'bar/new_project_dialog.dart';
import 'common.dart';
import 'editor/editor_page.dart';

class ProjectSelectorWidget extends ConsumerWidget {
  const ProjectSelectorWidget({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    // return ref.watch(activeProjectSNP) == null
    //     ? TextButton(
    //         onPressed: () => FirebaseFirestore.instance
    //             .collection('project')
    //             .add({'name': 'new project'}),
    //         child: Text('Add Project'))
    //:
    // return
    //   PagesWidget(ref.watch(activeProjectSNP))
    return ref.watch(projectsStreamProvider).when(
        loading: () => CircularProgressIndicator(),
        error: (error, stackTrace) => Text('Error: $error'),
        data: (documents) => ref.watch(activeProjectSNP) == null
            ? TextButton(
                onPressed: () => showNewProjectDialog(context, ref),
                child: Text('Add Project'))
            :
            //PagesWidget(ref.watch(activeProjectSNP)!)
            Navigator(
                onGenerateRoute: (RouteSettings settings) {
                  print('onGenerateRoute: ${settings}');

                  if (settings.name == '/' || settings.name == 'page') {
                    return PageRouteBuilder(
                        pageBuilder: (_, __, ___) => settings.arguments == null
                            ? EditorPage(ref.watch(activeProjectSNP)!)
                            : EditorPage(ref.watch(activeProjectSNP)!));
                  } else {
                    throw 'no page to show';
                  }
                },
              ));
  }
}

// Define a state notifier provider that holds the ID of the first document
// final firstDocumentIdProvider =
//     StateNotifierProvider((ref) => FirstDocumentIdNotifier());

// Define a stream provider that reads a collection of documents from Firestore
final projectsStreamProvider = StreamProvider.autoDispose(
  (ref) {
    final userDoc = kDB.doc('user/${kUSR.currentUser!.uid}');
    final collection = kDB.collection('user/${kUSR.currentUser!.uid}/project');

    return userDoc.snapshots().map((snapshot) {
      final data = snapshot.data();
      if (data != null && data['activeProject'] != null) {
        // print('found activeProject: ${data['activeProject']}');
        ref.read(activeProjectSNP.notifier).value = data['activeProject'];
      } else {
        return collection.snapshots().map((snapshot) {
          final documents = snapshot.docs;
          if (documents.isNotEmpty) {
            //ref.read(firstDocumentIdProvider.notifier).updateId(firstDocumentId);
            ref.read(activeProjectSNP.notifier).value = documents.first.id;
          }
          return documents;
        });
      }
      return null;
    });
  },
);

// Define a state notifier that holds the ID of the first document
class FirstDocumentIdNotifier extends StateNotifier<String?> {
  FirstDocumentIdNotifier() : super(null);

  void updateId(String id) {
    state = id;
  }

  String? getFirstDocumentId() {
    return state;
  }
}
