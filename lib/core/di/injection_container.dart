import 'package:get_it/get_it.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import '../api/api_client.dart';
import '../services/secure_storage_service.dart';
import '../../data/services/user_service.dart';

final sl = GetIt.instance;

Future<void> initDependencies() async {
  // Config
  const storage = FlutterSecureStorage();
  sl.registerLazySingleton<FlutterSecureStorage>(() => storage);
  sl.registerLazySingleton<SecureStorageService>(() => SecureStorageService(sl()));

  // Core
  sl.registerLazySingleton<ApiClient>(() => ApiClient(sl()));

  // Services
  sl.registerLazySingleton<UserService>(() => UserService(sl()));

  // Use Cases
  // sl.registerLazySingleton(() => LoginUseCase(sl()));
}
