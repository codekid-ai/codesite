import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:codekid/common.dart';
import 'package:codekid/editor/editor_page.dart';
import 'package:codekid/editor/keyboard_processor.dart';
import 'package:codekid/state/current_selector.dart';

import '../providers/firestore.dart';
import '../state/generic_state_notifier.dart';

class SelectedObjectFrame extends ConsumerWidget {
  final StateNotifierProvider<GenericStateNotifier<int?>, int?> activeCellLeft;
  final StateNotifierProvider<GenericStateNotifier<int?>, int?> activeCellTop;

  SelectedObjectFrame(this.activeCellLeft, this.activeCellTop);

  @override
  Widget build(BuildContext context, WidgetRef ref) => //Container();
      ref.watch(selectedObjectSNP) == null
          ? Text('no selected')
          : Positioned(
              left: CELL_SIZE * (ref.watch(activeCellLeft) ?? 0),
              top: CELL_SIZE * (ref.watch(activeCellTop) ?? 0),
              child: Container(
                decoration: movingBorder,
                width:
                    CELL_SIZE * ref.watch(selectedObjectSNP)!['data']['width'],
                height:
                    CELL_SIZE * ref.watch(selectedObjectSNP)!['data']['height'],
                // color: Colors.green,
              ),
            );
}
