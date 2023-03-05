import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:codekid/state/active_project.dart';
import '../state/generic_state_notifier.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../user_viewpage.dart';

class NewProjectDialog extends ConsumerWidget {
  final myController = TextEditingController();
  final projectTypeSNP =
      StateNotifierProvider<GenericStateNotifier<String>, String>(
          (ref) => GenericStateNotifier<String>('simple'));

  @override
  Widget build(BuildContext context, WidgetRef ref) => AlertDialog(
        title: Text('Project Title'),
        content: Column(children: [
          TextField(
            onChanged: (value) {},
            controller: myController,
            decoration: InputDecoration(hintText: "Title"),
          ),
          DropdownButton<String>(
            value: ref.watch(projectTypeSNP),
            items: ['simple', 'experimental']
                .map((e) => DropdownMenuItem<String>(
                    value: e,
                    // onTap: () {
                    //   ref.read(projectTypeSNP.notifier).value = e;
                    // },
                    child: Text(e)))
                .toList(),
            onChanged: (v) {
              print(v);
              ref.read(projectTypeSNP.notifier).value = v!;
            },
          )
        ]),
        actions: <Widget>[
          TextButton(
            style: TextButton.styleFrom(
              backgroundColor: Colors.red,
              foregroundColor: Colors.white,
            ),
            onPressed: () {
              Navigator.pop(context);
            },
            child: Text('CANCEL'),
          ),
          TextButton(
            style: TextButton.styleFrom(
              backgroundColor: Colors.green,
              foregroundColor: Colors.white,
            ),
            onPressed: () {
              FirebaseFirestore.instance.runTransaction((transaction) async {
                final project =
                    await FirebaseFirestore.instance.collection('project').add({
                  'timeCreated': FieldValue.serverTimestamp(),
                  'name': myController.text,
                  'creator': FirebaseAuth.instance.currentUser!.uid,
                  'members': [FirebaseAuth.instance.currentUser!.uid],
                  'type': ref.read(projectTypeSNP.notifier).value
                });
                FirebaseFirestore.instance
                    .collection(
                        'user/${FirebaseAuth.instance.currentUser!.uid}/project')
                    .doc(project.id)
                    .set({
                  'timeJoined': FieldValue.serverTimestamp(),
                  'name': myController.text,
                });
                FirebaseFirestore.instance
                    .doc('user/${FirebaseAuth.instance.currentUser!.uid}')
                    .set({
                  'activeProject': project.id,
                }, SetOptions(merge: true));
                // ref.read(firstDocumentIdProvider.notifier).updateId(project.id);
                ref.read(activeProjectSNP.notifier).value = project.id;
                // ignore: use_build_context_synchronously
                Navigator.pop(context);
              });
            },
            child: Text('OK'),
          ),
          //CurrentUserAvatar()
        ],
      );
}

showNewProjectDialog(BuildContext context, WidgetRef ref) {
  showDialog(
      context: context,
      builder: (context) {
        return NewProjectDialog();
      });
}
