import 'package:dartz/dartz.dart';
import 'package:weather_app/core/error/failure.dart';
import 'package:weather_app/features/weather/domain/entities/forecast.dart';
import 'package:weather_app/features/weather/domain/repositories/forecast_repository.dart';

class GetForecastUseCase {
  final ForecastRepository  _forecastRepository;

  GetForecastUseCase(this._forecastRepository);

  Future<Either<Failure, List<Forecast>>> execute() async {
    return await _forecastRepository.getForecast();
  }
}