import 'package:weather_app/features/weather/domain/entities/weather.dart';

class WeatherModel extends Weather {
  const WeatherModel({
    required super.cityName,
    required super.temperature,
    required super.description,
    required super.humidity,
    required super.windSpeed,
    required super.pressure,
    required super.sunrise,
    required super.sunset,
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
      pressure: json['main']['pressure'],
      sunrise: DateTime.fromMillisecondsSinceEpoch(json['sys']['sunrise'] * 1000),
      sunset: DateTime.fromMillisecondsSinceEpoch(json['sys']['sunset'] * 1000),
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
      pressure: weather.pressure,
      sunrise: weather.sunrise,
      sunset: weather.sunset,
      icon: weather.icon,
      dateTime: weather.dateTime,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'dt': dateTime.millisecondsSinceEpoch ~/ 1000,
      'main': {
        'temp': temperature,
        'pressure': pressure,
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
      'sys': {
        'sunrise': sunrise.millisecondsSinceEpoch ~/ 1000,
        'sunset': sunset.millisecondsSinceEpoch ~/ 1000,
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
      pressure: pressure,
      sunrise: sunrise,
      sunset: sunset,
      icon: icon,
      dateTime: dateTime,
    );
  }
}
