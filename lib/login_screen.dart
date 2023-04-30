import 'package:flutter/material.dart';
import 'package:flutter_application/auth_state.dart';
import 'package:flutter_application/storage_state.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

class LoginScreen extends HookConsumerWidget {
  const LoginScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final emailController = useTextEditingController();
    final passwordController = useTextEditingController();

    // Test
    emailController.text = "heell@gmail.com";
    passwordController.text = "123456";

    ref.listen(
      authErrorMessageProvider,
      (previous, next) {
        if (next.isNotEmpty) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text(next),
            ),
          );
        } else {
          emailController.text = '';
          passwordController.text = '';
        }
      },
    );

    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20),
        child: Column(
          children: [
            const SizedBox(
              height: 200,
            ),
            TextField(
              controller: emailController,
              decoration: const InputDecoration(helperText: 'Email'),
            ),
            const SizedBox(
              height: 10,
            ),
            TextField(
              controller: passwordController,
              obscureText: true,
              decoration: const InputDecoration(helperText: 'Password'),
            ),
            const SizedBox(
              height: 10,
            ),
            TextButton(
              onPressed: () async {
                if (emailController.text.isNotEmpty &&
                    passwordController.text.isNotEmpty) {
                  final authArgs = AuthArgs(
                    email: emailController.text,
                    password: passwordController.text,
                  );

                  ref.read(authLoginProvider(authArgs));
                  final isAuth = ref.read(getIsAuthProvider);
                  if (isAuth.value!) {
                    Navigator.pushNamed(context, 'Home');
                  }
                }
              },
              child: const Text(
                'Login',
                style: TextStyle(fontSize: 18),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
