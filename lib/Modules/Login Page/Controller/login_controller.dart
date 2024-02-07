import 'dart:io';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:maps/Services/UsersAPI.dart';
import 'package:device_info/device_info.dart';

class UserController extends GetxController {
  final emailController = TextEditingController();
  final passwordController = TextEditingController();

  final RxBool isLoggedIn = false.obs;
  final RxBool isLoading = false.obs;
  final RxBool rememberMe = false.obs;

  late AndroidDeviceInfo _androidInfo;
  late String _androidId;

  // Add shared preferences instance
  final Future<SharedPreferences> _prefs = SharedPreferences.getInstance();

  @override
  void onInit() {
    super.onInit();
    checkLoginStatus();
  }

  void checkLoginStatus() async {
    final SharedPreferences prefs = await _prefs;

    // Check if the user has previously logged in
    if (prefs.getBool('hasLoggedIn') == true &&
        prefs.getBool('rememberMe') == true) {
      isLoggedIn.value = true;

      // Schedule navigation to the home page after the current frame has been painted
      WidgetsBinding.instance!.addPostFrameCallback((_) {
        Get.offNamed('/home');
      });
    }
  }

  Future<void> loginUser() async {
    try {
      isLoading.value = true; // Show loading indicator
      final List<dynamic> users = await UserService.getUsers();
      final SharedPreferences prefs = await _prefs;

      _androidInfo = await _getDeviceId();
      _androidId = _androidInfo.androidId;

      bool loginSuccessful = false;

      for (var user in users) {
        if ((user['email'] == emailController.text ||
                user['nip'] == emailController.text) &&
            user['password'] == passwordController.text) {
          if (user['device_id'] == _androidId) {
            // Set the isLoggedIn flag to true if credentials are valid
            isLoggedIn.value = true;

            // Save NIP to shared preferences
            await saveNIP(user['nip']);

            // Set the flag indicating that the user has logged in
            await setLoggedInFlag();

            // Save "Remember Me" preference
            if (rememberMe.value) {
              await prefs.setString('rememberedEmail', emailController.text);
              await prefs.setBool('rememberMe', true);
            } else {
              await prefs.remove('rememberedEmail');
              await prefs.remove('rememberMe');
            }

            // Mark login as successful
            loginSuccessful = true;

            // Show success snackbar
            Get.snackbar('Success', 'Login successful',
                backgroundColor: Colors.green, colorText: Colors.white);

            // Navigate to the homepage
            Get.offNamed('/home');
            return;
          } else {
            Get.snackbar('Error ID', "Login Failed. Device ID doesn't match.",
                backgroundColor: Colors.redAccent, colorText: Colors.white);
            Get.offNamed('/login');
            return;
          }
        }
      }

      // Show error snackbar only if no matching user is found
      if (!loginSuccessful) {
        Get.snackbar('Error', 'Invalid email/nip or password',
            backgroundColor: Colors.red, colorText: Colors.white);
      }
    } catch (e) {
      print('Error: $e');
      // Show error snackbar for API call failure
      Get.snackbar('Error', 'Failed to load user data',
          backgroundColor: Colors.red, colorText: Colors.white);
    } finally {
      isLoading.value = false; // Hide loading indicator
    }
  }

  Future<AndroidDeviceInfo> _getDeviceId() async {
    try {
      DeviceInfoPlugin deviceInfo = DeviceInfoPlugin();
      if (Platform.isAndroid) {
        AndroidDeviceInfo androidInfo = await deviceInfo.androidInfo;
        print('Android ID: ${androidInfo.androidId}');
        return androidInfo;
      } else {
        throw Exception('Unsupported platform');
      }
    } catch (e) {
      print('Error getting device information: $e');
      rethrow;
    }
  }

  Future<void> saveNIP(String nip) async {
    final SharedPreferences prefs = await _prefs;
    await prefs.setString('nip', nip);
  }

  Future<void> setLoggedInFlag() async {
    final SharedPreferences prefs = await _prefs;
    await prefs.setBool('hasLoggedIn', true);
  }
}
