import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:tumex_users_app/features/auth/screens/error_screen.dart';
import 'package:tumex_users_app/features/auth/screens/login_screen.dart';
import 'package:tumex_users_app/features/auth/services/auth_service.dart';
import 'package:tumex_users_app/features/navigation/screens/main_scaffold.dart';

class AuthGate extends ConsumerWidget {
  const AuthGate({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final authState = ref.watch(authStateProvider);

    return authState.when(
      data: (user) {
        if (user != null) {
          return const MainScaffold();
        }
        return const LoginScreen();
      },
      loading: () => const Scaffold(
        body: Center(
          child: CircularProgressIndicator(),
        ),
      ),
      error: (error, stackTrace) {
        String errorMessage = 'An unexpected error occurred. Please try again.';
        if (error is FirebaseException) {
          // Provide a more specific, user-friendly message
          errorMessage = error.message ?? 'A Firebase error occurred.';
        }
        return ErrorScreen(errorMessage: errorMessage);
      },
    );
  }
}
