import 'dart:async';
import 'package:geolocator/geolocator.dart';

class LocationService {
  Stream<bool> locationStatusStream() async* {
    while (true) {
      bool enabled = await Geolocator.isLocationServiceEnabled();
      yield enabled;
      await Future.delayed(const Duration(seconds: 2));
    }
  }

  Future<void> openLocationSettings() async {
    await Geolocator.openLocationSettings();
  }
}
