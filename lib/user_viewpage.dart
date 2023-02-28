import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:codekid/pages_widget.dart';
import 'package:codekid/state/active_project.dart';

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
    return PagesWidget(ref.watch(activeProjectSNP));
  }
}
