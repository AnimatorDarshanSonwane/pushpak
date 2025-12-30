// di/service_locator.dart

import 'package:get_it/get_it.dart';

import '../services/map_service.dart';
import '../services/payment_service.dart';
import '../services/realtime_service.dart';
import '../services/auth_service.dart';
import '../services/location_service.dart';
import '../services/network_service.dart';

import '../viewmodels/home_viewmodel.dart';
import '../viewmodels/auth_viewmodel.dart';
import '../viewmodels/location_viewmodel.dart';
import '../viewmodels/network_viewmodel.dart';

final locator = GetIt.instance;

Future<void> setupLocator() async {
  // =======================
  // 🔧 SERVICES (Singleton)
  // =======================
  locator.registerLazySingleton(() => MapService());
  locator.registerLazySingleton(() => PaymentService());
  locator.registerLazySingleton(() => RealtimeService());
  locator.registerLazySingleton(() => AuthService());

  // LocationService with proper dispose
  locator.registerLazySingleton<LocationService>(
    () => LocationService(),
    dispose: (service) => service.dispose(),
  );

  locator.registerLazySingleton<NetworkService>(() => NetworkService());

  // =======================
  // 🧠 VIEW MODELS (Singleton - Critical Fix!)
  // =======================
  locator.registerLazySingleton(() => HomeViewModel());
  locator.registerLazySingleton(() => AuthViewModel());

  // 🔥 NetworkViewModel aur LocationViewModel ko singleton banao
  locator.registerLazySingleton(() => NetworkViewModel());
  locator.registerLazySingleton(
    () => LocationViewModel(locator<LocationService>()),
  );
}