import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_firestore_providers/providers.dart';

import 'package:codekid/state/generic_state_notifier.dart';
import 'package:codekid/resume/resume_tile.dart';

final activeResumeBatch =
    StateNotifierProvider<GenericStateNotifier<String?>, String?>(
        (ref) => GenericStateNotifier<String?>(null));

String uid = FirebaseAuth.instance.currentUser!.uid;

class ResumeList extends ConsumerWidget {
  @override
  Widget build(BuildContext context, WidgetRef ref) => ListView(
      padding: EdgeInsets.zero,
      shrinkWrap: true,
      children: ref.watch(colSP('user/$uid/resume')).when(
          loading: () => [Container()],
          error: (e, s) => [ErrorWidget(e)],
          data: (data) {
            return data.docs
                .map((e) => ResumeTile(key: Key(e.id), e.reference))
                .toList();
          }));
}
