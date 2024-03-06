import 'package:apsi/Services/PresenceAPI.dart';
import 'package:get/get.dart';
import 'package:shared_preferences/shared_preferences.dart';

final SharedPreferences _sharedPreferences = Get.find<SharedPreferences>();

class PresenceListController extends GetxController {
  RxList<Map<String, dynamic>> presenceData = <Map<String, dynamic>>[].obs;
  final RxBool _isLoading = true.obs;

  bool get isLoading => _isLoading.value;

  @override
  void onInit() {
    super.onInit();
    fetchData();
  }

  Future<void> fetchData() async {
    final storedNIP = _sharedPreferences.getString('nip');
    final accessToken = _sharedPreferences.getString('token');
    try {
      print("Fetching data...");
      _isLoading(true);
      List<Map<String, dynamic>> data =
          await PresenceService(accessToken!).fetchData();
      presenceData.assignAll(data);
      print("Response Data: $data");
    } catch (e) {
      print('Error: $e');
      // Handle error as needed
    } finally {
      _isLoading(false);
      print("Data fetching completed.");
    }
  }
}