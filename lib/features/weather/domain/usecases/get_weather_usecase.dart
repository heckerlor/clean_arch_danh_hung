import '../entities/weather.dart';
import '../repositories/weather_repository.dart';

class GetWeatherUseCase {
  final WeatherRepository repository;

  GetWeatherUseCase(this.repository);

  Future<Weather> call(String cityName) async {
    return await repository.getWeather(cityName);
  }
}

class GetWeatherListUseCase {
  final WeatherRepository repository;

  GetWeatherListUseCase(this.repository);

  Future<List<Weather>> call() async {
    return await repository.getWeatherList();
  }
}
