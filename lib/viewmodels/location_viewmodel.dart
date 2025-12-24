import 'dart:async';

import 'package:flutter/material.dart';
import '../services/location_service.dart';

class LocationViewModel extends ChangeNotifier {
  final LocationService _locationService;

  bool _isLocationEnabled = true; // Default true (safe assumption)
  bool get isLocationEnabled => _isLocationEnabled;

  StreamSubscription<bool>? _statusSubscription;

  LocationViewModel(this._locationService) {
    _initLocationStatus();
  }

  Future<void> _initLocationStatus() async {
    try {
      // 🔹 Step 1: Initial status check (bahut zaroori!)
      final initialStatus = await _locationService.isLocationEnabled();
      _updateStatus(initialStatus);

      // 🔹 Step 2: Listen for future changes
      _statusSubscription = _locationService
          .locationStatusStream()
          .listen(_updateStatus, onError: _handleError);
    } catch (e) {
      debugPrint('Location status init failed: $e');
      // Fallback: assume enabled or handle as per your app logic
      _updateStatus(true);
    }
  }

  void _updateStatus(bool status) {
    if (_isLocationEnabled != status) {
      _isLocationEnabled = status;
      debugPrint('📍 Location permission status changed: $_isLocationEnabled');
      notifyListeners(); // 🔥 Banner aur UI immediately update hoga
    }
  }

  void _handleError(Object error) {
    debugPrint('Location status stream error: $error');
    // Optional: retry logic ya user ko inform karo
  }

  /// User ne banner tap kiya → settings open karo aur status monitor karte raho
  Future<void> openSettings() async {
    await _locationService.openLocationSettings();

    // Bonus: Settings se wapas aane ke baad force check (Android pe helpful)
    // Kuch devices pe stream delay se fire karta hai
    Future.delayed(const Duration(seconds: 2), () async {
      try {
        final current = await _locationService.isLocationEnabled();
        _updateStatus(current);
      } catch (_) {}
    });
  }

  @override
  void dispose() {
    _statusSubscription?.cancel();
    super.dispose();
  }
}