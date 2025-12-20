import 'package:equatable/equatable.dart';

class Forecast extends Equatable {
  final double temperature;
  final String icon;
  final DateTime dateTime;

  const Forecast({
    required this.temperature,
    required this.icon,
    required this.dateTime,
  });

  @override
  List<Object?> get props => [
    temperature,
    icon,
    dateTime,
  ];
}