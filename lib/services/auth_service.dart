import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/foundation.dart';
import 'package:google_sign_in/google_sign_in.dart';

class AuthService {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  // Stream for auth state
  Stream<User?> get authStateChanges => _auth.authStateChanges();
  User? get currentUser => _auth.currentUser;

  // --------------------------------------------------
  // EMAIL REGISTER
  // --------------------------------------------------
  Future<UserCredential> registerWithEmail({
    required String email,
    required String password,
    String? displayName,
  }) async {
    final cred = await _auth.createUserWithEmailAndPassword(
      email: email.trim(),
      password: password,
    );

    if (displayName != null) {
      await cred.user?.updateDisplayName(displayName);
    }

    await saveUserToFirestore(cred.user);
    return cred;
  }

  // --------------------------------------------------
  // EMAIL LOGIN
  // --------------------------------------------------
  Future<UserCredential> signInWithEmail({
    required String email,
    required String password,
  }) async {
    final cred = await _auth.signInWithEmailAndPassword(
      email: email.trim(),
      password: password,
    );

    await saveUserToFirestore(cred.user);
    return cred;
  }

  // --------------------------------------------------
  // GOOGLE SIGN-IN (UPDATED 2025)
  // --------------------------------------------------

Future<UserCredential> signInWithGoogle() async {
  try {
    final FirebaseAuth _auth = FirebaseAuth.instance;

    // ---------------------------------
    // INITIALIZE GOOGLE SIGN-IN
    // ---------------------------------
    await GoogleSignIn.instance.initialize(
      serverClientId:
          '375010464684-ei7cgf66k5d33b9ivbs8vuigofj4njql.apps.googleusercontent.com',
    );

    // ---------------------------------
    // AUTHENTICATE USER
    // ---------------------------------
    final GoogleSignInAccount? googleUser =
        await GoogleSignIn.instance.authenticate();

    if (googleUser == null) {
      throw FirebaseAuthException(
        code: 'ERROR_ABORTED_BY_USER',
        message: 'Sign-in cancelled by user',
      );
    }

    // ---------------------------------
    // GET AUTH TOKENS
    // ---------------------------------
    final GoogleSignInAuthentication googleAuth =
        googleUser.authentication;

    // ---------------------------------
    // FIREBASE CREDENTIAL
    // ---------------------------------
    final OAuthCredential credential =
        GoogleAuthProvider.credential(
      idToken: googleAuth.idToken
    );

    final UserCredential userCredential =
        await _auth.signInWithCredential(credential);

    return userCredential;
  } catch (e) {
    debugPrint('Google Sign-In Error: $e');
    rethrow;
  }
}


  // --------------------------------------------------
  // PHONE AUTH: SEND OTP
  // --------------------------------------------------
  Future<void> verifyPhone({
    required String phoneNumber,
    required Function(String verificationId, int? resendToken) codeSent,
    required Function(PhoneAuthCredential) verificationCompleted,
    required Function(FirebaseAuthException) verificationFailed,
    Duration timeout = const Duration(seconds: 60),
  }) async {
    debugPrint('Verifying phone: $phoneNumber');
    if (kIsWeb) {
      // For web, Firebase handles reCAPTCHA automatically
      await _auth.verifyPhoneNumber(
        phoneNumber: phoneNumber,
        verificationCompleted: verificationCompleted,
        verificationFailed: verificationFailed,
        codeSent: codeSent,
        codeAutoRetrievalTimeout: (String verificationId) {},
        timeout: timeout,
      );
    } else {
      // For mobile platforms
      await _auth.verifyPhoneNumber(
        phoneNumber: phoneNumber,
        verificationCompleted: verificationCompleted,
        verificationFailed: verificationFailed,
        codeSent: codeSent,
        codeAutoRetrievalTimeout: (String verificationId) {},
        timeout: timeout,
      );
    }
  }

  // --------------------------------------------------
  // PHONE AUTH: VERIFY OTP
  // --------------------------------------------------
  Future<UserCredential> signInWithPhoneCredential(
      PhoneAuthCredential credential) async {
    final userCred = await _auth.signInWithCredential(credential);
    await saveUserToFirestore(userCred.user);
    return userCred;
  }

  // --------------------------------------------------
  // RESET PASSWORD
  // --------------------------------------------------
  Future<void> sendPasswordResetEmail(String email) async {
    await _auth.sendPasswordResetEmail(email: email.trim());
  }

  // --------------------------------------------------
  // SIGN OUT (UPDATED 2025)
  // --------------------------------------------------
  Future<void> signOut() async {
    try {
      // Web uses instance
      // Android/iOS also use instance (because you initialized it earlier)
      await GoogleSignIn.instance.signOut();
    } catch (e) {
      debugPrint("Google Sign-Out Error: $e");
    }

    await _auth.signOut();
  }

  // --------------------------------------------------
  // SAVE USER DATA
  // --------------------------------------------------
  Future<void> saveUserToFirestore(User? user) async {
    if (user == null) return;

    final ref = _firestore.collection('users').doc(user.uid);

    final data = {
      'uid': user.uid,
      'email': user.email,
      'displayName': user.displayName,
      'photoURL': user.photoURL,
      'lastSeen': FieldValue.serverTimestamp(),
      'createdAt': FieldValue.serverTimestamp(),
    };

    await ref.set(data, SetOptions(merge: true));
  }
}
