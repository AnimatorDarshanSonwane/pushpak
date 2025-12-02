import 'package:flutter/material.dart';
import '../views/home/home_view.dart';
import '../views/auth/login_view.dart';
import '../views/auth/register_view.dart';

class AppRoutes {
  static Map<String, WidgetBuilder> routes = {
  "/": (context) => const HomeView(), // existing
  "/login": (context) => const LoginView(),
  "/register": (context) => const RegisterView(),
};
}
