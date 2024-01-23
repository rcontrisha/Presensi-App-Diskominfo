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

  // Method to check if the user has previously logged in
  bool hasLoggedInBefore() {
    return prefs.getBool('hasLoggedIn') ?? false;
  }

  // Method to set the flag indicating that the user has logged in
  Future<void> setLoggedInFlag() async {
    await prefs.setBool('hasLoggedIn', true);
  }

  @override
  void onInit() {
    super.onInit();
    checkLoginStatus();
  }

  void checkLoginStatus() {
    // Check if the user has previously logged in
    if (hasLoggedInBefore()) {
      isLoggedIn.value = true;

      // Schedule navigation to the home page after the current frame has been painted
      WidgetsBinding.instance!.addPostFrameCallback((_) {
        Get.offNamed('/home');
      });
    }
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

          // Save NIP to shared preferences
          await saveNIP(user['nip']);

          // Set the flag indicating that the user has logged in
          await setLoggedInFlag();

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
}
