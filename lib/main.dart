import 'dart:isolate';

import 'package:auth/generic_state_notifier.dart';
import 'package:codekid/theme.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:providers/generic.dart';
import 'choose_userview.dart';
import 'common.dart';
import 'editor/ckgame_widget.dart';
import 'firebase_options.dart';
import 'dart:js';

import 'iframe.dart';
import 'iframe_native.dart';
import 'interop.dart';
import 'login_page.dart';

// void callJS() {
// // Call a JavaScript function from Dart
//   context.callMethod('callDartFunction', ['argument1', 'argument2']);
// }

// void addAvatarHandler(id, handler) {
// // Call a JavaScript function from Dart
//   context.callMethod('addAvatarHandler', [id, handler]);
// }

// void callAvatarHandler(id) {
// // Call a JavaScript function from Dart
//   context.callMethod('callAvatarHandler', [id]);
// }

void main() async {
  // Expose a Dart function to JavaScript
  allowInterops(context);

  WidgetsFlutterBinding.ensureInitialized();

  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );

  runApp(ProviderScope(child: MainApp()));
}

class MainApp extends ConsumerWidget {
  const MainApp({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    //bool isDarkTheme = ref.watch(themeStateNotifierProvider);
    return MaterialApp(
      title: 'Code Kid',
      // themeMode: isDarkTheme ? ThemeMode.dark : ThemeMode.light,
      theme: lightTheme,
      darkTheme: darkTheme,
      home: TheApp(),
      // SandboxLauncher(
      //   app: TheApp(),
      //   sandbox: Sandbox(),
      //   getInitialState: () async {
      //     return (await kDB.doc('sandbox/serge').get()).data();
      //   },
      //   saveState: (s) {
      //     kDB.doc('sandbox/serge').set({'sandbox': s});
      //   },
      // )
    );
  }
}

final isLoggedIn = StateNotifierProvider<GenericStateNotifier<bool>, bool>(
    (ref) => GenericStateNotifier<bool>(false));

final isLoading = StateNotifierProvider<GenericStateNotifier<bool>, bool>(
    (ref) => GenericStateNotifier<bool>(false));

class TheApp extends ConsumerStatefulWidget {
  const TheApp({Key? key}) : super(key: key);
  @override
  TheAppState createState() => TheAppState();
}

class TheAppState extends ConsumerState<TheApp> {
  //bool isLoading = false;
  @override
  void initState() {
    super.initState();
    try {
      ref.read(isLoading.notifier).value = true;
    } catch (e) {
      print(e);
    }
    FirebaseAuth.instance.authStateChanges().listen((User? user) {
      if (user == null) {
        ref.read(isLoggedIn.notifier).value = false;
        ref.read(isLoading.notifier).value = false;
      } else {
        ref.read(isLoggedIn.notifier).value = true;
        ref.read(isLoading.notifier).value = false;
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    if (ref.watch(isLoading)) {
      return Center(
        child: Container(
          alignment: Alignment(0.0, 0.0),
          child: CircularProgressIndicator(),
        ),
      );
    } else {
      return Scaffold(
          body: //buildIFrameNativeWidget()
              // buildIFrameWidget()
              ref.watch(isLoggedIn) == false
                  ? LoginPage()
                  : // buildIFrameWidget()
                  ChooseUserViewWidget());
    }
  }
}
