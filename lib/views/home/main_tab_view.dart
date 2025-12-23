import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:pushpak/widgets/botton_nav_bar.dart';
import 'package:pushpak/widgets/location_disabled_banner.dart';
import 'package:pushpak/viewmodels/location_viewmodel.dart';
import 'package:pushpak/di/service_locator.dart';

import '../home/home_view.dart';
import '../services/services_view.dart';
import '../activity/activity_view.dart';
import '../profile/profile_view.dart';

class MainTabView extends StatefulWidget {
  const MainTabView({super.key});

  @override
  State<MainTabView> createState() => _MainTabViewState();
}

class _MainTabViewState extends State<MainTabView> {
  int _currentIndex = 0;

  final List<Widget> _pages = const [
    HomeView(),
    ServicesView(),
    ActivityView(),
    ProfileView(),
  ];

  void _onTabChanged(int index) {
    setState(() {
      _currentIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    final double topPadding = MediaQuery.of(context).padding.top;

    return ChangeNotifierProvider(
      create: (_) => locator<LocationViewModel>(),
      child: Scaffold(
        body: Stack(
          children: [
            // 📱 APP CONTENT (BELOW STATUS BAR)
            Positioned.fill(
              top: topPadding,
              child: _pages[_currentIndex],
            ),

            // 🔔 LOCATION BANNER (ALSO BELOW STATUS BAR)
            Positioned(
              top: topPadding,
              left: 0,
              right: 0,
              child: const LocationDisabledBanner(),
            ),
          ],
        ),
        bottomNavigationBar: BottomNavBar(
          currentIndex: _currentIndex,
          onTap: _onTabChanged,
        ),
      ),
    );
  }
}
