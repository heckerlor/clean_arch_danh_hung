import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:clean_arch_demo/core/errors/failures.dart';
// Import tầng Domain và Core Errors
import 'package:clean_arch_demo/features/weather/domain/entities/weather.dart';
import 'package:clean_arch_demo/features/weather/domain/repositories/weather_repository.dart';
import 'package:clean_arch_demo/features/weather/domain/usecases/get_weather_usecase.dart';

// Tạo lớp Mock Repository cho Thời tiết
class MockWeatherRepository extends Mock implements WeatherRepository {}

void main() {
  late GetWeatherUseCase useCase;
  late MockWeatherRepository mockRepository;

  setUp(() {
    mockRepository = MockWeatherRepository();
    // Tiêm Mock Repository vào UseCase (Dependency Injection)
    useCase = GetWeatherUseCase(mockRepository);
  });

  // Dữ liệu giả lập (Mock Data) chuẩn entity Weather cho Đà Nẵng
  const Weather thoiTietGia = Weather(
    cityName: 'Da Nang',
    temperature: 31.5,
    humidity: 75,
    condition: 'Nắng đẹp',
  );

  test(
    'Test 1: Khi Repository trả về dữ liệu thời tiết thành công, '
    'UseCase phải trả về đúng đối tượng Weather',
    () async {
      // 1. Arrange: Thiết lập hành vi giả lập cho Repository
      when(() => mockRepository.getWeather(any()))
          .thenAnswer((_) async => thoiTietGia);

      // 2. Act: Thực thi UseCase với tham số truyền vào là tên thành phố
      final ketQua = await useCase('Da Nang');

      // 3. Assert: Kiểm tra tính đúng đắn của kết quả
      expect(ketQua, equals(thoiTietGia));
      expect(ketQua.temperature, equals(31.5));
      expect(ketQua.cityName, equals('Da Nang'));

      // Xác minh hàm getWeather của repository đã được gọi đúng 1 lần với tham số 'Da Nang'
      verify(() => mockRepository.getWeather('Da Nang')).called(1);

      verifyNoMoreInteractions(mockRepository);
    },
  );

  test(
    'Test 2: Khi Repository ném ServerFailure, '
    'UseCase cũng phải ném ServerFailure (không nuốt lỗi)',
    () async {
      // 1. Arrange: Giả lập repository gặp lỗi máy chủ khi gọi API thời tiết
      when(() => mockRepository.getWeather(any()))
          .thenThrow(const ServerFailure('Lỗi kết nối máy chủ thời tiết'));

      // 2 & 3. Act & Assert: Kiểm tra xem UseCase có văng đúng ngoại lệ không
      expect(
        () => useCase('Da Nang'),
        throwsA(isA<ServerFailure>()), 
      );
    },
  );

  test(
    'Test 3: Khi truyền tên thành phố không tồn tại, '
    'Repository trả về lỗi NotFoundFailure thì UseCase cũng phải ném lỗi đó',
    () async {
      // 1. Arrange
      when(() => mockRepository.getWeather('SaiTen'))
          .thenThrow(const NotFoundFailure('Không tìm thấy thành phố'));

      // 2 & 3. Act & Assert
      expect(
        () => useCase('SaiTen'),
        throwsA(isA<NotFoundFailure>()),
      );
      
      verify(() => mockRepository.getWeather('SaiTen')).called(1);
    },
  );
}