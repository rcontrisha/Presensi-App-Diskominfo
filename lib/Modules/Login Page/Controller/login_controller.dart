import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:maps/Services/UsersAPI.dart';

class UserController extends GetxController {
  final emailController = TextEditingController();
  final passwordController = TextEditingController();

  final RxBool isLoggedIn = false.obs;
  final RxBool isLoading = false.obs;

  // Add shared preferences instance
  final SharedPreferences prefs = Get.find<SharedPreferences>();

  // Method to save NIP to shared preferences
  Future<void> saveNIP(String nip) async {
    await prefs.setString('nip', nip);
  }

  // Method to get NIP from shared preferences
  String? getStoredNIP() {
    return prefs.getString('nip');
  }

  void loginUser() async {
    try {
      isLoading.value = true; // Show loading indicator

      final List<dynamic> users = await UserService.getUsers();

      for (var user in users) {
        if ((user['email'] == emailController.text ||
                user['nip'] == emailController.text) &&
            user['password'] == passwordController.text) {
          // Set the isLoggedIn flag to true if credentials are valid
          isLoggedIn.value = true;
          print('Login successful');

          // Save NIP to shared preferences
          await saveNIP(user['nip']);

          // Show success snackbar
          Get.snackbar('Success', 'Login successful',
              backgroundColor: Colors.green, colorText: Colors.white);

          // Navigate to the homepage
          Get.offNamed('/home');

          return;
        }
      }

      // Show error snackbar for invalid credentials
      Get.snackbar('Error', 'Invalid email/nip or password',
          backgroundColor: Colors.red, colorText: Colors.white);
    } catch (e) {
      print('Error: $e');
      // Show error snackbar for API call failure
      Get.snackbar('Error', 'Failed to load user data',
          backgroundColor: Colors.red, colorText: Colors.white);
    } finally {
      isLoading.value = false; // Hide loading indicator
    }
  }

  void logout() {
    isLoggedIn.value = false;
  }
}
