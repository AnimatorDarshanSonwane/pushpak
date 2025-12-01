import 'package:flutter/material.dart';
import '../di/service_locator.dart';
import '../services/map_service.dart';
import '../services/payment_service.dart';
import '../services/realtime_service.dart';

class HomeViewModel extends ChangeNotifier {
  final mapService = locator<MapService>();
  final paymentService = locator<PaymentService>();
  final realtimeService = locator<RealtimeService>();

  String? currentAddress;
  bool isLoading = false;

  Future<void> loadUserAddress() async {
    isLoading = true;
    notifyListeners();

    currentAddress = await mapService.getAddressFromLatLng(19.0760, 72.8777);

    isLoading = false;
    notifyListeners();
  }

  Future<void> testPayment() async {
    await paymentService.makePayment(199.0);
  }
}
