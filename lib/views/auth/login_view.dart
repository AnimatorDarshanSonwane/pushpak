import 'package:flutter/material.dart';
import 'package:pushpak/di/service_locator.dart';
import '../../viewmodels/auth_viewmodel.dart';
import 'register_view.dart';
import 'phone_auth_view.dart';

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

  @override
  Widget build(BuildContext context) {
    final vm = locator<AuthViewModel>();
    return Scaffold(
      appBar: AppBar(title: const Text('Sign In')),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            Form(
              key: _formKey,
              child: Column(children: [
                TextFormField(controller: _emailCtrl, decoration: const InputDecoration(labelText: 'Email')),
                const SizedBox(height: 8),
                TextFormField(controller: _passCtrl, decoration: const InputDecoration(labelText: 'Password'), obscureText: true),
              ]),
            ),
            const SizedBox(height: 16),
            ElevatedButton(
              onPressed: () async {
                if (!_formKey.currentState!.validate()) return;
                final ok = await vm.signInWithEmail(email: _emailCtrl.text, password: _passCtrl.text);
                if (!ok) {
                  final msg = vm.errorMessage ?? 'Login failed';
                  ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(msg)));
                }
              },
              child: const Text('Sign In'),
            ),
            const SizedBox(height: 8),
            ElevatedButton.icon(
              icon: const Icon(Icons.login),
              label: const Text('Sign in with Google'),
              onPressed: () async {
                final ok = await vm.signInWithGoogle();
                if (!ok) {
                  final m = vm.errorMessage ?? 'Google sign in failed';
                  ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(m)));
                }
              },
            ),
            const SizedBox(height: 8),
            TextButton(onPressed: () => Navigator.of(context).push(MaterialPageRoute(builder: (_) => const RegisterView())), child: const Text('Create account')),
            TextButton(onPressed: () => Navigator.of(context).push(MaterialPageRoute(builder: (_) => const PhoneAuthView())), child: const Text('Phone login')),
          ],
        ),
      ),
    );
  }
}
