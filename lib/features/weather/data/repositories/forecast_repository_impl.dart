import 'package:dartz/dartz.dart';
import 'package:geolocator/geolocator.dart';
import 'package:weather_app/core/error/exception.dart';
import 'package:weather_app/core/error/failure.dart';
import 'package:weather_app/features/weather/data/datasources/remote/forecast_remote_datasource.dart';
import 'package:weather_app/features/weather/domain/entities/forecast.dart';
import 'package:weather_app/features/weather/domain/repositories/forecast_repository.dart';

class ForecastRepositoryImpl implements ForecastRepository {
  final ForecastRemoteDataSource forecastRemoteDataSource;

  ForecastRepositoryImpl({required this.forecastRemoteDataSource});

  @override
  Future<Either<Failure, List<Forecast>>> getForecast() async {
    try {
      final position = await Geolocator.getCurrentPosition();
      final forecastModel = await forecastRemoteDataSource.getForecast(
        position.latitude,
        position.longitude,
      );

      return Right(forecastModel.map((f) => f.toEntity()).toList());
    } on ServerException {
      return Left(ServerFailure());
    }
  }

  @override
  Future<Either<Failure, List<Forecast>>> getForecastByCity(String cityName) async {
    try {
      final forecastModel = await forecastRemoteDataSource.getForecastByCity(cityName);

      return Right(forecastModel.map((f) => f.toEntity()).toList());
    } on ServerException {
      return Left(ServerFailure());
    }
  }  
}