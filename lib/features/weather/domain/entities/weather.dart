import 'package:equatable/equatable.dart';

class Weather extends Equatable {
  final String cityName;
  final double temperature;
  final String description;
  final int humidity;
  final double windSpeed;
  final int pressure;
  final DateTime sunrise;
  final DateTime sunset;
  final String icon;
  final DateTime dateTime;

  const Weather({
    required this.cityName,
    required this.temperature,
    required this.description,
    required this.humidity,
    required this.windSpeed,
    required this.pressure,
    required this.sunrise,
    required this.sunset,
    required this.icon,
    required this.dateTime,
  });

  @override
  List<Object?> get props => [
    cityName,
    temperature,
    description,
    humidity,
    windSpeed,
    pressure,
    sunrise,
    sunset,
    icon,
    dateTime,
  ];
}
