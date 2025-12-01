import 'package:flutter/material.dart';
import 'app.dart';
import 'di/service_locator.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // Register all dependencies
  await setupLocator();

  runApp(const MyApp());
}
