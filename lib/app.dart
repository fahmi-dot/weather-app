import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:weather_app/core/local/app_translations.dart';
import 'package:weather_app/core/routes/app_router.dart';
import 'package:weather_app/core/theme/app_theme.dart';
import 'package:weather_app/shared/controllers/language_controller.dart';
import 'package:weather_app/shared/controllers/theme_controller.dart';

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    final ThemeController themeController = Get.find();
    final LanguageController languageController = Get.find();

    return Obx(() => GetMaterialApp(
      debugShowCheckedModeBanner: false,
      theme: AppTheme.lightTheme,
      darkTheme: AppTheme.darkTheme,
      themeMode: themeController.themeMode.value,
      translations: AppTranslations(),
      locale: languageController.locale.value,
      fallbackLocale: Locale('en', 'US'),
      initialRoute: Routes.home,
      getPages: AppRouter.pages,
    ));
  }
}