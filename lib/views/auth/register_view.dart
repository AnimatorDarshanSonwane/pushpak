import 'package:flutter/material.dart';
import 'package:pushpak/di/service_locator.dart';
import '../../viewmodels/auth_viewmodel.dart';

class RegisterView extends StatefulWidget {
  const RegisterView({super.key});

  @override
  State<RegisterView> createState() => _RegisterViewState();
}

class _RegisterViewState extends State<RegisterView> {
  final _emailCtrl = TextEditingController();
  final _passCtrl = TextEditingController();
  final _nameCtrl = TextEditingController();
  final _formKey = GlobalKey<FormState>();

  @override
  void dispose() {
    _emailCtrl.dispose();
    _passCtrl.dispose();
    _nameCtrl.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final vm = locator<AuthViewModel>();
    return Scaffold(
      appBar: AppBar(title: const Text('Register')),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(children: [
          Form(
            key: _formKey,
            child: Column(children: [
              TextFormField(controller: _nameCtrl, decoration: const InputDecoration(labelText: 'Full name')),
              const SizedBox(height: 8),
              TextFormField(controller: _emailCtrl, decoration: const InputDecoration(labelText: 'Email')),
              const SizedBox(height: 8),
              TextFormField(controller: _passCtrl, decoration: const InputDecoration(labelText: 'Password'), obscureText: true),
            ]),
          ),
          const SizedBox(height: 16),
          ElevatedButton(
            onPressed: () async {
              if (!_formKey.currentState!.validate()) return;
              final ok = await vm.registerWithEmail(
                email: _emailCtrl.text,
                password: _passCtrl.text,
                displayName: _nameCtrl.text,
              );
              if (!ok) {
                final msg = vm.errorMessage ?? 'Registration failed';
                ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(msg)));
              } else {
                Navigator.of(context).pop(); // go back to login
              }
            },
            child: const Text('Create Account'),
          ),
        ]),
      ),
    );
  }
}
