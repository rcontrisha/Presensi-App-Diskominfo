// home_controller.dart
import 'dart:convert';
import 'dart:io';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:maps/Modules/Login%20Page/View/login_view.dart';
import 'package:maps/Services/PresenceAPI.dart';
import 'package:maps/Services/UsersAPI.dart';
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
  RxList<Map<String, dynamic>> userData = <Map<String, dynamic>>[].obs;
  RxBool loadingAPI = true.obs;
  final RxBool _isLoading = true.obs;
  final RxBool _isCheckInButtonVisible = false.obs;
  final RxBool _isCheckOutButtonVisible = false.obs;
  final RxBool _areButtonsDisabled = false.obs;
  late AndroidDeviceInfo _androidInfo;
  late String _androidId = '';
  late bool loggedToday = false;
  final RxList<Map<String, dynamic>> _officeData = <Map<String, dynamic>>[].obs;
  String userImageUrl = ''; // URL gambar pengguna

  bool _deviceInfoLoaded = false;

  Position? get currentPosition => _currentPosition.value;
  bool get isLoading => _isLoading.value;
  bool get isCheckInButtonVisible => _isCheckInButtonVisible.value;
  bool get isCheckOutButtonVisible => _isCheckOutButtonVisible.value;
  bool get areButtonsDisabled => _areButtonsDisabled.value;
  RxList<Map<String, dynamic>> get officeData => _officeData;

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
    fetchOfficeData();
    fetchUserImage();
  }

  Future<void> fetchOfficeData() async {
    final accessToken = _sharedPreferences.getString('token');
    try {
      final officeData = await PresenceService(accessToken!).fetchKantorData();

      // Menangani respons sebagai Map<String, dynamic>
      if (officeData.isNotEmpty) {
        // Jika data kantor tidak kosong, tambahkan data ke _officeData
        _officeData.add(officeData);
        print('Office data: $officeData');
      } else {
        // Jika data kantor kosong, tampilkan pesan atau lakukan tindakan lain
        print('Office data is empty');
      }
    } catch (e) {
      print('Error fetching office data: $e');
    }
  }

  Future<void> fetchData() async {
    final storedNIP = _sharedPreferences.getString('nip');
    final accessToken = _sharedPreferences.getString('token');
    try {
      print("Fetching data...");
      loadingAPI(true);
      List<Map<String, dynamic>> data =
          await PresenceService(accessToken!).fetchData();
      presenceData.assignAll(data);
      print("Response Data: $data"); // Debug print for response
      fetchUserByNip(storedNIP!);
    } catch (e) {
      print('Error: $e');
      // Handle error as needed
    } finally {
      loadingAPI(false);
      print("Data fetching completed.");
    }
  }

  Future<void> fetchUserImage() async {
    final storedNIP = _sharedPreferences.getString('nip');
    try {
      final imageUrl = await UserService.getUserImage(storedNIP!);
      userImageUrl = imageUrl; // Gunakan respons langsung sebagai URL gambar
      print('User image URL: $userImageUrl');
    } catch (e) {
      print('Error fetching user image: $e');
    }
  }

  Future<void> requestPermission() async {
    final PermissionStatus status = await Permission.location.request();
    if (status.isGranted) {
      await _getCurrentLocation();
      await _getDeviceId(); // Ensure _getDeviceId is called after obtaining location
      await fetchData();
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

  // Method untuk mengambil data user sesuai dengan NIP
  Future<void> fetchUserByNip(String nip) async {
    try {
      // Panggil method getUsers dari UserService untuk mendapatkan data user berdasarkan NIP
      final userDataFromServer =
          await UserService.getUsersByNipAndDeviceId(nip);

      // Update nilai userData dengan data user yang diperoleh
      userData.value = [userDataFromServer];
      print(userData);
    } catch (e) {
      print('Error fetching user data by NIP: $e');
    }
  }

  double calculateDistance(
      Position? currentLocation, Map<String, dynamic>? office) {
    double distance = 0.0;

    if (currentLocation != null && office != null) {
      distance = Geolocator.distanceBetween(
        currentLocation.latitude,
        currentLocation.longitude,
        _officeData[0]['latitude'],
        _officeData[0]['longitude'],
      );
      distance = double.parse(distance.toStringAsFixed(2));
    } else {
      print('Invalid parameters for calculating distance.');
    }
    return distance;
  }

  Future<void> postPresensi() async {
    final storedNIP = _sharedPreferences.getString('nip');
    final accessToken = _sharedPreferences.getString('token');
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
          'waktu': DateTime.now(),
          'device_id': _androidId,
        };

        // Customize the API call according to your needs
        await PresenceService(accessToken!).postData(presensiData);
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
      double distance = calculateDistance(currentPosition, _officeData[0]);
      print('Office coordinates: ${_officeData[0]}');
      print('Distance to office: $distance meters');
      showPresensiSnackbar(distance);
    } else {
      print('Unable to calculate distance. Location not available.');
    }
  }

  void showPresensiSnackbar(double distance) {
    String presensiMessage;
    double radius = double.parse(_officeData[0]['radius']);

    if (distance != null) {
      if (distance < radius) {
        presensiMessage = 'Presensi Sukses!';
        postPresensi();
      } else {
        presensiMessage = 'Presensi Gagal - Distance is above ${radius}m';
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
