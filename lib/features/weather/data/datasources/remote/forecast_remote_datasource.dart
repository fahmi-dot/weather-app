import 'dart:convert';

import 'package:weather_app/core/network/api_client.dart';
import 'package:weather_app/features/weather/data/models/forecast_model.dart';

abstract class ForecastRemoteDataSource {
  Future<List<ForecastModel>> getForecast(double lat, double lon);
  Future<List<ForecastModel>> getForecastByCity(String cityName);
}

class ForecastRemoteDataSourceImpl implements ForecastRemoteDataSource {
  final ApiClient apiClient;

  ForecastRemoteDataSourceImpl({required this.apiClient});
  
  @override
  Future<List<ForecastModel>> getForecast(double lat, double lon) async {
    final response = await apiClient.get(
      'forecast',
      queryParameters: {
        'lat': lat.toString(),
        'lon': lon.toString(),
      }
    );

    if (response.statusCode == 200) {
      final data = json.decode(response.body);
      final dataList = data['list'] as List;

      return dataList.map((d) => ForecastModel.fromJson(d)).toList();
    } else {
      throw Exception('Failed to fetch forecast: ${response.statusCode}');
    }
  }

  @override
  Future<List<ForecastModel>> getForecastByCity(String cityName) async {
    final response = await apiClient.get(
      'forecast',
      queryParameters: {
        'q': cityName,
      }
    );

    if (response.statusCode == 200) {
      final data = json.decode(response.body);
      final dataList = data['list'] as List;

      return dataList.map((d) => ForecastModel.fromJson(d)).toList();
    } else {
      throw Exception('Failed to fetch forecast by city: ${response.statusCode}');
    }
  }  
}