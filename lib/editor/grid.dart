import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:codekid/common.dart';
import 'package:codekid/providers/firestore.dart';
import 'package:codekid/state/generic_state_notifier.dart';

import 'editor_page.dart';

final sortStateNotifierProvider =
    StateNotifierProvider<GenericStateNotifier<String?>, String?>(
        (ref) => GenericStateNotifier<String?>(null));

// String uid = FirebaseAuth.instance.currentUser!.uid;

class Grid extends ConsumerWidget {
  String? uid;
  Grid(this.uid, {super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) => Column(
      children: List.generate(
          NUM_CELLS,
          (index) => Row(
              children: List.generate(
                  NUM_CELLS,
                  (index) => Container(
                        decoration: cellBorder,
                        width: CELL_SIZE * 1.0,
                        height: CELL_SIZE * 1.0,
                      )))));
}
