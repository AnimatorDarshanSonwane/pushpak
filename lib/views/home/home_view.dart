// ignore_for_file: use_build_context_synchronously

import 'package:flutter/material.dart';
import 'package:pushpak/di/service_locator.dart';
import '../../viewmodels/auth_viewmodel.dart';
import '../auth/login_view.dart'; // 👈 login screen import

class HomeView extends StatelessWidget {
  const HomeView({super.key});

  @override
  Widget build(BuildContext context) {
    final vm = locator<AuthViewModel>();
    final user = vm.currentUser;

    return Scaffold(
      appBar: AppBar(title: const Text('Home')),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              'Hello ${user?.displayName ?? user?.email ?? 'User'}',
              style: const TextStyle(fontSize: 18),
            ),
            const SizedBox(height: 20),

            // 🔴 LOGOUT BUTTON
            ElevatedButton(
              onPressed: () async {
                await vm.signOut();

                // ✅ Navigate to Login & clear stack
                Navigator.pushAndRemoveUntil(
                  context,
                  MaterialPageRoute(
                    builder: (_) => const LoginView(),
                  ),
                  (route) => false,
                );
              },
              child: const Text('Logout'),
            ),
          ],
        ),
      ),
    );
  }
}
