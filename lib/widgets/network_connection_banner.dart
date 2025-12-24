import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../viewmodels/network_viewmodel.dart';

class NetworkConnectionBanner extends StatelessWidget {
  const NetworkConnectionBanner({super.key});

  static const double height = 48.0;
  static const Color bannerColor = Color(0xFFB3261E);

  @override
  Widget build(BuildContext context) {
    final isConnected = context.watch<NetworkViewModel>().isConnected;

    if (isConnected) return const SizedBox.shrink();

    return Container(
      height: height,
      color: bannerColor,
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: const Row(
        children: [
          Icon(Icons.wifi_off, color: Colors.white, size: 20),
          SizedBox(width: 12),
          Expanded(
            child: Text(
              "No internet connection",
              style: TextStyle(color: Colors.white, fontSize: 14, fontWeight: FontWeight.w500),
            ),
          ),
        ],
      ),
    );
  }
}