import 'package:dartz/dartz.dart';
import 'package:geolocator/geolocator.dart';
import 'package:weather_app/core/error/exception.dart';
import 'package:weather_app/core/error/failure.dart';
import 'package:weather_app/features/weather/data/datasources/remote/weather_remote_datasource.dart';
import 'package:weather_app/features/weather/domain/entities/weather.dart';
import 'package:weather_app/features/weather/domain/repositories/weather_repository.dart';

class WeatherRepositoryImpl implements WeatherRepository {
  final WeatherRemoteDataSource weatherRemoteDataSource;

  WeatherRepositoryImpl({required this.weatherRemoteDataSource});

  @override
  Future<Either<Failure, Weather>> getWeather() async {
    try {
      final position = await Geolocator.getCurrentPosition();
      final weatherModel = await weatherRemoteDataSource.getWeather(
        position.latitude,
        position.longitude,
      );

      return Right(weatherModel.toEntity());
    } on ServerException {
      return Left(ServerFailure());
    }
  }

  @override
  Future<Either<Failure, Weather>> getWeatherByCity(String cityName) async {
    try {
      final weatherModel = await weatherRemoteDataSource.getWeatherByCity(cityName);

      return Right(weatherModel.toEntity());
    } on ServerException {
      return Left(ServerFailure());
    }
  }  
}