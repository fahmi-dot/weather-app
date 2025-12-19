import 'package:weather_app/features/weather/domain/entities/weather.dart';

class WeatherModel extends Weather {
  const WeatherModel({
    required super.cityName,
    required super.temperature,
    required super.description,
    required super.humidity,
    required super.windSpeed,
    required super.icon,
    required super.dateTime,
  });

  factory WeatherModel.fromJson(Map<String, dynamic> json) {
    return WeatherModel(
      cityName: json['name'],
      temperature: (json['main']['temp']).toDouble(),
      description: json['weather'][0]['description'],
      humidity: json['main']['humidity'],
      windSpeed: (json['wind']['speed']).toDouble(),
      icon: json['weather'][0]['icon'],
      dateTime: DateTime.fromMillisecondsSinceEpoch(json['dt'] * 1000),
    );
  }

  factory WeatherModel.fromEntity(Weather weather) {
    return WeatherModel(
      cityName: weather.cityName,
      temperature: weather.temperature,
      description: weather.description,
      humidity: weather.humidity,
      windSpeed: weather.windSpeed,
      icon: weather.icon,
      dateTime: weather.dateTime,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'dt': dateTime.millisecondsSinceEpoch ~/ 1000,
      'main': {
        'temp': temperature,
        'humidity': humidity,
      },
      'weather': [
        {
          'description': description,
          'icon': icon,
        }
      ],
      'wind': {
        'speed': windSpeed,
      },
    };
  }

  Weather toEntity() {
    return Weather(
      cityName: cityName,
      temperature: temperature,
      description: description,
      humidity: humidity,
      windSpeed: windSpeed,
      icon: icon,
      dateTime: dateTime,
    );
  }
}
