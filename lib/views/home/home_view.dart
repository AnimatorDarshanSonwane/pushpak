import 'package:flutter/material.dart';
import 'package:pushpak/di/service_locator.dart';
import '../../viewmodels/auth_viewmodel.dart';

class HomeView extends StatelessWidget {
  const HomeView({super.key});
  @override
  Widget build(BuildContext context) {
    final vm = locator<AuthViewModel>();
    final user = vm.currentUser;
    return Scaffold(
      appBar: AppBar(title: const Text('Home')),
      body: Center(
        child: Column(mainAxisAlignment: MainAxisAlignment.center, children: [
          Text('Hello ${user?.displayName ?? user?.email ?? 'User'}'),
          const SizedBox(height: 16),
          ElevatedButton(
            onPressed: () async {
              await vm.signOut();
            },
            child: const Text('Logout'),
          )
        ]),
      ),
    );
  }
}
