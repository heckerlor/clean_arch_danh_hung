import '../entities/weather.dart';

abstract class WeatherRepository {
  Future<List<Weather>> getWeatherList();
  Future<Weather> getWeather(String cityName);
}
