import 'dart:io';
import 'package:device_info/device_info.dart';
import 'package:get/get.dart';
import 'package:apsi/Services/UsersAPI.dart';
import 'package:shared_preferences/shared_preferences.dart';

final SharedPreferences _sharedPreferences = Get.find<SharedPreferences>();

class DetailController extends GetxController {
  RxList<Map<String, dynamic>> userData = <Map<String, dynamic>>[].obs;
  String userImageUrl = '';
  var isLoadingImage = true.obs;
  String deviceName = ''; // Tambahkan variabel untuk menyimpan nama perangkat

  @override
  void onInit() {
    super.onInit();
    fetchUserImage();
    fetchUserData(); // Panggil metode fetchUserData() di sini
    fetchDeviceName(); // Panggil metode fetchDeviceName() di sini
  }

  // Method untuk mengambil data user sesuai dengan NIP
  Future<void> fetchUserByNip(String nip) async {
    try {
      final userDataFromServer =
          await UserService.getUsersByNipAndDeviceId(nip);
      userData.assignAll([userDataFromServer]);
      print(userData);
    } catch (e) {
      print('Error fetching user data by NIP: $e');
    }
  }

  Future<void> fetchUserImage() async {
    final storedNIP = _sharedPreferences.getString('nip');
    isLoadingImage.value =
        true; // Set isLoadingImage menjadi true saat proses dimulai
    try {
      final imageUrl = await UserService.getUserImage(storedNIP!);
      userImageUrl = imageUrl; // Gunakan respons langsung sebagai URL gambar
      print('User image URL: $userImageUrl');
    } catch (e) {
      print('Error fetching user image: $e');
    } finally {
      isLoadingImage.value =
          false; // Set isLoadingImage menjadi false saat proses selesai
    }
  }

  // Metode untuk mengambil data pengguna
  Future<void> fetchUserData() async {
    final storedNIP = _sharedPreferences.getString('nip');
    if (storedNIP != null) {
      await fetchUserByNip(storedNIP);
    } else {
      print('Stored NIP is null');
    }
  }

  // Method untuk mengambil nama perangkat
  Future<void> fetchDeviceName() async {
    try {
      DeviceInfoPlugin deviceInfo = DeviceInfoPlugin();
      if (Platform.isAndroid) {
        AndroidDeviceInfo androidInfo = await deviceInfo.androidInfo;
        var brand = androidInfo.brand;
        var manufacturer = androidInfo.manufacturer;
        var model = androidInfo.model;
        deviceName = manufacturer +
            " " +
            brand +
            " " +
            model; // Mendapatkan nama perangkat Android
        print('Device Name: $deviceName');
      } else if (Platform.isIOS) {
        // Jika ingin mendapatkan nama perangkat iOS, tambahkan logika di sini
        throw Exception('Unsupported platform');
      } else {
        throw Exception('Unsupported platform');
      }
    } catch (e) {
      print('Error getting device name: $e');
    }
  }
}
