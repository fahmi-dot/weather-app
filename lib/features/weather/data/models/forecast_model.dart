import 'package:weather_app/features/weather/domain/entities/forecast.dart';

class ForecastModel extends Forecast {
  const ForecastModel({
    required super.temperature,
    required super.icon,
    required super.dateTime,
  });

  factory ForecastModel.fromJson(Map<String, dynamic> json) {
    return ForecastModel(
      temperature: (json['main']['temp']).toDouble(),
      icon: json['weather'][0]['icon'],
      dateTime: DateTime.fromMillisecondsSinceEpoch(json['dt'] * 1000),
    );
  }

  factory ForecastModel.fromEntity(Forecast forecast) {
    return ForecastModel(
      temperature: forecast.temperature,
      icon: forecast.icon,
      dateTime: forecast.dateTime,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'dt': dateTime.millisecondsSinceEpoch ~/ 1000,
      'main': {
        'temp': temperature,
      },
      'weather': [
        {
          'icon': icon,
        }
      ],
    };
  }

  Forecast toEntity() {
    return Forecast(
      temperature: temperature,
      icon: icon,
      dateTime: dateTime,
    );
  }
}