import 'package:get/get.dart';
import 'package:weather_app/core/constants/app_strings.dart';
import 'package:weather_app/features/weather/domain/entities/forecast.dart';
import 'package:weather_app/features/weather/domain/usecases/get_forecast_by_city_usecase.dart';
import 'package:weather_app/features/weather/domain/usecases/get_forecast_usecase.dart';

class ForecastController extends GetxController {
  final GetForecastUseCase getForecast;
  final GetForecastByCityUseCase getForecastByCity;

  ForecastController({
    required this.getForecast,
    required this.getForecastByCity,
  });

  final RxList<Forecast> forecast = <Forecast>[].obs;
  final RxBool isLoading = false.obs;
  final RxBool hasError = false.obs;
  final RxString errorMsg = ''.obs;

  Future<void> loadForecast() async {
    try {
      isLoading.value = true;

      final result = await getForecast.execute();

      result.fold(
        (failure) {
          Get.snackbar(
            AppStrings.errorMsg,
            errorMsg.value = failure.msg,
            snackPosition: SnackPosition.BOTTOM,
          );
        },
        (data) {
          forecast.value = data;
        });
    } catch (e) {
      hasError.value = true;
      errorMsg.value = e.toString();
      Get.snackbar(
        AppStrings.errorMsg,
        AppStrings.failedGetLocMsg,
        snackPosition: SnackPosition.BOTTOM,
      );
    } finally {
      isLoading.value = false;
    }
  }

  Future<void> loadForecastByCity(String cityName) async {
    try {
      isLoading.value = true;

      final result = await getForecastByCity.execute(cityName);

      result.fold(
        (failure) {
          Get.snackbar(
            AppStrings.errorMsg,
            errorMsg.value = failure.msg,
            snackPosition: SnackPosition.BOTTOM,
          );
        }, 
        (data) {
          forecast.value = data;
        }
      );
    } catch (e) {
      hasError.value = true;
      errorMsg.value = e.toString();
      Get.snackbar(
        AppStrings.errorMsg,
        AppStrings.failedGetLocMsg,
        snackPosition: SnackPosition.BOTTOM,
      );
    } finally {
      isLoading.value = false;
    }
  }
}