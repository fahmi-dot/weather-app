import 'dart:convert';

import 'package:weather_app/core/network/api_client.dart';
import 'package:weather_app/features/weather/data/models/weather_model.dart';

abstract class WeatherRemoteDataSource {
  Future<WeatherModel> getWeather(double lat, double lon);
  Future<WeatherModel> getWeatherByCity(String cityName);
}

class WeatherRemoteDataSourceImpl implements WeatherRemoteDataSource {
  final ApiClient apiClient;

  WeatherRemoteDataSourceImpl({required this.apiClient});
  
  @override
  Future<WeatherModel> getWeather(double lat, double lon) async {
    final response = await apiClient.get(
      'weather',
      queryParameters: {
        'lat': lat,
        'lon': lon,
      }
    );

    if (response.statusCode == 200) {
      final data = json.decode(response.body);

      return WeatherModel.fromJson(data);
    } else {
      throw Exception('Failed to fetch weather: ${response.statusCode}');
    }
  }

  @override
  Future<WeatherModel> getWeatherByCity(String cityName) async {
    final response = await apiClient.get(
      'weather',
      queryParameters: {
        'q': cityName,
      }
    );

    if (response.statusCode == 200) {
      final data = json.decode(response.body);

      return WeatherModel.fromJson(data);
    } else {
      throw Exception('Failed to fetch weather by city: ${response.statusCode}');
    }
  }  
}