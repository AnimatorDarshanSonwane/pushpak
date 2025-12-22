import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:pushpak/routes/app_routes.dart';
import 'firebase_options.dart';
import 'di/service_locator.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );

  await setupLocator();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Pushpak App',
      debugShowCheckedModeBanner: false,

      // 🔥 IMPORTANT CHANGE
      // AuthGate ko ROOT banao
      initialRoute: '/',  

      routes: AppRoutes.routes,
    );
  }
}
