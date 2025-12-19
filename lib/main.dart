import 'package:flutter/material.dart';
import 'package:weather_app/app.dart';
import 'package:weather_app/core/di/dependency_injection.dart';
import 'package:weather_app/core/utils/permissions.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Permissions.requestLocation();
  await DependencyInjection.init();
  runApp(MyApp());
}