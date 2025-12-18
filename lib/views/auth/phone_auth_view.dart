import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:pushpak/di/service_locator.dart';
import '../../viewmodels/auth_viewmodel.dart';

class PhoneAuthView extends StatefulWidget {
  const PhoneAuthView({super.key});
  @override
  State<PhoneAuthView> createState() => _PhoneAuthViewState();
}

class _PhoneAuthViewState extends State<PhoneAuthView> {
  final _phoneCtrl = TextEditingController();
  final _codeCtrl = TextEditingController();
  String? _verificationId;
  bool _codeSent = false;

  @override
  void dispose() {
    _phoneCtrl.dispose();
    _codeCtrl.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final vm = locator<AuthViewModel>();
    return Scaffold(
      appBar: AppBar(title: const Text('Phone Login')),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(children: [
          if (!_codeSent) ...[
            TextField(controller: _phoneCtrl, decoration: const InputDecoration(labelText: 'Phone e.g. +9198xxxx')),
            const SizedBox(height: 16),
            ElevatedButton(
              onPressed: () async {
                final phone = _phoneCtrl.text.trim();
                await vm.verifyPhone(
                  phone: phone,
                  onCodeSent: (verificationId, resendToken) {
                    setState(() {
                      _verificationId = verificationId;
                      _codeSent = true;
                    });
                    ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Code sent')));
                  },
                  onVerificationCompleted: (credential) async {
                    // Auto sign-in on Android (instant or auto retrieval)
                    await vm.signInWithPhoneCredential(credential);
                  },
                  onVerificationFailed: (error) {
                    ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(error.message ?? 'Phone verify failed')));
                  },
                );
              },
              child: const Text('Send code'),
            ),
          ] else ...[
            TextField(controller: _codeCtrl, decoration: const InputDecoration(labelText: 'SMS code')),
            const SizedBox(height: 16),
            ElevatedButton(
              onPressed: () async {
                final code = _codeCtrl.text.trim();
                if (_verificationId == null) return;
                final credential = PhoneAuthProvider.credential(verificationId: _verificationId!, smsCode: code);
                try {
                  await vm.signInWithPhoneCredential(credential);
                  Navigator.of(context).pushReplacementNamed('/'); // Navigate to home on success
                } catch (e) {
                  ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(e.toString())));
                }
              },
              child: const Text('Verify & Sign in'),
            ),
          ],
        ]),
      ),
    );
  }
}
