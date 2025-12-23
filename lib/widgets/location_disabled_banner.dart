import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';
import '../viewmodels/location_viewmodel.dart';

class LocationDisabledBanner extends StatelessWidget {
  const LocationDisabledBanner({super.key});

  static const Color bannerColor = Color(0xFF8C6A1D);

  @override
  Widget build(BuildContext context) {
    final vm = context.watch<LocationViewModel>();

    if (vm.isLocationEnabled) {
      SystemChrome.setSystemUIOverlayStyle(
        SystemUiOverlayStyle.dark,
      );
      return const SizedBox.shrink();
    }

    SystemChrome.setSystemUIOverlayStyle(
      const SystemUiOverlayStyle(
        statusBarColor: bannerColor,
        statusBarIconBrightness: Brightness.light,
        statusBarBrightness: Brightness.dark,
      ),
    );

    return Container(
      height: 48,
      color: bannerColor,
      padding: const EdgeInsets.symmetric(horizontal: 12),
      child: InkWell(
        onTap: vm.openSettings,
        child: Row(
          children: const [
            Icon(Icons.location_off, color: Colors.white),
            SizedBox(width: 10),
            Expanded(
              child: Text(
                "Location sharing disabled. Tap here to enable",
                style: TextStyle(color: Colors.white),
              ),
            ),
            Icon(Icons.chevron_right, color: Colors.white),
          ],
        ),
      ),
    );
  }
}
