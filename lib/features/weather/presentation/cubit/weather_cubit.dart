import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../../core/errors/failures.dart';
import '../../domain/usecases/get_weather_usecase.dart';
import 'weather_state.dart';

class WeatherCubit extends Cubit<WeatherState> {
  final GetWeatherListUseCase getWeatherListUseCase;

  WeatherCubit({required this.getWeatherListUseCase}) : super(WeatherInitial());

  Future<void> fetchWeather() async {
    emit(WeatherLoading());
    try {
      final weatherList = await getWeatherListUseCase();
      emit(WeatherLoaded(weatherList));
    } on Failure catch (failure) {
      emit(WeatherError(failure.message));
    } catch (e) {
      emit(const WeatherError('Có lỗi xảy ra, vui lòng thử lại!'));
    }
  }
}
