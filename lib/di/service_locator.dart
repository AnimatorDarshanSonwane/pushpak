import 'package:get_it/get_it.dart';
import '../services/map_service.dart';
import '../services/payment_service.dart';
import '../services/realtime_service.dart';
import '../viewmodels/home_viewmodel.dart';
import '../services/auth_service.dart';
import '../viewmodels/auth_viewmodel.dart';

final locator = GetIt.instance;

Future<void> setupLocator() async {
  // Services
  locator.registerLazySingleton(() => MapService());
  locator.registerLazySingleton(() => PaymentService());
  locator.registerLazySingleton(() => RealtimeService());
  
  // inside setupLocator()
  locator.registerLazySingleton(() => AuthService());
  locator.registerFactory(() => AuthViewModel());

  // ViewModels
  locator.registerFactory(() => HomeViewModel());
}
