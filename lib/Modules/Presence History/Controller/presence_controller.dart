// presence_controller.dart
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:maps/Services/PresenceAPI.dart';
import 'package:geocoding/geocoding.dart';
import 'package:shared_preferences/shared_preferences.dart';

class AddressDetails {
  final String street;
  final String district;
  final String kecamatan;
  final String city;
  final String province;

  AddressDetails({
    required this.street,
    required this.district,
    required this.kecamatan,
    required this.city,
    required this.province,
  });
}

class PresenceController extends GetxController {
  RxList<Map<String, dynamic>> presenceData = <Map<String, dynamic>>[].obs;
  RxBool isLoading = true.obs;

  final _sharedPreferences = Get.find<SharedPreferences>();

  @override
  void onInit() {
    fetchData();
    super.onInit();
  }

  Future<void> fetchData() async {
    final storedNIP = _sharedPreferences.getString('nip');
    try {
      print("Fetching data...");
      isLoading(true);
      List<Map<String, dynamic>> data =
          await PresenceService().getPresenceByUser(storedNIP);
      presenceData.assignAll(data);
    } catch (e) {
      print('Error: $e');
      // Handle error as needed
    } finally {
      isLoading(false);
      print("Data fetching completed.");
    }
  }

  Future<AddressDetails> getPlaceMarks(
      String latitude, String longitude) async {
    try {
      double lat = double.parse(latitude);
      double lon = double.parse(longitude);
      List<Placemark> placemarks = await placemarkFromCoordinates(lat, lon);

      if (placemarks.isNotEmpty) {
        Placemark placemark = placemarks[0];
        return AddressDetails(
            street: placemark.street ?? 'Unknown Street',
            district: placemark.subLocality ?? 'Unknown District',
            kecamatan: placemark.locality ?? 'Unknown Kecamatan',
            city: placemark.subAdministrativeArea ?? 'Unknown City',
            province: placemark.administrativeArea ?? 'Unknown Province');
      } else {
        return AddressDetails(
            street: 'Unknown Street',
            district: 'Unknown District',
            kecamatan: 'Unknown Kecamatan',
            city: 'Unknown City',
            province: 'Unknown province');
      }
    } catch (e) {
      print('Error getting placemarks: $e');
      return AddressDetails(
          street: 'Unknown Street',
          district: 'Unknown District',
          kecamatan: 'Unknown Kecamatan',
          city: 'Unknown City',
          province: 'Unknown province');
    }
  }
}
