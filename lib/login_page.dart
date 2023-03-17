import 'package:auth/login_screen.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter/material.dart';

class LoginPage extends ConsumerWidget {
  const LoginPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Scaffold(
        body: LoginScreen("CodeKid", "Log in", {
      // "loginGitHub": true,
      "loginGoogle": true,
      // "loginEmail": true,
      // "loginSSO": true,
      "loginAnonymous": true,
      // "signupOption": true,
    }));
  }
}
