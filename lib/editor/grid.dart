// import 'package:firebase_auth/firebase_auth.dart';
// import 'package:flame/game.dart';
// import 'package:flutter/material.dart';
// import 'package:flutter/services.dart';
// import 'package:flutter_riverpod/flutter_riverpod.dart';
// import 'package:ember/common.dart';
// import 'package:flutter_firestore_providers/providers.dart';

// import 'package:ember/state/generic_state_notifier.dart';

// import '../ember_quest.dart';
// import '../overlays/game_over.dart';
// import '../overlays/main_menu.dart';
// import 'editor_page.dart';


// final sortStateNotifierProvider =
//     StateNotifierProvider<GenericStateNotifier<String?>, String?>(
//         (ref) => GenericStateNotifier<String?>(null));

// class Grid extends ConsumerWidget {
//   EmberQuestGame game = EmberQuestGame();
//   String? uid;
//   FocusNode keyboardFocusNode = FocusNode();
//   Grid(this.uid, {super.key});

//   @override
//   Widget build(BuildContext context, WidgetRef ref) => GestureDetector(
//       onTap: () => focusNode.requestFocus(),
//       child:  GameWidget(focusNode: focusNode, game: game)));
//   // GameWidget<EmberQuestGame>.controlled(
//   //   gameFactory: EmberQuestGame.new,
//   //   overlayBuilderMap: {
//   //     'MainMenu': (_, game) => MainMenu(game: game),
//   //     'GameOver': (_, game) => GameOver(game: game),
//   //   },
//   //   initialActiveOverlays: const ['MainMenu'],
//   // );
// }
