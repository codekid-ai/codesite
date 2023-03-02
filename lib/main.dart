import 'package:codekid/sandbox/sandbox.dart';
import 'package:codekid/sandbox/sandbox_launcher.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:codekid/choose_userview.dart';
import 'package:codekid/editor/editor_page.dart';
import 'package:codekid/login_page.dart';
import 'package:codekid/state/generic_state_notifier.dart';
import 'package:codekid/state/theme_state_notifier.dart';
import 'package:codekid/theme.dart';
import 'common.dart';
import 'firebase_options.dart';

void main() async {
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
        home: SandboxLauncher(
          app: TheApp(),
          sandbox: Sandbox(),
          getInitialState: () async {
            return (await kDB.doc('sandbox/serge').get()).data();
          },
          saveState: (s) {
            kDB.doc('sandbox/serge').set({'sandbox': s});
          },
        ));
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
          body: ref.watch(isLoggedIn) == false
              ? LoginPage()
              : ChooseUserViewWidget());
    }
  }
}
