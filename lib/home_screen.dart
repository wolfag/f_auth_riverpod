import 'package:flutter/material.dart';
import 'package:flutter_application/storage_state.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

class HomeScreen extends HookConsumerWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Scaffold(
      body: Column(
        children: [
          const SizedBox(
            height: 300,
          ),
          const Text(
            'Home Screen',
            style: TextStyle(fontSize: 30),
          ),
          const SizedBox(
            height: 30,
          ),
          Center(
            child: ref.watch(getAuthUserProvider).when(
                  data: (email) => Text(email),
                  error: (_, __) => Text('User information is not availabel'),
                  loading: () => const CircularProgressIndicator(),
                ),
          )
        ],
      ),
      floatingActionButton: FloatingActionButton(
        child: const Icon(Icons.delete),
        onPressed: () async {
          final isCleared = await ref.read(resetStorage);
          if (isCleared) {
            Navigator.popAndPushNamed(context, 'Login');
          }
        },
      ),
    );
  }
}
