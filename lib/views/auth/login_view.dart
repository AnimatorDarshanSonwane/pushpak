// ignore_for_file: use_build_context_synchronously

import 'package:flutter/material.dart';
import 'package:pushpak/di/service_locator.dart';
import '../../viewmodels/auth_viewmodel.dart';
import 'register_view.dart';
//import 'phone_auth_view.dart';
import '../home/home_view.dart';

class LoginView extends StatefulWidget {
  const LoginView({super.key});

  @override
  State<LoginView> createState() => _LoginViewState();
}

class _LoginViewState extends State<LoginView> {
  final _emailCtrl = TextEditingController();
  final _passCtrl = TextEditingController();
  final _formKey = GlobalKey<FormState>();

  @override
  void dispose() {
    _emailCtrl.dispose();
    _passCtrl.dispose();
    super.dispose();
  }

  void _goToHome(BuildContext context) {
    Navigator.pushAndRemoveUntil(
      context,
      MaterialPageRoute(builder: (_) => const HomeView()),
      (route) => false,
    );
  }

  @override
  Widget build(BuildContext context) {
    final vm = locator<AuthViewModel>();

    return Scaffold(
      appBar: AppBar(
        title: const Text('Sign In'),
        automaticallyImplyLeading: false, // ⛔ no back arrow
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            // ---------------- FORM ----------------
            Form(
              key: _formKey,
              child: Column(
                children: [
                  TextFormField(
                    controller: _emailCtrl,
                    decoration: const InputDecoration(labelText: 'Email'),
                    keyboardType: TextInputType.emailAddress,
                    validator: (v) =>
                        v == null || v.isEmpty ? 'Email required' : null,
                  ),
                  const SizedBox(height: 8),
                  TextFormField(
                    controller: _passCtrl,
                    decoration: const InputDecoration(labelText: 'Password'),
                    obscureText: true,
                    validator: (v) =>
                        v == null || v.length < 6
                            ? 'Minimum 6 characters'
                            : null,
                  ),
                ],
              ),
            ),

            const SizedBox(height: 16),

            // ---------------- EMAIL LOGIN ----------------
            ElevatedButton(
              onPressed: () async {
                if (!_formKey.currentState!.validate()) return;

                final ok = await vm.signInWithEmail(
                  email: _emailCtrl.text,
                  password: _passCtrl.text,
                );

                if (!mounted) return;

                if (ok) {
                  _goToHome(context);
                } else {
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content:
                          Text(vm.errorMessage ?? 'Login failed'),
                    ),
                  );
                }
              },
              child: const Text('Sign In'),
            ),

            const SizedBox(height: 8),

            // ---------------- GOOGLE LOGIN ----------------
            ElevatedButton.icon(
              icon: const Icon(Icons.login),
              label: const Text('Sign in with Google'),
              onPressed: () async {
                final ok = await vm.signInWithGoogle();

                if (!mounted) return;

                if (ok) {
                  _goToHome(context);
                } else {
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content: Text(
                        vm.errorMessage ??
                            'Google sign in failed',
                      ),
                    ),
                  );
                }
              },
            ),

            const SizedBox(height: 8),

            // ---------------- REGISTER ----------------
            TextButton(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (_) => const RegisterView(),
                  ),
                );
              },
              child: const Text('Create account'),
            ),

            // ---------------- PHONE LOGIN ----------------
            // TextButton(
            //   onPressed: () {
            //     Navigator.push(
            //       context,
            //       MaterialPageRoute(
            //         builder: (_) => const PhoneAuthView(),
            //       ),
            //     );
            //   },
            //   child: const Text('Phone login'),
            // ),
          ],
        ),
      ),
    );
  }
}
