import 'package:flutter/material.dart';
import '../views/home/home_view.dart';

class AppRoutes {
  static const String initial = "/";

  static Map<String, WidgetBuilder> routes = {
    "/": (context) => const HomeView(),
  };
}
