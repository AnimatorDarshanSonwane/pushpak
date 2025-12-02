import 'package:flutter/material.dart';
import 'package:pushpak/views/auth/auth_gate.dart';
import 'routes/app_routes.dart';
import 'themes/app_theme.dart';

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: "Uber Clone",
      debugShowCheckedModeBanner: false,
      home: const AuthGate(),
      theme: AppTheme.lightTheme,
      routes: AppRoutes.routes,
    );
  }
}
