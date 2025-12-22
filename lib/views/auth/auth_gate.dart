import 'package:flutter/material.dart';
import 'package:pushpak/di/service_locator.dart';
import '../../viewmodels/auth_viewmodel.dart';
import '../home/main_tab_view.dart';
import 'login_view.dart';

class AuthGate extends StatelessWidget {
  const AuthGate({super.key});

  @override
  Widget build(BuildContext context) {
    final vm = locator<AuthViewModel>();

    return StreamBuilder(
      stream: vm.authStateChanges,
      builder: (context, snapshot) {
        // Loading state
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Scaffold(
            body: Center(child: CircularProgressIndicator()),
          );
        }

        // Not logged in
        if (!snapshot.hasData || snapshot.data == null) {
          return const LoginView();
        }

        // Logged in → Go to Bottom Navigation shell
        return const MainTabView();
      },
    );
  }
}
