import 'dart:convert';

import 'package:flutter_application/storage_state.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:http/http.dart' as http;
import 'package:http/http.dart';

// ignore_for_file: public_member_api_docs, sort_constructors_first
class AuthArgs {
  final String email;
  final String password;
  AuthArgs({
    required this.email,
    required this.password,
  });
}

class AuthValues {
  final String token;
  final String refreshToken;
  final String clientId;
  final String email;

  AuthValues({
    required this.token,
    required this.refreshToken,
    required this.clientId,
    required this.email,
  });

  AuthValues.fromJson(Map<String, dynamic> json)
      : email = json['email'],
        token = json['token'],
        refreshToken = json['refreshToken'],
        clientId = json['clientId'];
}

class AuthResponse {
  final AuthValues authValues;
  final int statusCode;

  AuthResponse({
    required this.authValues,
    required this.statusCode,
  });
}

class AuthHandler {
  late AuthValues authValues = AuthValues(
    token: '',
    refreshToken: '',
    clientId: '',
    email: '',
  );

  Future<AuthResponse> login(AuthArgs args) async {
    // final response = await http.post(
    //   Uri.http('localhost:4000', '/api/login'),
    //   body: {
    //     'email': args.email,
    //     'password': args.password,
    //     'token': 'hello',
    //   },
    // );

    final response = Response(
        jsonEncode({
          'clientId': "1",
          'token': "123",
          'refreshToken': "456",
          'email': "hello@gmail.com",
        }),
        200);

    authValues = AuthValues.fromJson(jsonDecode(response.body));

    return AuthResponse(
      authValues: authValues,
      statusCode: response.statusCode,
    );
  }
}

final authHandlerProvider = StateProvider<AuthHandler>((_) => AuthHandler());

final authErrorMessageProvider = StateProvider<String>((ref) => '');

final authLoginProvider = FutureProvider.family<bool, AuthArgs>(
  (ref, authArgs) async {
    return Future.delayed(
      const Duration(seconds: 2),
      () async {
        final authResponse =
            await ref.watch(authHandlerProvider).login(authArgs);
        final isAuth = authResponse.statusCode == 200;
        if (isAuth) {
          ref.read(setAuthStateProvider.notifier).state = authResponse;
          ref.read(setIsAuthProvider(isAuth));
          ref.read(setAuthUserProvider(authResponse.authValues.email));
        } else {
          ref.read(authErrorMessageProvider.notifier).state =
              'Error occurred while login with code: ${authResponse.statusCode}';
        }

        return isAuth;
      },
    );
  },
);
