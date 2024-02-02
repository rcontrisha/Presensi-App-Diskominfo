// home_controller.dart
import 'dart:io';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
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
  RxList<Map<String, dynamic>> presenceData = <Map<String, dynamic>>[].obs;
  RxBool loadingAPI = true.obs;
  final RxBool _isLoading = true.obs;
  final RxBool _isCheckInButtonVisible = false.obs;
  final RxBool _isCheckOutButtonVisible = false.obs;
  final RxBool _areButtonsDisabled = false.obs;
  late AndroidDeviceInfo _androidInfo;
  late String _androidId = '';
  late bool loggedToday = false;

  bool _deviceInfoLoaded = false;

  Position? get currentPosition => _currentPosition.value;
  bool get isLoading => _isLoading.value;
  bool get isCheckInButtonVisible => _isCheckInButtonVisible.value;
  bool get isCheckOutButtonVisible => _isCheckOutButtonVisible.value;
  bool get areButtonsDisabled => _areButtonsDisabled.value;

  String get androidId {
    if (!_deviceInfoLoaded) {
      return 'Loading device information...';
    }
    return _androidId;
  }

  @override
  void onInit() {
    super.onInit();
    requestPermission();
  }

  Future<void> fetchData() async {
    final storedNIP = _sharedPreferences.getString('nip');
    try {
      print("Fetching data...");
      loadingAPI(true);
      List<Map<String, dynamic>> data =
          await PresenceService().getPresenceByUser(storedNIP);
      presenceData.assignAll(data);
    } catch (e) {
      print('Error: $e');
      // Handle error as needed
    } finally {
      loadingAPI(false);
      print("Data fetching completed.");
    }
  }

  Future<void> checkCheckInCheckOutStatus() async {
    final storedNIP = _sharedPreferences.getString('nip');

    if (storedNIP != null) {
      try {
        // Get today's date
        final today = DateTime.now();
        final todayFormatted = DateFormat('yyyy-MM-dd').format(today);
        print('Today Formatted: $todayFormatted');

        // Set loggedToday to false initially
        loggedToday = false;
        print('Presence Data: $presenceData');

        for (int i = 0; i < presenceData.length; i++) {
          print(
              'Server Tanggal: ${presenceData[i]['tanggal']}, Today Formatted: $todayFormatted');
          if (presenceData[i]['tanggal'] == todayFormatted) {
            loggedToday = true;
            break;
          }
        }

        print(loggedToday);
      } catch (e) {
        print('Error fetching presence data: $e');
      }
    }
  }

  void _showCheckInButton() {
    // Update the state in your controller to show the Check In button
    // For example, set a boolean flag like isCheckInButtonVisible to true
    // and use it in your view to conditionally show the Check In button.
    _isCheckInButtonVisible.value = true;
    _isCheckOutButtonVisible.value =
        false; // Make sure Check Out button is hidden
  }

  void _showCheckOutButton() {
    // Update the state in your controller to show the Check Out button
    // For example, set a boolean flag like isCheckOutButtonVisible to true
    // and use it in your view to conditionally show the Check Out button.
    _isCheckOutButtonVisible.value = true;
    _isCheckInButtonVisible.value =
        false; // Make sure Check In button is hidden
  }

  void _showBothButtonsDisabled() {
    // Update the state in your controller to handle the case
    // where both Check In and Check Out buttons are disabled.
    // For example, set a boolean flag like areButtonsDisabled to true
    // and use it in your view to conditionally disable both buttons.
    _areButtonsDisabled.value = true;
    _isCheckInButtonVisible.value = false;
    _isCheckOutButtonVisible.value = false;
  }

  Future<void> requestPermission() async {
    final PermissionStatus status = await Permission.location.request();
    if (status.isGranted) {
      await _getCurrentLocation();
      await _getDeviceId(); // Ensure _getDeviceId is called after obtaining location
      await fetchData();
      await checkCheckInCheckOutStatus();
    } else {
      print('Location permission denied');
      _isLoading.value = false;
    }
  }

  Future<void> _getDeviceId() async {
    try {
      DeviceInfoPlugin deviceInfo = DeviceInfoPlugin();
      if (Platform.isAndroid) {
        AndroidDeviceInfo androidInfo = await deviceInfo.androidInfo;
        print('Android ID: ${androidInfo.androidId}');
        _androidId = androidInfo.androidId;

        // Set the flag to indicate that device information has been loaded
        _deviceInfoLoaded = true;
      } else {
        throw Exception('Unsupported platform');
      }
    } catch (e) {
      print('Error getting device information: $e');
      rethrow;
    }
  }

  Future<bool> checkGpsStatus() async {
    bool isGpsEnabled = await Geolocator.isLocationServiceEnabled();
    if (!isGpsEnabled) {
      // If GPS is not enabled, show a snackbar or alert to prompt the user to enable it
      Get.snackbar(
        'GPS is Disabled',
        'Please enable GPS to use this feature.',
        snackPosition: SnackPosition.BOTTOM,
        duration: Duration(seconds: 3),
      );
    }
    return isGpsEnabled;
  }

  Future<void> _getCurrentLocation() async {
    try {
      Position position = await Geolocator.getCurrentPosition(
          desiredAccuracy: LocationAccuracy.high);
      _currentPosition.value = position;

      _isLoading.value = false;
    } catch (e, stackTrace) {
      print('Error getting current location: $e');
      print('Stack trace: $stackTrace');
      _isLoading.value = false;
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
    print('Stored NIP: $storedNIP');
    print('Current Position: $currentPosition');
    print('Android ID: $_androidId');

    if (storedNIP != null && currentPosition != null && _deviceInfoLoaded) {
      try {
        Map<String, dynamic> presensiData = {
          'nip': storedNIP,
          'latitude': currentPosition.latitude,
          'longitude': currentPosition.longitude,
          'tanggal': DateTime.now(),
          'device_id': _androidId,
          'status': 'masuk'
        };

        // Customize the API call according to your needs
        await PresenceService().postData(presensiData);
        print('Presensi posted successfully');
      } catch (e) {
        print('Error posting presensi: $e');
      }
    } else {
      print(
          'Stored NIP, current position, or device info is null. Unable to post presensi.');
    }
  }

  void handlePresensi() async {
    // Check GPS status before processing the presence button click
    bool isGpsEnabled = await checkGpsStatus();
    if (!isGpsEnabled) {
      return;
    }

    final currentPosition = _currentPosition.value;
    final storedNIP = _sharedPreferences.getString('nip');

    if (currentPosition != null) {
      double distance = calculateDistance(currentPosition, CompanyData.office);
      showPresensiSnackbar(distance);
    } else {
      print('Unable to calculate distance. Location not available.');
    }
  }

  void showPresensiSnackbar(double distance) {
    String presensiMessage;

    if (distance != null) {
      if (distance < 1000) {
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
