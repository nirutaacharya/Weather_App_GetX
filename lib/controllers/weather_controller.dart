// 
import 'dart:convert';

import 'package:get/get_core/src/get_main.dart';
import 'package:get/get_navigation/src/extension_navigation.dart';
import 'package:get/get_rx/src/rx_types/rx_types.dart';
import 'package:get/get_state_manager/src/simple/get_controllers.dart';
import 'package:http/http.dart' as http;

class WeatherController extends GetxController {
  static const String apiKey = '2828cd7ae338bbcee630ce39d34e0dbf';

  var city = 'Kathmandu'.obs;
  var isLoading = false.obs;
  var data = Rxn<Map<String, dynamic>>();

  @override
  void onInit() {
    fetchWeather();
    super.onInit();
  }

  Future<void> fetchWeather() async {
    try {
      isLoading(true);
      final url =
          'https://api.openweathermap.org/data/2.5/weather?q=${city.value}&appid=$apiKey&units=metric';
      final res = await http.get(Uri.parse(url));

      if (res.statusCode == 200) {
        data.value = json.decode(res.body);
      } else {
        Get.snackbar('Error', 'City not found');
      }
    } finally {
      isLoading(false);
    }
  }

  void searchCity(String c) {
    city.value = c;
    fetchWeather();
  }
}
