import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import '../di/service_locator.dart';
import '../services/auth_service.dart';

enum AuthState { idle, loading, success, error }

class AuthViewModel extends ChangeNotifier {
  final AuthService _authService = locator<AuthService>();

  AuthState state = AuthState.idle;
  String? errorMessage;

  Stream<User?> get authStateChanges => _authService.authStateChanges;
  User? get currentUser => _authService.currentUser;

  Future<bool> registerWithEmail({
    required String email,
    required String password,
    String? displayName,
  }) async {
    state = AuthState.loading; notifyListeners();
    try {
      await _authService.registerWithEmail(email: email, password: password, displayName: displayName);
      state = AuthState.success; notifyListeners();
      return true;
    } on FirebaseAuthException catch (e) {
      errorMessage = e.message;
      state = AuthState.error; notifyListeners();
      return false;
    } catch (e) {
      errorMessage = e.toString();
      state = AuthState.error; notifyListeners();
      return false;
    }
  }

  Future<bool> signInWithEmail({
    required String email,
    required String password,
  }) async {
    state = AuthState.loading; notifyListeners();
    try {
      await _authService.signInWithEmail(email: email, password: password);
      state = AuthState.success; notifyListeners();
      return true;
    } on FirebaseAuthException catch (e) {
      errorMessage = e.message;
      state = AuthState.error; notifyListeners();
      return false;
    } catch (e) {
      errorMessage = e.toString();
      state = AuthState.error; notifyListeners();
      return false;
    }
  }

  Future<bool> signInWithGoogle() async {
    state = AuthState.loading; notifyListeners();
    try {
      await _authService.signInWithGoogle();
      state = AuthState.success; notifyListeners();
      return true;
    } on FirebaseAuthException catch (e) {
      errorMessage = e.message;
      state = AuthState.error; notifyListeners();
      return false;
    } catch (e) {
      errorMessage = e.toString();
      state = AuthState.error; notifyListeners();
      return false;
    }
  }

  Future<void> signOut() async {
    await _authService.signOut();
    state = AuthState.idle; notifyListeners();
  }

  // Phone flows (the UI will use these callbacks)
  Future<void> verifyPhone({
    required String phone,
    required Function(String verificationId, int? resendToken) onCodeSent,
    required Function(PhoneAuthCredential) onVerificationCompleted,
    required Function(FirebaseAuthException) onVerificationFailed,
  }) async {
    await _authService.verifyPhone(
      phoneNumber: phone,
      codeSent: onCodeSent,
      verificationCompleted: onVerificationCompleted,
      verificationFailed: onVerificationFailed,
    );
  }

  Future<UserCredential> signInWithPhoneCredential(PhoneAuthCredential credential) {
    return _authService.signInWithPhoneCredential(credential);
  }

  Future<void> sendPasswordReset(String email) => _authService.sendPasswordResetEmail(email);
}
