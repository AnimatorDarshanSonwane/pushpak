import 'package:flutter/material.dart';
import '../services/location_service.dart';

class LocationViewModel extends ChangeNotifier {
  final LocationService _locationService;

  bool _isLocationEnabled = true;
  bool get isLocationEnabled => _isLocationEnabled;

  LocationViewModel(this._locationService) {
    _listen();
  }

  void _listen() {
    _locationService.locationStatusStream().listen((status) {
      _isLocationEnabled = status;
      notifyListeners();
    });
  }

  void openSettings() {
    _locationService.openLocationSettings();
  }
}
