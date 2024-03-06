import 'package:apsi/Services/PresenceAPI.dart';
import 'package:geocoding/geocoding.dart';
import 'package:get/get.dart';
import 'package:shared_preferences/shared_preferences.dart';

final SharedPreferences _sharedPreferences = Get.find<SharedPreferences>();

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

class PresenceDetailController extends GetxController {
  final RxMap<dynamic, dynamic> presence = {}.obs;
  final RxBool isLoading = true.obs;

  @override
  void onInit() {
    super.onInit();
    fetchPresenceById();
  }

  void fetchPresenceById() async {
    final accessToken = _sharedPreferences.getString('token');
    try {
      isLoading.value = true;
      final id = Get.parameters['id'] ?? ''; // Gunakan id kosong jika null
      if (id.isEmpty) {
        print('Error: No id found in route parameters');
        return; // Kembalikan jika id kosong atau null
      }
      print('Fetching presence data for id: $id');
      final data =
          await PresenceService(accessToken!).fetchPresenceById(int.parse(id));
      print('Presence data for id $id: $data');
      presence.value = data;
    } catch (e) {
      print('Error fetching presence data: $e');
    } finally {
      isLoading.value = false;
    }
  }

  Future<AddressDetails> getPlaceMarks(
      String latitude, String longitude) async {
    try {
      double? lat = double.tryParse(latitude);
      double? lon = double.tryParse(longitude);
      if (lat != null && lon != null) {
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
      } else {
        throw Exception('Invalid latitude or longitude format');
      }
    } catch (e) {
      print('Error getting placemarks: $e');
      return AddressDetails(
          street: 'Unknown Street',
          district: 'Unknown District',
          kecamatan: 'Unknown Kecamatan',
          city: 'Unknown City',
          province: 'Unknown Province');
    }
  }
}
