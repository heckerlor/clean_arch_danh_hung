import '../../domain/entities/weather.dart';

class WeatherModel extends Weather {
  const WeatherModel({
    required super.id,
    required super.cityName,
    required super.temperature,
    required super.windSpeed,
    required super.weatherCode,
    required super.weatherDescription,
    required super.icon,
    super.humidity,
    super.condition,
  });

  /// Chuyển đổi mã WMO weather code sang mô tả tiếng Việt và icon
  static (String, String) _getWeatherInfo(int code) {
    if (code == 0) return ('Trời quang đãng, nắng đẹp', '☀️');
    if (code == 1 || code == 2) return ('Ít mây, trời nắng nhẹ', '🌤️');
    if (code == 3) return ('Nhiều mây, âm u', '☁️');
    if (code >= 45 && code <= 48) return ('Có sương mù', '🌫️');
    if (code >= 51 && code <= 55) return ('Mưa phùn rải rác', '🌦️');
    if (code >= 61 && code <= 65) return ('Trời có mưa rào', '🌧️');
    if (code >= 80 && code <= 82) return ('Mưa rào nặng hạt', '⛈️');
    if (code >= 95) return ('Dông bão, có sấm sét', '⚡');
    return ('Thời tiết bình thường', '⛅');
  }

  /// Tạo WeatherModel từ dữ liệu JSON trả về bởi Open-Meteo
  factory WeatherModel.fromOpenMeteoJson({
    required int id,
    required String cityName,
    required Map<String, dynamic> currentWeatherData,
  }) {
    final temp = (currentWeatherData['temperature'] as num).toDouble();
    final wind = (currentWeatherData['windspeed'] as num).toDouble();
    final code = (currentWeatherData['weathercode'] as num).toInt();
    final (desc, icon) = _getWeatherInfo(code);

    return WeatherModel(
      id: id,
      cityName: cityName,
      temperature: temp,
      windSpeed: wind,
      weatherCode: code,
      weatherDescription: desc,
      icon: icon,
      condition: desc,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'cityName': cityName,
      'temperature': temperature,
      'windSpeed': windSpeed,
      'weatherCode': weatherCode,
      'weatherDescription': weatherDescription,
      'icon': icon,
      'condition': condition,
      'humidity': humidity,
    };
  }
}
