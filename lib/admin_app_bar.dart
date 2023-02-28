import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:codekid/main.dart';
import 'package:codekid/state/theme_state_notifier.dart';
import 'package:codekid/common.dart';

class AdminAppBar {
  static final List<String> _tabs = [
    'clients',
    // 'resumes',
    // 'cover letters',
    // 'lists',
    // 'pep admin',
    // 'pep library',
    // 'adverse media'
  ];

  static PreferredSizeWidget getBar(BuildContext context, WidgetRef ref) {
    return AppBar(
      // automaticallyImplyLeading:
      //     (MediaQuery.of(context).size.width < WIDE_SCREEN_WIDTH)
      //         ? true
      //         : false,
      // leadingWidth:
      //     (MediaQuery.of(context).size.width < WIDE_SCREEN_WIDTH) ? null : 100,
      // leading: BackButton(onPressed: () => Navigator.of(context).pop()),
      // IconButton(
      //     icon:

      //     Icon(Icons.navigate_before),
      //     onPressed: () => Navigator.of(context).pop()),
      //  (MediaQuery.of(context).size.width < WIDE_SCREEN_WIDTH)
      //     ? null
      //     :

      // Padding(
      //     padding: EdgeInsets.all(10),
      //     child: Text(''),
      //   )

      title: (MediaQuery.of(context).size.width < WIDE_SCREEN_WIDTH)
          ? null
          : Align(
              child: SizedBox(
                  width: 800,
                  child: TabBar(
                    tabs: _tabs
                        .map((t) => Tab(
                            iconMargin: EdgeInsets.all(0),
                            child:
                                // GestureDetector(
                                //     behavior: HitTestBehavior.translucent,
                                //onTap: () => navigatePage(text, context),
                                //child:
                                Text(t.toUpperCase(),
                                    overflow: TextOverflow.fade,
                                    softWrap: false,
                                    style: TextStyle(
                                        color:
                                            // Theme.of(context).brightness == Brightness.light
                                            //     ? Color(DARK_GREY)
                                            //:
                                            Colors.white))))
                        .toList(),
                    onTap: (index) {
                      Navigator.of(context).pushNamed(_tabs[index]);
                    },
                  ))),
      actions: [ThemeIconButton(), SignOutButton()],
    );
  }
}

class ThemeIconButton extends ConsumerWidget {
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    var isDarkState = ref.watch(themeStateNotifierProvider);
    return IconButton(
        tooltip: 'dark/light mode',
        onPressed: () {
          ref.read(themeStateNotifierProvider.notifier).changeTheme();
        },
        icon: Icon(isDarkState == true
            ? Icons.nightlight
            : Icons.nightlight_outlined));
  }
}

class SignOutButton extends ConsumerWidget {
  @override
  Widget build(BuildContext context, WidgetRef ref) => IconButton(
      onPressed: () {
        ref.read(isLoggedIn.notifier).value = false;
        FirebaseAuth.instance.signOut();
      },
      icon: Icon(Icons.exit_to_app));
}
