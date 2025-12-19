import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import 'package:weather_app/core/network/api_client.dart';
import 'package:weather_app/features/weather/data/datasources/remote/weather_remote_datasource.dart';
import 'package:weather_app/features/weather/data/repositories/weather_repository_impl.dart';
import 'package:weather_app/features/weather/domain/repositories/weather_repository.dart';
import 'package:weather_app/features/weather/domain/usecases/get_weather_usecase.dart';
import 'package:weather_app/features/weather/presentation/controllers/weather_controller.dart';

class DependencyInjection {
  static Future<void> init() async {
    Get.lazyPut(() async => await SharedPreferences.getInstance());

    Get.lazyPut<ApiClient>(
      () => ApiClient(http.Client())
    );

    Get.lazyPut<WeatherRemoteDataSource>(
      () => WeatherRemoteDataSourceImpl(apiClient: Get.find()),
    );

    Get.lazyPut<WeatherRepository>(
      () => WeatherRepositoryImpl(
        weatherRemoteDataSource: Get.find(),
      ),
    );

    Get.lazyPut(
      () => GetWeatherUseCase(Get.find())
    );

    Get.lazyPut(
      () => WeatherController(
        getWeather: Get.find(),
      ),
    );
  }
}