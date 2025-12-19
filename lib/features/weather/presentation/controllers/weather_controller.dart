import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:weather_app/core/constants/app_strings.dart';
import 'package:weather_app/core/utils/permissions.dart';
import 'package:weather_app/features/weather/domain/entities/weather.dart';
import 'package:weather_app/features/weather/domain/usecases/get_weather_by_city_usecase.dart';
import 'package:weather_app/features/weather/domain/usecases/get_weather_usecase.dart';

class WeatherController extends GetxController {
  final TextEditingController searchController = TextEditingController();
  
  final GetWeatherUseCase getWeather;
  final GetWeatherByCityUseCase getWeatherByCity;

  WeatherController({
    required this.getWeather,
    required this.getWeatherByCity,
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

  @override
  void onClose() {
    searchController.dispose();
    super.onClose();
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
            AppStrings.errorMsg,
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
        AppStrings.errorMsg,
        AppStrings.failedGetLocMsg,
        snackPosition: SnackPosition.BOTTOM,
      );
    } finally {
      isLoading.value = false;
    }
  }

  Future<void> loadWeatherByCity() async {
    final cityName = searchController.text.trim();

    if (cityName.isEmpty) return;
    
    try {
      isLoading.value = true;

      final result = await getWeatherByCity.execute(cityName);

      result.fold(
        (failure) {
          Get.snackbar(
            AppStrings.errorMsg,
            errorMsg.value = failure.msg,
            snackPosition: SnackPosition.BOTTOM,
          );
        }, 
        (data) {
          weather.value = data;
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
      searchController.clear();
    }
  }
}