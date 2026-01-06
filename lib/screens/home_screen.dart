
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:weather_app/controllers/auth_controller.dart';
import 'package:weather_app/controllers/weather_controller.dart';
import 'package:weather_app/widgets/info_card.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final weather = Get.put(WeatherController());
    final auth = Get.find<AuthController>();

    return Scaffold(
      backgroundColor: const Color(0xFFF5F7FA),
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        title: const Text(
          'Weather',
          style: TextStyle(
            color: Color(0xFF2C3E50),
            fontWeight: FontWeight.bold,
          ),
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.search, color: Color(0xFF2C3E50)),
            onPressed: () => _searchDialog(weather),
          ),
          IconButton(
            icon: const Icon(Icons.logout, color: Color(0xFF2C3E50)),
            onPressed: auth.logout,
          ),
        ],
      ),
      body: Obx(() {
        if (weather.isLoading.value) {
          return const Center(
            child: CircularProgressIndicator(color: Color(0xFF4A90E2)),
          );
        }

        final w = weather.data.value;
        if (w == null) {
          return const Center(
            child: Text(
              'No Data',
              style: TextStyle(fontSize: 18, color: Colors.grey),
            ),
          );
        }

        return SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.all(24),
            child: Column(
              children: [
                FutureBuilder(
                  future: auth.getName(),
                  builder: (_, s) => Text(
                    'Hello, ${s.data ?? "User"}',
                    style: const TextStyle(
                      fontSize: 24,
                      fontWeight: FontWeight.w600,
                      color: Color(0xFF2C3E50),
                    ),
                  ),
                ),
                const SizedBox(height: 8),
                Text(
                  DateFormat.yMMMMEEEEd().format(DateTime.now()),
                  style: TextStyle(fontSize: 16, color: Colors.grey[600]),
                ),
                const SizedBox(height: 32),
                Container(
                  width: double.infinity,
                  padding: const EdgeInsets.all(32),
                  decoration: BoxDecoration(
                    gradient: const LinearGradient(
                      begin: Alignment.topLeft,
                      end: Alignment.bottomRight,
                      colors: [Color(0xFF4A90E2), Color(0xFF357ABD)],
                    ),
                    borderRadius: BorderRadius.circular(24),
                    boxShadow: [
                      BoxShadow(
                        color: const Color(0xFF4A90E2).withOpacity(0.3),
                        blurRadius: 20,
                        offset: const Offset(0, 10),
                      ),
                    ],
                  ),
                  child: Column(
                    children: [
                      Text(
                        '${w['name']}, ${w['sys']['country']}',
                        style: const TextStyle(
                          fontSize: 28,
                          fontWeight: FontWeight.bold,
                          color: Colors.white,
                        ),
                      ),
                      const SizedBox(height: 16),
                      Text(
                        '${w['main']['temp'].round()}°',
                        style: const TextStyle(
                          fontSize: 80,
                          fontWeight: FontWeight.bold,
                          color: Colors.white,
                        ),
                      ),
                      Text(
                        w['weather'][0]['description'].toString().toUpperCase(),
                        style: const TextStyle(
                          fontSize: 18,
                          color: Colors.white,
                          letterSpacing: 2,
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 24),
                Row(
                  children: [
                    Expanded(
                      child: InfoCard(
                        icon: Icons.water_drop,
                        label: 'Humidity',
                        value: '${w['main']['humidity']}%',
                      ),
                    ),
                    const SizedBox(width: 16),
                    Expanded(
                      child: InfoCard(
                        icon: Icons.air,
                        label: 'Wind',
                        value: '${w['wind']['speed']} m/s',
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 16),
                InfoCard(
                  icon: Icons.compress,
                  label: 'Pressure',
                  value: '${w['main']['pressure']} hPa',
                ),
              ],
            ),
          ),
        );
      }),
    );
  }

  void _searchDialog(WeatherController c) {
    final t = TextEditingController();
    Get.dialog(
      AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        title: const Text(
          'Search City',
          style: TextStyle(
            fontWeight: FontWeight.bold,
            color: Color(0xFF2C3E50),
          ),
        ),
        content: TextField(
          controller: t,
          decoration: InputDecoration(
            hintText: 'Enter city name',
            prefixIcon: const Icon(Icons.location_city),
            border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
          ),
        ),
        actions: [
          TextButton(onPressed: Get.back, child: const Text('Cancel')),
          ElevatedButton(
            onPressed: () {
              c.searchCity(t.text);
              Get.back();
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: const Color(0xFF4A90E2),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(8),
              ),
            ),
            child: const Text('Search'),
          ),
        ],
      ),
    );
  }
}
