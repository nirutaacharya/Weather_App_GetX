import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:weather_app/controllers/auth_controller.dart';
import 'package:weather_app/screens/splash_screen.dart';

void main() {
  // Initialized AuthController
  Get.put(AuthController());
  runApp(const WeatherApp());
}

class WeatherApp extends StatelessWidget {
  const WeatherApp({super.key});

  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Weather App',
      theme: ThemeData(
        primarySwatch: Colors.blue,
        scaffoldBackgroundColor: const Color(0xFFF5F7FA),
        useMaterial3: true,
      ),
      home: const SplashScreen(),
    );
  }
}
