import 'package:dartz/dartz.dart';
import 'package:weather_app/core/error/failure.dart';
import 'package:weather_app/features/weather/domain/entities/forecast.dart';

abstract class ForecastRepository {
    Future<Either<Failure, List<Forecast>>> getForecast();
    Future<Either<Failure, List<Forecast>>> getForecastByCity(String cityName);
}