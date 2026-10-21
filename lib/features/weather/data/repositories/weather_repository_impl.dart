import '../../../../core/errors/exceptions.dart';
import '../../../../core/errors/failures.dart';
import '../../domain/entities/weather.dart';
import '../../domain/repositories/weather_repository.dart';
import '../datasources/weather_remote_datasource.dart';

class WeatherRepositoryImpl implements WeatherRepository {
  final WeatherRemoteDataSource remoteDataSource;

  WeatherRepositoryImpl({required this.remoteDataSource});

  @override
  Future<List<Weather>> getWeatherList() async {
    try {
      final weatherModels = await remoteDataSource.fetchWeatherListFromApi();
      return weatherModels;
    } on ServerException catch (e) {
      throw ServerFailure(e.message);
    } catch (e) {
      throw const NetworkFailure('Không thể kết nối. Kiểm tra mạng internet!');
    }
  }

  @override
  Future<Weather> getWeather(String cityName) async {
    final weatherList = await getWeatherList();
    final normalizedInput = _normalizeString(cityName);
    try {
      return weatherList.firstWhere(
        (w) => _normalizeString(w.cityName) == normalizedInput,
      );
    } catch (_) {
      throw const NotFoundFailure('Không tìm thấy thành phố');
    }
  }

  String _normalizeString(String str) {
    return str
        .toLowerCase()
        .replaceAll(RegExp(r'[àáạảãâầấậẩẫăằắặẳẵ]'), 'a')
        .replaceAll(RegExp(r'[èéẹẻẽêềếệểễ]'), 'e')
        .replaceAll(RegExp(r'[ìíịỉĩ]'), 'i')
        .replaceAll(RegExp(r'[òóọỏõôồốộổỗơờớợởỡ]'), 'o')
        .replaceAll(RegExp(r'[ùúụủũưừứựửữ]'), 'u')
        .replaceAll(RegExp(r'[ỳýỵỷỹ]'), 'y')
        .replaceAll(RegExp(r'[đ]'), 'd')
        .replaceAll(' ', '');
  }
}
