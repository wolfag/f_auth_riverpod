import 'package:flutter_application/auth_state.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:shared_preferences/shared_preferences.dart';

const IS_AUTH_KEY = 'IS_AUTH_KEY';

const AUTH_USER_EMAIL_KEY = 'AUTH_USER_EMAIL_KEY';

final sharedPrefProvider = Provider((_) async {
  return await SharedPreferences.getInstance();
});

final setAuthStateProvider = StateProvider<AuthResponse?>((ref) {
  return null;
});

final setIsAuthProvider = StateProvider.family<void, bool>(
  (ref, isAuth) async {
    final prefs = await ref.watch(sharedPrefProvider);
    ref.watch(setAuthStateProvider);
    prefs.setBool(IS_AUTH_KEY, isAuth);
  },
);

final setAuthUserProvider = StateProvider.family<void, String>(
  (ref, email) async {
    final prefs = await ref.watch(sharedPrefProvider);
    ref.watch(setAuthStateProvider);
    prefs.setString(AUTH_USER_EMAIL_KEY, email);
  },
);

final getIsAuthProvider = FutureProvider<bool>(
  (ref) async {
    final prefs = await ref.watch(sharedPrefProvider);
    ref.watch(setAuthStateProvider);
    return prefs.getBool(IS_AUTH_KEY) ?? false;
  },
);

final getAuthUserProvider = FutureProvider<String>(
  (ref) async {
    final prefs = await ref.watch(sharedPrefProvider);
    ref.watch(setAuthStateProvider);
    return prefs.getString(AUTH_USER_EMAIL_KEY) ?? '';
  },
);

final resetStorage = StateProvider(
  (ref) async {
    final prefs = await ref.watch(sharedPrefProvider);
    final isCleared = await prefs.clear();
    return isCleared;
  },
);
