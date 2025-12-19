import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import 'package:weather_app/core/network/api_client.dart';
import 'package:weather_app/features/weather/data/datasources/remote/weather_remote_datasource.dart';
import 'package:weather_app/features/weather/data/repositories/weather_repository_impl.dart';
import 'package:weather_app/features/weather/domain/repositories/weather_repository.dart';
import 'package:weather_app/features/weather/domain/usecases/get_weather_by_city_usecase.dart';
import 'package:weather_app/features/weather/domain/usecases/get_weather_usecase.dart';
import 'package:weather_app/features/weather/presentation/controllers/weather_controller.dart';
import 'package:weather_app/shared/controllers/theme_controller.dart';

class DependencyInjection {
  static Future<void> init() async {
    final prefs = await SharedPreferences.getInstance();
    Get.put<SharedPreferences>(prefs);
    Get.put<ThemeController>(ThemeController(prefs: Get.find()), permanent: true);

    // Networks
    Get.lazyPut<ApiClient>(() => ApiClient(http.Client()));

    // Datasoruces
    Get.lazyPut<WeatherRemoteDataSource>(() => WeatherRemoteDataSourceImpl(apiClient: Get.find()));

    // Repositories
    Get.lazyPut<WeatherRepository>(() => WeatherRepositoryImpl(weatherRemoteDataSource: Get.find()));

    // Usecases
    Get.lazyPut<GetWeatherUseCase>(() => GetWeatherUseCase(Get.find()));
    Get.lazyPut<GetWeatherByCityUseCase>(() => GetWeatherByCityUseCase(Get.find()));

    // Controllers
    Get.lazyPut<WeatherController>(() => WeatherController(getWeather: Get.find(), getWeatherByCity: Get.find()));
  }
}
