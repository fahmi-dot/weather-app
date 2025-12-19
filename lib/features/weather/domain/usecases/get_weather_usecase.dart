import 'package:dartz/dartz.dart';
import 'package:weather_app/core/error/failure.dart';
import 'package:weather_app/features/weather/domain/entities/weather.dart';
import 'package:weather_app/features/weather/domain/repositories/weather_repository.dart';

class GetWeatherUseCase {
  final WeatherRepository  _weatherRepository;

  GetWeatherUseCase(this._weatherRepository);

  Future<Either<Failure, Weather>> execute() async {
    return await _weatherRepository.getWeather();
  }
}