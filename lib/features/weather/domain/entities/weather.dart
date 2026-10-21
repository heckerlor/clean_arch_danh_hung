import 'package:equatable/equatable.dart';

/// Entity đại diện cho thông tin thời tiết của một thành phố
class Weather extends Equatable {
  final int id;
  final String cityName;       // Tên thành phố (Hà Nội, TP.HCM,...)
  final double temperature;     // Nhiệt độ hiện tại (°C)
  final double windSpeed;       // Tốc độ gió (km/h)
  final int weatherCode;        // Mã thời tiết theo WMO
  final String weatherDescription; // Mô tả thời tiết tiếng Việt (Nắng, Mưa, Có mây,...)
  final String icon;            // Biểu tượng cảm xúc (☀️, ⛅, 🌧️,...)
  final int? humidity;          // Độ ẩm (%)
  final String? condition;       // Tình trạng thời tiết

  const Weather({
    this.id = 0,
    required this.cityName,
    required this.temperature,
    this.windSpeed = 0.0,
    this.weatherCode = 0,
    this.weatherDescription = '',
    this.icon = '☀️',
    this.humidity,
    this.condition,
  });

  @override
  List<Object?> get props => [
        id,
        cityName,
        temperature,
        windSpeed,
        weatherCode,
        weatherDescription,
        icon,
        humidity,
        condition,
      ];
}
