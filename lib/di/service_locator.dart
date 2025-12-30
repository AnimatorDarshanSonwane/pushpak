// di/service_locator.dart

import 'package:get_it/get_it.dart';

// 🔹 Datasources
import 'package:pushpak/data/datasources/local/recent_search_local_ds.dart';

// 🔹 Repositories
import 'package:pushpak/data/repositories/recent_search_repository_impl.dart';
import 'package:pushpak/domain/repositories/recent_search_repository.dart';

// 🔹 Services
import '../services/map_service.dart';
import '../services/payment_service.dart';
import '../services/realtime_service.dart';
import '../services/auth_service.dart';
import '../services/location_service.dart';
import '../services/network_service.dart';

// 🔹 ViewModels
import '../viewmodels/home_viewmodel.dart';
import '../viewmodels/auth_viewmodel.dart';
import '../viewmodels/location_viewmodel.dart';
import '../viewmodels/network_viewmodel.dart';
import '../viewmodels/ride_viewmodel.dart';

final locator = GetIt.instance;

Future<void> setupLocator() async {
  // =======================
  // 🔧 SERVICES (Singleton)
  // =======================
  locator.registerLazySingleton(() => MapService());
  locator.registerLazySingleton(() => PaymentService());
  locator.registerLazySingleton(() => RealtimeService());
  locator.registerLazySingleton(() => AuthService());

  locator.registerLazySingleton<NetworkService>(() => NetworkService());

  // LocationService with proper dispose
  locator.registerLazySingleton<LocationService>(
    () => LocationService(),
    dispose: (service) => service.dispose(),
  );

  // =======================
  // 📦 DATASOURCES
  // =======================
  locator.registerLazySingleton(
    () => RecentSearchLocalDatasource(),
  );

  // =======================
  // 🗄️ REPOSITORIES
  // =======================
  locator.registerLazySingleton<RecentSearchRepository>(
    () => RecentSearchRepositoryImpl(
      locator<RecentSearchLocalDatasource>(),
    ),
  );

  // =======================
  // 🧠 VIEW MODELS
  // =======================

  // App-level VMs
  locator.registerLazySingleton(() => HomeViewModel());
  locator.registerLazySingleton(() => AuthViewModel());

  locator.registerLazySingleton(() => NetworkViewModel());
  locator.registerLazySingleton(
    () => LocationViewModel(locator<LocationService>()),
  );

  // 🚕 RideViewModel (❗ FACTORY – VERY IMPORTANT)
  locator.registerFactory(
    () => RideViewModel(
      locator<RecentSearchRepository>(),
    ),
  );
}
