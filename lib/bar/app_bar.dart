import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:codekid/bar/new_project_dialog.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../common.dart';
import '../main.dart';
import '../state/active_project.dart';
import '../state/theme_state_notifier.dart';
import '../user_viewpage.dart';

class MyAppBar {
  static PreferredSizeWidget getBar(BuildContext context, WidgetRef ref) {
    return AppBar(
      automaticallyImplyLeading:
          (MediaQuery.of(context).size.width < WIDE_SCREEN_WIDTH)
              ? true
              : false,
      leadingWidth:
          (MediaQuery.of(context).size.width < WIDE_SCREEN_WIDTH) ? null : 300,
      leading: Row(children: [
        Padding(
          padding: EdgeInsets.all(10),
          child: Text('CodeKid'),
        )
      ]),
      title: DropdownButton<String>(
          value: ref.watch(activeProjectSNP),
          // value: ref
          //     .watch(firstDocumentIdProvider.notifier)
          //     .getFirstDocumentId(),
          items: ref.watch(myProjectsSP).when<List<DropdownMenuItem<String>>>(
                  loading: () => [],
                  error: (e, s) => [],
                  data: (projects) => projects == null
                      ? []
                      : projects
                          .map((e) => DropdownMenuItem<String>(
                              value: e['id'],
                              onTap: () {
                                print('switching to ${e['id']}');
                                FirebaseFirestore.instance
                                    .doc(
                                        'user/${FirebaseAuth.instance.currentUser!.uid}')
                                    .set({
                                  'activeProject': e['id'],
                                }, SetOptions(merge: true));

                                ref.read(activeProjectSNP.notifier).value =
                                    e['id'];
                              },
                              child: Text(e['name'])))
                          .toList()) +
              [
                DropdownMenuItem<String>(
                  value: null,
                  onTap: () => showNewProjectDialog(context, ref),
                  child: Text('new project...'),
                )
              ],
          onChanged: (index) {}),
      actions: [
        IconButton(
            onPressed: () {
              FirebaseFirestore.instance
                  .collection('project/${ref.watch(activeProjectSNP)!}/page')
                  .add({'name': 'new'});
            },
            icon: Icon(Icons.add)),
        ThemeIconButton(),
        IconButton(
            onPressed: () {
              ref.read(isLoggedIn.notifier).value = false;
              FirebaseAuth.instance.signOut();
              // print("Signed out");
            },
            icon: Icon(Icons.exit_to_app)),
        // CurrentUserAvatar()
      ],
    );
  }
}

void setState(Null Function() param0) {}

class ThemeIconButton extends ConsumerWidget {
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    var isDarkState = ref.watch(themeStateNotifierProvider);
    return IconButton(
        tooltip: 'dark/light mode',
        onPressed: () {
          ref.read(themeStateNotifierProvider.notifier).changeTheme();
        },
        icon: Icon(isDarkState == true
            ? Icons.nightlight
            : Icons.nightlight_outlined));
  }
}
