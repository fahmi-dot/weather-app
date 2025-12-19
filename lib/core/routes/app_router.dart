import 'package:get/get_navigation/get_navigation.dart';
import 'package:weather_app/features/weather/presentation/screens/home_screen.dart';

class Routes {
  static const String home = '/home';
}

class AppRouter {
  static final pages = [
    GetPage(
      name: Routes.home, 
      page: () => HomeScreen(),
    ),
  ];
}