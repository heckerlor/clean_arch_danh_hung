// ==========================================
// FILE: lib/features/weather/data/datasources/weather_remote_datasource.dart
// TẦNG: DATA (Nguồn dữ liệu từ xa)
// MỤC ĐÍCH: Giao tiếp TRỰC TIẾP với REST API dự báo thời tiết Open-Meteo.
// API DÙNG: https://api.open-meteo.com/v1/forecast
// ==========================================

import 'dart:convert';
import 'package:http/http.dart' as http;

import '../../../../core/errors/exceptions.dart';
import '../models/weather_model.dart';

// Interface cho DataSource
abstract class WeatherRemoteDataSource {
  Future<List<WeatherModel>> fetchWeatherListFromApi();
}

// Cài đặt thật sự - gọi API thời tiết thực tế cho các thành phố Việt Nam
class WeatherRemoteDataSourceImpl implements WeatherRemoteDataSource {
  final http.Client client;

  WeatherRemoteDataSourceImpl({required this.client});

  // Danh sách các thành phố lớn tại Việt Nam
  static const List<Map<String, dynamic>> _vietnamCities = [
    {'id': 1, 'name': 'Hà Nội', 'lat': 21.0285, 'lon': 105.8542},
    {'id': 2, 'name': 'TP. Hồ Chí Minh', 'lat': 10.8231, 'lon': 106.6297},
    {'id': 3, 'name': 'Đà Nẵng', 'lat': 16.0544, 'lon': 108.2022},
    {'id': 4, 'name': 'Hải Phòng', 'lat': 20.8449, 'lon': 106.6881},
    {'id': 5, 'name': 'Nha Trang', 'lat': 12.2388, 'lon': 109.1967},
    {'id': 6, 'name': 'Cần Thơ', 'lat': 10.0452, 'lon': 105.7469},
    {'id': 7, 'name': 'Đà Lạt', 'lat': 11.9404, 'lon': 108.4583},
    {'id': 8, 'name': 'Huế', 'lat': 16.4637, 'lon': 107.5909},
  ];

  @override
  Future<List<WeatherModel>> fetchWeatherListFromApi() async {
    final lats = _vietnamCities.map((c) => c['lat']).join(',');
    final lons = _vietnamCities.map((c) => c['lon']).join(',');

    // Gọi Open-Meteo REST API miễn phí, không cần API Key
    final url = Uri.parse(
      'https://api.open-meteo.com/v1/forecast?latitude=$lats&longitude=$lons&current_weather=true',
    );

    final response = await client.get(url);

    if (response.statusCode == 200) {
      final decoded = json.decode(response.body);

      // Khi truyền nhiều toạ độ, Open-Meteo trả về mảng kết quả
      final List<dynamic> dataList =
          decoded is List ? decoded : [decoded];

      final List<WeatherModel> results = [];
      for (int i = 0; i < dataList.length && i < _vietnamCities.length; i++) {
        final cityInfo = _vietnamCities[i];
        final currentWeather = dataList[i]['current_weather'] as Map<String, dynamic>;
        results.add(
          WeatherModel.fromOpenMeteoJson(
            id: cityInfo['id'] as int,
            cityName: cityInfo['name'] as String,
            currentWeatherData: currentWeather,
          ),
        );
      }
      return results;
    } else {
      throw ServerException(
        'Máy chủ thời tiết phản hồi với mã lỗi: ${response.statusCode}',
      );
    }
  }
}
