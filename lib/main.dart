import 'package:flutter/material.dart';
import 'package:flutter_application/home_screen.dart';
import 'package:flutter_application/login_screen.dart';
import 'package:flutter_application/storage_state.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

void main() {
  runApp(const ProviderScope(child: MyApp()));
}

class MyApp extends HookConsumerWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: ref.watch(getIsAuthProvider).when(
            data: (isAuth) => isAuth ? const HomeScreen() : const LoginScreen(),
            error: (_, __) => const LoginScreen(),
            loading: () {
              return const Scaffold(
                body: Center(
                  child: CircularProgressIndicator(),
                ),
              );
            },
          ),
      routes: {
        'Home': (context) => const HomeScreen(),
        'Login': (context) => const LoginScreen(),
      },
    );
  }
}
