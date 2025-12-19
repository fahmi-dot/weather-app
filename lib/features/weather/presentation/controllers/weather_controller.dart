import 'package:get/get.dart';
import 'package:weather_app/core/utils/permissions.dart';
import 'package:weather_app/features/weather/domain/entities/weather.dart';
import 'package:weather_app/features/weather/domain/usecases/get_weather_usecase.dart';

class WeatherController extends GetxController {
  final GetWeatherUseCase getWeather;

  WeatherController({
    required this.getWeather,
  });

  final Rx<Weather?> weather = Rx<Weather?>(null);
  final RxBool isLoading = false.obs;
  final RxBool hasError = false.obs;
  final RxString errorMsg = ''.obs;

  @override
  void onReady() {
    super.onReady();
    loadWeather();
  }

  Future<void> loadWeather() async {
    try {
      isLoading.value = true;

      if (!(await Permissions.checkLocationServices())) {
        await Permissions.requestLocation();
      }

      final result = await getWeather.execute();

      result.fold(
        (failure) {
          Get.snackbar(
            'Error',
            errorMsg.value = failure.msg,
            snackPosition: SnackPosition.BOTTOM,
          );
        },
        (data) {
          weather.value = data;
        });
    } catch (e) {
      hasError.value = true;
      errorMsg.value = e.toString();
      Get.snackbar(
        'Error',
        'Failed getting location',
        snackPosition: SnackPosition.BOTTOM,
      );
    } finally {
      isLoading.value = false;
    }
  }
}