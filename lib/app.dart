import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:weather_app/core/routes/app_router.dart';
import 'package:weather_app/core/theme/app_theme.dart';
import 'package:weather_app/shared/controllers/theme_controller.dart';

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    final ThemeController controller = Get.find();

    return Obx(() => GetMaterialApp(
      debugShowCheckedModeBanner: false,
      theme: AppTheme.lightTheme,
      darkTheme: AppTheme.darkTheme,
      themeMode: controller.themeMode.value,
      initialRoute: Routes.home,
      getPages: AppRouter.pages,
    ));
  }
}