import 'dart:js' as js;

import 'package:codekid/common.dart';
import 'package:flame/game.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../ember_quest.dart';
import '../interop.dart';
import '../overlays/game_over.dart';
import '../overlays/main_menu.dart';

class CKGameWidget extends ConsumerStatefulWidget {
  final String projectId;
  const CKGameWidget({
    required this.projectId,
    super.key,
  });

  @override
  _CKGameWidgetState createState() => _CKGameWidgetState();
}

class _CKGameWidgetState extends ConsumerState<CKGameWidget> {
  // final editorPageFocusNode = FocusNode();
  final FocusNode keyboardFocusNode = FocusNode();
  EmberQuestGame game = EmberQuestGame();

  @override
  void initState() {
    super.initState();

    kDB
        .collection('project/${widget.projectId}/code')
        .snapshots()
        .listen((codes) => codes.docs.forEach((e) {
              // print(e.data());
              registerEvent(e.data()['handler'],
                  "try { \n ${e.data()['code']} \n } catch (e) { \n logError('${e.data()['handler']}', e); \n }");
            }));

    Interop.initLog(kDB.collection('project/${widget.projectId}/output'));
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
        onTap: () => keyboardFocusNode.requestFocus(),
        child: RawKeyboardListener(
            focusNode: keyboardFocusNode,
            onKey: (event) {
              // print('keyLabel: ${event.logicalKey.keyLabel}');
              if (event is RawKeyDownEvent) {
                js.context.callMethod(
                    event.logicalKey.keyLabel.toLowerCase() + '_key_down');
              } else if (event is RawKeyUpEvent) {
                js.context.callMethod(
                    event.logicalKey.keyLabel.toLowerCase() + '_key_up');
              }
              // else if (event.isKeyPressed(LogicalKeyboardKey.space)) {
              //   js.context.callMethod('space_key_pressed');
              // } else if (event.isKeyPressed(LogicalKeyboardKey.arrowLeft)) {
              //   js.context.callMethod('left_key_pressed');
              // } else if (event.isKeyPressed(LogicalKeyboardKey.arrowRight)) {
              //   js.context.callMethod('right_key_pressed');
              // } else if (event.logicalKey == LogicalKeyboardKey.arrowLeft &&
              //     event is! RawKeyDownEvent) {
              //   js.context.callMethod('left_key_up');
              // } else if (event.logicalKey == LogicalKeyboardKey.arrowRight &&
              //     event is! RawKeyDownEvent) {
              //   js.context.callMethod('right_key_up');
              // }

              //  else if (event.isKeyPressed(LogicalKeyboardKey.arrowRight)) {
              //   game.moveRight();
              // } else if (event.isKeyPressed(LogicalKeyboardKey.arrowUp)) {
              //   game.moveUp();
              // } else if (event.isKeyPressed(LogicalKeyboardKey.arrowDown)) {
              //   game.moveDown();
              // }
            },
            child: GameWidget<EmberQuestGame>.controlled(
              gameFactory: () => game,
              overlayBuilderMap: {
                'MainMenu': (_, game) => MainMenu(game: game),
                'GameOver': (_, game) => GameOver(game: game),
              },
              initialActiveOverlays: const ['MainMenu'],
            )
            // GameWidget(
            //     focusNode: focusNode,
            //     game: game)

            ));
  }
}
