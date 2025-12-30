import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';
import 'package:pushpak/di/service_locator.dart';
import 'package:pushpak/viewmodels/location_viewmodel.dart';
import 'package:pushpak/viewmodels/network_viewmodel.dart';
import 'package:pushpak/viewmodels/ride_viewmodel.dart';
import 'package:pushpak/widgets/botton_nav_bar.dart';
import 'package:pushpak/widgets/location_disabled_banner.dart';
import 'package:pushpak/widgets/network_connection_banner.dart';

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

  static const double _singleBannerHeight = 48.0;
  static const Color _networkBannerColor = Color(0xFFB3261E);
  static const Color _locationBannerColor = Color(0xFF8C6A1D);

  @override
  Widget build(BuildContext context) {
    final topPadding = MediaQuery.of(context).padding.top;

    return MultiProvider(
      providers: [
        ChangeNotifierProvider<NetworkViewModel>.value(
          value: locator<NetworkViewModel>(),
        ),
        ChangeNotifierProvider<LocationViewModel>.value(
          value: locator<LocationViewModel>(),
        ),
        // 🚕 Ride (Firestore user-wise data)
        ChangeNotifierProvider<RideViewModel>(
          create: (_) => locator<RideViewModel>()..loadRecentSearches(),
    ),
      ],
      child: Scaffold(
        body: Selector2<NetworkViewModel, LocationViewModel, _BannerState>(
          selector: (_, networkVM, locationVM) => _BannerState(
            isConnected: networkVM.isConnected,
            isLocationEnabled: locationVM.isLocationEnabled,
          ),
          builder: (context, bannerState, _) {
            final bool showNetworkBanner = !bannerState.isConnected;
            final bool showLocationBanner =
                bannerState.isConnected && !bannerState.isLocationEnabled;

            final double totalBannerHeight =
                (showNetworkBanner ? _singleBannerHeight : 0.0) +
                (showLocationBanner ? _singleBannerHeight : 0.0);

            // 🔥 Status bar turant update — ab rebuild guaranteed fast hai
            SystemChrome.setSystemUIOverlayStyle(
              showNetworkBanner
                  ? const SystemUiOverlayStyle(
                      statusBarColor: _networkBannerColor,
                      statusBarIconBrightness: Brightness.light,
                    )
                  : showLocationBanner
                  ? const SystemUiOverlayStyle(
                      statusBarColor: _locationBannerColor,
                      statusBarIconBrightness: Brightness.light,
                    )
                  : SystemUiOverlayStyle.dark.copyWith(
                      statusBarColor: Colors.transparent,
                    ),
            );

            return Stack(
              children: [
                Positioned.fill(
                  top: topPadding + totalBannerHeight,
                  child: _pages[_currentIndex],
                ),

                if (showNetworkBanner)
                  Positioned(
                    top: topPadding,
                    left: 0,
                    right: 0,
                    height: _singleBannerHeight,
                    child: const NetworkConnectionBanner(),
                  ),

                if (showLocationBanner)
                  Positioned(
                    top:
                        topPadding +
                        (showNetworkBanner ? _singleBannerHeight : 0.0),
                    left: 0,
                    right: 0,
                    height: _singleBannerHeight,
                    child: const LocationDisabledBanner(),
                  ),
              ],
            );
          },
        ),
        bottomNavigationBar: BottomNavBar(
          currentIndex: _currentIndex,
          onTap: (i) => setState(() => _currentIndex = i),
        ),
      ),
    );
  }
}

// 🔥 Immutable state class for precise selector
class _BannerState {
  final bool isConnected;
  final bool isLocationEnabled;

  _BannerState({required this.isConnected, required this.isLocationEnabled});

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is _BannerState &&
          runtimeType == other.runtimeType &&
          isConnected == other.isConnected &&
          isLocationEnabled == other.isLocationEnabled;

  @override
  int get hashCode => Object.hash(isConnected, isLocationEnabled);
}
