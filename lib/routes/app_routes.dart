import 'package:flutter/material.dart';
import 'package:pushpak/views/auth/auth_gate.dart';
import '../views/auth/login_view.dart';
import '../views/auth/register_view.dart';

class AppRoutes {
  static Map<String, WidgetBuilder> routes = {
  "/": (context) => const AuthGate(), // existing
  "/login": (context) => const LoginView(),
  "/register": (context) => const RegisterView(),
};
}
