import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';
import '../viewmodels/location_viewmodel.dart';

class LocationDisabledBanner extends StatefulWidget {
  const LocationDisabledBanner({super.key});

  @override
  State<LocationDisabledBanner> createState() => _LocationDisabledBannerState();
}

class _LocationDisabledBannerState extends State<LocationDisabledBanner> {
  static const Color bannerColor = Color(0xFF8C6A1D); // Amber-brown tone

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();

    final vm = context.watch<LocationViewModel>();
    final bool isEnabled = vm.isLocationEnabled;

    // 🔥 Har baar jab isLocationEnabled change ho, status bar update karo
    SystemChrome.setSystemUIOverlayStyle(
      isEnabled
          ? SystemUiOverlayStyle.dark.copyWith(
              statusBarColor: Colors.transparent, // Safe default
            )
          : const SystemUiOverlayStyle(
              statusBarColor: bannerColor,
              statusBarIconBrightness: Brightness.light,
              statusBarBrightness: Brightness.dark,
            ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final vm = context.watch<LocationViewModel>();

    // Agar location enabled hai → banner hide kar do
    if (vm.isLocationEnabled) {
      return const SizedBox.shrink();
    }

    // Banner show karo jab location disabled ho
    return Container(
      height: 48,
      color: bannerColor,
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: InkWell(
        onTap: vm.openSettings,
        child: const Row(
          children: [
            Icon(Icons.location_off, color: Colors.white, size: 20),
            SizedBox(width: 12),
            Expanded(
              child: Text(
                "Location sharing disabled. Tap here to enable",
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 14,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ),
            Icon(Icons.chevron_right, color: Colors.white),
          ],
        ),
      ),
    );
  }
}