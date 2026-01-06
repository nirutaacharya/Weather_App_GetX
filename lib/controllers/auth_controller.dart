
import 'package:get/get.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:weather_app/screens/login_screen.dart';

class AuthController extends GetxController {
  Future<bool> register(String email, String password, String name) async {
    final prefs = await SharedPreferences.getInstance();
    if (prefs.getString('email') == email) {
      Get.snackbar('Error', 'User already exists');
      return false;
    }

    await prefs.setString('email', email);
    await prefs.setString('password', password);
    await prefs.setString('name', name);

    return true;
  }

  Future<bool> login(String email, String password) async {
    final prefs = await SharedPreferences.getInstance();
    if (prefs.getString('email') == email &&
        prefs.getString('password') == password) {
      await prefs.setBool('isLoggedIn', true);
      return true;
    }
    return false;
  }

  Future<void> logout() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool('isLoggedIn', false);
    Get.offAll(() => const LoginScreen());
  }

  Future<String> getName() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString('name') ?? 'User';
  }
}