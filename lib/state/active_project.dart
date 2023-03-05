import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:codekid/state/active_user.dart';
import 'package:flutter_firestore_providers/providers.dart';

import 'generic_state_notifier.dart';

final myProjectsSP = StreamProvider<List<Map<String, dynamic>>?>((ref) {
  return ref.watch(authStateChangesSP).when(data: (user) {
    if (user == null) return Stream.value(null);
    return FirebaseFirestore.instance
        .collection('user/${FirebaseAuth.instance.currentUser!.uid}/project')
        .snapshots()
        .map((projects) => projects.docs
            .map((e) => {
                  'id': e.id,
                  'name': e.data()['name'],
                })
            .toList());
  }, error: (e, s) {
    return Stream.value(null);
  }, loading: () {
    return Stream.value(null);
  });
});

final activeProjectSNP =
    StateNotifierProvider<GenericStateNotifier<String?>, String?>((ref) {
  return GenericStateNotifier<String?>(null);
});

final activeProjectSP = StreamProvider<String?>((ref) {
  print('activeProjectSP init');
  return ref.watch(authStateChangesSP).when(data: (user) {
    print('user signed out');
    if (user == null) return Stream.value(null);
    print('user signed in: ${user.uid}');
    return FirebaseFirestore.instance
        .collection('user/${FirebaseAuth.instance.currentUser!.uid}/project')
        .snapshots()
        .map((projects) {
      print('projects are: ${projects.docs.map((e) => e.id)}');
      if (projects.size > 0) {
        ref.read(activeProjectSNP.notifier).value = projects.docs.first.id;

        return projects.docs.first.id;
      }
      return null;
    });
  }, error: (e, s) {
    print('active proj error');
    return Stream.value(null);
  }, loading: () {
    return Stream.value(null);
  });
}, dependencies: [authStateChangesSP]);


/// WHY THIS DOESN'T WORK?
// final activeProjectPageSP = StreamProvider<String?>((ref) async* {
//   print('active page triggered...');
//   var pages = await FirebaseFirestore.instance
//       .collection('project/${ref.watch(activeProjectSNP)}/page')
//       .get();

//   if (pages.size > 0) {
//     ref.read(activeProjectPageSNP.notifier).value = pages.docs.first.id;
//     print('active page: ${pages.docs.first.id}');
//     yield pages.docs.first.id;
//   }
//   yield null;
// });

  // return ref.watch(activeProjectSP).when(data: (activeProject) {
  //   print('page prov: ${activeProject}');
  //   if (activeProject == null) return Stream.value(null);
  //   return FirebaseFirestore.instance
  //       .collection('project/${activeProject}/page')
  //       .snapshots()
  //       .map((pages) {
  //     print('pages: ${pages}');
  //     if (ref.read(activeProjectPageSNP.notifier).value == null &&
  //         pages.size > 0) {
  //       ref.read(activeProjectPageSNP.notifier).value = pages.docs.first.id;

  //       return pages.docs.first.id;
  //     }
  //     return null;
  //   });
  // }, error: (e, s) {
  //   print('page prov error: ${e}');
  //   return Stream.value(null);
  // }, loading: () {
  //   print('page prov loading');
  //   return Stream.value(null);
  // });

