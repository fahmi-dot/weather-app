import 'package:dartz/dartz.dart';
import 'package:weather_app/core/error/failure.dart';
import 'package:weather_app/features/weather/domain/entities/weather.dart';
import 'package:weather_app/features/weather/domain/repositories/weather_repository.dart';

class GetWeatherByCityUseCase {
  final WeatherRepository _weatherRepository;

  GetWeatherByCityUseCase(this._weatherRepository);

  Future<Either<Failure, Weather>> execute(String cityName) async {
    return await _weatherRepository.getWeatherByCity(cityName);
  }
}