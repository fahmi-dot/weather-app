import 'package:dartz/dartz.dart';
import 'package:weather_app/core/error/failure.dart';
import 'package:weather_app/features/weather/domain/entities/weather.dart';

abstract class WeatherRepository {
    Future<Either<Failure, Weather>> getWeather();
    Future<Either<Failure, Weather>> getWeatherByCity(String cityName);
}