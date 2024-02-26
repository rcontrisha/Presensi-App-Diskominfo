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
    if (prefs.getBool('hasLoggedIn') == true) {
      // If "Remember me" is selected, retrieve the stored email
      final rememberedEmail = prefs.getString('rememberedEmail');

      if (rememberedEmail != null) {
        // Set the email in the email controller
        emailController.text = rememberedEmail;

        // Log in the user with the stored email
        loginUser();
        return; // Exit the method to prevent navigation to home page
      }
    }

    // If "Remember me" is not selected or no stored email, proceed with normal login check
    if (prefs.getBool('hasLoggedIn') == true &&
        prefs.getBool('rememberMe') == true) {
      isLoggedIn.value = true;
      WidgetsBinding.instance!.addPostFrameCallback((_) {
        Get.offNamed('/home');
      });
    }
  }

// Ubah bagian loginUser() seperti berikut:
  Future<void> loginUser() async {
    try {
      isLoading.value = true; // Tampilkan indikator loading

      final SharedPreferences prefs = await _prefs;

      _androidInfo = await _getDeviceId();
      _androidId = _androidInfo.androidId;

      final String email = emailController.text;

      // Check jika token belum kadaluarsa
      final String? token = prefs.getString('token');
      final int? tokenExpiration = prefs.getInt('tokenExpiration');

      if (token != null && tokenExpiration != null) {
        final bool isTokenValid =
            DateTime.now().millisecondsSinceEpoch < tokenExpiration;

        if (isTokenValid) {
          // Token masih berlaku, gunakan token yang ada
          isLoggedIn.value = true;

          // Schedule navigation to the home page after the current frame has been painted
          WidgetsBinding.instance!.addPostFrameCallback((_) {
            Get.offNamed('/home');
          });

          return; // Keluar dari fungsi karena login berhasil
        }
      }

      // Jika token sudah kadaluarsa atau tidak ada token sebelumnya,
      // ambil token baru dari server
      final responseData = await UserService.getUsersToken(
        email,
        _androidId,
      );

      final newToken = responseData['access_token'].split('|')[1];

      print('New Token: $newToken'); // Debug print

      // Set isLoggedIn ke true jika login berhasil
      isLoggedIn.value = true;

      // Simpan token ke shared preferences
      await prefs.setString('token', newToken);

      // Atur waktu kedaluwarsa token (contoh: 1 hari)
      final int expiration = DateTime.now().millisecondsSinceEpoch +
          Duration(days: 1).inMilliseconds;
      await prefs.setInt('tokenExpiration', expiration);

      // Simpan NIP ke shared preferences
      await saveNIP(email); // Simpan NIP di sini

      // Simpan preferensi "Remember Me"
      if (rememberMe.value) {
        await prefs.setString('rememberedEmail', email);
        await prefs.setBool('rememberMe', true);
      } else {
        await prefs.remove('rememberedEmail');
        await prefs.remove('rememberMe');
      }

      // Tampilkan snackbar sukses
      Get.snackbar('Success', 'Login successful',
          backgroundColor: Colors.green, colorText: Colors.white);

      // Arahkan ke halaman utama
      Get.offNamed('/home');
    } catch (e) {
      print('Error: $e');
      // Tampilkan snackbar error jika panggilan API gagal
      Get.snackbar('Error', 'Failed to login',
          backgroundColor: Colors.red, colorText: Colors.white);
    } finally {
      isLoading.value = false; // Sembunyikan indikator loading
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

    // Retrieve the stored NIP and print it for debugging
    final storedNIP = prefs.getString('nip');
    print('Stored NIP: $storedNIP');
  }

  Future<void> setLoggedInFlag() async {
    final SharedPreferences prefs = await _prefs;
    await prefs.setBool('hasLoggedIn', true);
  }
}
