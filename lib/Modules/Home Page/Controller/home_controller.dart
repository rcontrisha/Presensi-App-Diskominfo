// home_controller.dart
import 'dart:io';
import 'dart:math';
import 'package:get/get.dart';
import 'package:maps/Modules/Login%20Page/View/login_view.dart';
import 'package:maps/Services/PresenceAPI.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:geolocator/geolocator.dart';
import 'package:maps_launcher/maps_launcher.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:device_info/device_info.dart';

final SharedPreferences _sharedPreferences = Get.find<SharedPreferences>();

class CompanyData {
  static Map<String, dynamic> office = {
    'latitude': -7.332009384553485,
    'longitude': 110.50127269821182
  };
}

class HomeController extends GetxController {
  final Rx<Position?> _currentPosition = Rx<Position?>(null);
  final RxBool _isLoading = true.obs;
  late RxString _deviceId = ''.obs;

  // Public getter for _currentPosition
  Position? get currentPosition => _currentPosition.value;

  // Public getter for _isLoading
  bool get isLoading => _isLoading.value;

  RxString get deviceId => _deviceId;

  @override
  void onInit() {
    super.onInit();
    requestPermission();
  }

  Future<void> requestPermission() async {
    final PermissionStatus status = await Permission.location.request();
    if (status.isGranted) {
      _getCurrentLocation();
    } else {
      print('Location permission denied');
      _isLoading.value = false;
    }
  }

  Future<void> _getCurrentLocation() async {
    try {
      Position position = await Geolocator.getCurrentPosition(
          desiredAccuracy: LocationAccuracy.high);
      _currentPosition.value = position;

      // Get the device ID
      String deviceId = await _getDeviceId();
      _deviceId.value = deviceId; // Set the device ID

      _isLoading.value = false;
    } catch (e, stackTrace) {
      print('Error getting current location: $e');
      print('Stack trace: $stackTrace');
      _isLoading.value = false;
    }
  }

  Future<String> _getDeviceId() async {
    try {
      DeviceInfoPlugin deviceInfo = DeviceInfoPlugin();
      if (Platform.isAndroid) {
        AndroidDeviceInfo androidInfo = await deviceInfo.androidInfo;
        return androidInfo.androidId; // Android ID
      } else if (Platform.isIOS) {
        IosDeviceInfo iosInfo = await deviceInfo.iosInfo;
        return iosInfo.identifierForVendor; // iOS ID
      } else {
        return 'unknown';
      }
    } catch (e) {
      print('Error getting device ID: $e');
      return 'unknown';
    }
  }

  double calculateDistance(
      Position? currentLocation, Map<String, dynamic>? office) {
    double distance = 0.0;

    if (currentLocation != null && office != null) {
      distance = Geolocator.distanceBetween(
        currentLocation.latitude,
        currentLocation.longitude,
        office['latitude'],
        office['longitude'],
      );
      distance = double.parse(distance.toStringAsFixed(2));
    } else {
      print('Invalid parameters for calculating distance.');
    }
    return distance;
  }

  Future<void> postPresensi() async {
    final storedNIP = _sharedPreferences.getString('nip');
    final currentPosition = _currentPosition.value;

    if (storedNIP != null && currentPosition != null) {
      try {
        Map<String, dynamic> presensiData = {
          'nip': storedNIP,
          'latitude': currentPosition.latitude,
          'longitude': currentPosition.longitude,
          'waktu': DateTime.now(),
          'device_id': _deviceId.value,
        };

        // Customize the API call according to your needs
        await PresenceService().postData(presensiData);
        print('Presensi posted successfully');
      } catch (e) {
        print('Error posting presensi: $e');
      }
    } else {
      print('Stored NIP or current position is null. Unable to post presensi.');
    }
  }

  void handlePresensi() async {
    final currentPosition = _currentPosition.value;
    final storedNIP = _sharedPreferences.getString('StoredNIP');

    if (currentPosition != null) {
      double distance = calculateDistance(currentPosition, CompanyData.office);
      showPresensiSnackbar(distance);
      // Call postPresensi here if you want to automatically post after checking distance
    } else {
      print('Unable to calculate distance. Location not available.');
    }
  }

  int _generateRandomNumber() {
    // Generate a random 6-digit number
    return Random().nextInt(900000) + 100000;
  }

  void showPresensiSnackbar(double distance) {
    String presensiMessage;

    if (distance != null) {
      if (distance < 300) {
        presensiMessage = 'Presensi Sukses!';
        postPresensi();
      } else {
        presensiMessage = 'Presensi Gagal - Distance is above 300m';
      }

      Get.snackbar(
        'Presensi Status',
        presensiMessage,
        snackPosition: SnackPosition.BOTTOM,
        duration: Duration(seconds: 3),
      );
    } else {
      print('Invalid distance value for showing presensi snackbar.');
    }
  }

  void launchOfficeOnMap() {
    try {
      MapsLauncher.launchCoordinates(
        CompanyData.office['latitude'],
        CompanyData.office['longitude'],
      );
    } catch (e) {
      print('Error launching maps: $e');
    }
  }

  void logout() {
    _sharedPreferences.remove('hasLoggedIn');
    _sharedPreferences.remove('nip');
    Get.to(() => LoginScreen());
  }
}
