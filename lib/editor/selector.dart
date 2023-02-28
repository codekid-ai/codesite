import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:codekid/common.dart';
import 'package:codekid/editor/editor_page.dart';
import 'package:codekid/editor/keyboard_processor.dart';
import 'package:codekid/state/generic_state_notifier.dart';

class Selector extends ConsumerWidget {
  final StateNotifierProvider<GenericStateNotifier<int?>, int?> activeCellLeft;
  final StateNotifierProvider<GenericStateNotifier<int?>, int?> activeCellTop;

  Selector(this.activeCellLeft, this.activeCellTop);

  @override
  Widget build(BuildContext context, WidgetRef ref) => Positioned(
        left: CELL_SIZE * (ref.watch(activeCellLeft)?.toDouble() ?? 0),
        top: CELL_SIZE * (ref.watch(activeCellTop)?.toDouble() ?? 0),
        child: Container(
          decoration: cellBorderSelected,
          width: CELL_SIZE * 1.0,
          height: CELL_SIZE * 1.0,
        ),
      );
}
