import 'dart:async';
import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';

class LocationService {
  StreamSubscription<ServiceStatus>? _serviceStatusSubscription;
  final StreamController<bool> _statusController = StreamController<bool>.broadcast();

  LocationService() {
    _init();
  }

  void _init() {
    // 🔹 Immediate first emit
    _checkAndEmit();

    // 🔹 Real-time updates jab system location service on/off ho
    _serviceStatusSubscription = Geolocator.getServiceStatusStream().listen(
      (ServiceStatus status) {
        final bool enabled = status == ServiceStatus.enabled;
        _emit(enabled);
      },
      onError: (error) {
        debugPrint('Location service stream error: $error');
        _emit(false); // Safe fallback
      },
    );
  }

  Future<void> _checkAndEmit() async {
    try {
      final bool enabled = await Geolocator.isLocationServiceEnabled();
      _emit(enabled);
    } catch (e) {
      debugPrint('Initial location check failed: $e');
      _emit(false);
    }
  }

  void _emit(bool enabled) {
    if (!_statusController.isClosed) {
      _statusController.add(enabled);
    }
  }

  /// 🔹 Public stream - ViewModel isko listen karega
  Stream<bool> locationStatusStream() => _statusController.stream;

  /// 🔹 Current status ke liye direct check (initial load ke liye useful)
  Future<bool> isLocationEnabled() async {
    try {
      return await Geolocator.isLocationServiceEnabled();
    } catch (e) {
      debugPrint('isLocationEnabled error: $e');
      return false;
    }
  }

  /// 🔹 Settings open karo
  Future<void> openLocationSettings() async {
    try {
      await Geolocator.openLocationSettings();
    } catch (e) {
      debugPrint('Failed to open location settings: $e');
    }
  }

  /// 🔹 Cleanup - Bahut zaroori! (App dispose hone pe call karo)
  void dispose() {
    _serviceStatusSubscription?.cancel();
    _statusController.close();
  }
}