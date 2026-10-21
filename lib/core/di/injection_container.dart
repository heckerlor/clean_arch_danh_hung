import 'package:get_it/get_it.dart';
import 'package:http/http.dart' as http;
import '../../features/weather/data/datasources/weather_remote_datasource.dart';
import '../../features/weather/data/repositories/weather_repository_impl.dart';
import '../../features/weather/domain/repositories/weather_repository.dart';
import '../../features/weather/domain/usecases/get_weather_usecase.dart';
import '../../features/weather/presentation/cubit/weather_cubit.dart';

final sl = GetIt.instance;

Future<void> initDependencies() async {
  // Cubit
  sl.registerFactory(
    () => WeatherCubit(getWeatherListUseCase: sl()),
  );

  // UseCase
  sl.registerLazySingleton(
    () => GetWeatherListUseCase(sl()),
  );
  sl.registerLazySingleton(
    () => GetWeatherUseCase(sl()),
  );

  // Repository
  sl.registerLazySingleton<WeatherRepository>(
    () => WeatherRepositoryImpl(remoteDataSource: sl()),
  );

  // Data Source
  sl.registerLazySingleton<WeatherRemoteDataSource>(
    () => WeatherRemoteDataSourceImpl(client: sl()),
  );

  // External
  sl.registerLazySingleton(() => http.Client());
}
