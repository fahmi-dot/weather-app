import 'package:dartz/dartz.dart';
import 'package:weather_app/core/error/failure.dart';
import 'package:weather_app/features/weather/domain/entities/forecast.dart';
import 'package:weather_app/features/weather/domain/repositories/forecast_repository.dart';

class GetForecastByCityUseCase {
  final ForecastRepository _forecastRepository;

  GetForecastByCityUseCase(this._forecastRepository);

  Future<Either<Failure, List<Forecast>>> execute(String cityName) async {
    return await _forecastRepository.getForecastByCity(cityName);
  }
}