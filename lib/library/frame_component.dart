import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../common.dart';

class FrameComponent extends ConsumerWidget {
  @override
  Widget build(BuildContext context, WidgetRef ref) => ListTile(
      title: Container(
          decoration: BoxDecoration(
              border: Border(
            right: BorderSide(color: CELL_BORDER_COLOR, width: 0.3),
            left: BorderSide(color: CELL_BORDER_COLOR, width: 0.3),
            top: BorderSide(color: CELL_BORDER_COLOR, width: 0.3),
            bottom: BorderSide(color: CELL_BORDER_COLOR, width: 0.3),
          )),
          width: 70,
          height: 50),
      trailing: Text('Shift+f'));
}
