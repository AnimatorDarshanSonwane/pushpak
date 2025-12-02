import 'package:flutter/material.dart';
import 'package:pushpak/di/service_locator.dart';
import '../../viewmodels/auth_viewmodel.dart';
import '../home/home_view.dart';
import 'login_view.dart';

class AuthGate extends StatelessWidget {
  const AuthGate({super.key});

  @override
  Widget build(BuildContext context) {
    final vm = locator<AuthViewModel>(); // if using get_it or use Provider
    return StreamBuilder(
      stream: vm.authStateChanges,
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Scaffold(body: Center(child: CircularProgressIndicator()));
        }
        final user = snapshot.data;
        if (user == null) return const LoginView();
        return const HomeView();
      },
    );
  }
}
