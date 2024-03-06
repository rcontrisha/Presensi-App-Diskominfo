import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:apsi/Modules/Profile%20Detail/View/detail_view.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../../../Widgets/custom_bottom_navigation_bar.dart';
import '../../Landing Page/landingpage.dart';
import '../../Login Page/View/login_view.dart';
import '../Controller/profile_controller.dart';

final SharedPreferences _sharedPreferences = Get.find<SharedPreferences>();

class ProfilePage extends StatefulWidget {
  const ProfilePage({Key? key}) : super(key: key);

  @override
  State<ProfilePage> createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  final ProfileController profileController = Get.put(ProfileController());

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Color(0xFFFEFEFE),
        toolbarHeight: 0,
      ),
      body: Padding(
          padding: const EdgeInsets.symmetric(vertical: 30.0),
          child: Obx(() {
            if (profileController.isLoadingImage.value) {
              // Tampilkan indikator loading jika gambar sedang diunduh
              return Center(child: CircularProgressIndicator());
            } else if (profileController.userData.isNotEmpty) {
              return Center(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    CircleAvatar(
                      radius: 65,
                      backgroundImage:
                          NetworkImage(profileController.userImageUrl),
                    ),
                    SizedBox(height: 20),
                    Column(
                      children: [
                        Text(
                          "${profileController.userData[0]['nama']}",
                          style: TextStyle(
                            color: Color(0xFF272528),
                            fontFamily: 'Kanit',
                            fontSize: 16,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                        SizedBox(height: 5),
                        Text(
                          "${profileController.userData[0]['jabatan']}",
                          style: TextStyle(
                            color: Color(0xFFB3B1B0),
                            fontFamily: 'Kanit',
                            fontSize: 15,
                            fontWeight: FontWeight.w400,
                          ),
                        ),
                      ],
                    ),
                    SizedBox(height: 45),
                    Expanded(
                      child: LayoutBuilder(
                        builder: (context, constraints) {
                          return SingleChildScrollView(
                            child: ConstrainedBox(
                              constraints: BoxConstraints(
                                minHeight: constraints.maxHeight - 100,
                              ),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.stretch,
                                children: [
                                  buildField(
                                      "Informasi Profil",
                                      "assets/images/profile.png",
                                      Color(0xFF04A3EA), () {
                                    // Navigasi ke halaman ProfileDetail
                                    Get.to(() => ProfileDetail());
                                  }),
                                  buildField(
                                      "Keluar",
                                      "assets/images/logout.png",
                                      Color(0xFF04A3EA), () {
                                    // Navigasi ke halaman Landing
                                  }),
                                ],
                              ),
                            ),
                          );
                        },
                      ),
                    ),
                  ],
                ),
              );
            } else {
              // Tampilkan sesuatu jika data belum tersedia
              return Center(child: CircularProgressIndicator());
            }
          })),
      bottomNavigationBar: CustomBottomNavigationBar(),
    );
  }

  void logout() {
    _sharedPreferences.remove('hasLoggedIn');
    _sharedPreferences.remove('nip');
    Get.to(() => LoginScreen());
  }

  Widget buildField(
      String title, String imagePath, Color color, VoidCallback onTap) {
    return Container(
      decoration: BoxDecoration(
        border: title == "Informasi Profil"
            ? Border(
                top: BorderSide(
                  color: Colors.grey
                      .withOpacity(1), // Warna dan ketebalan garis tepi atas
                  width: 1.0,
                ),
                bottom: BorderSide(
                  color: Colors.grey
                      .withOpacity(1), // Warna dan ketebalan garis tepi bawah
                  width: 1.0,
                ),
              )
            : Border(
                bottom: BorderSide(
                  color: Colors.grey
                      .withOpacity(1), // Warna dan ketebalan garis tepi bawah
                  width: 1.0,
                ),
              ),
      ),
      child: InkWell(
        onTap: onTap,
        child: Ink(
          decoration: BoxDecoration(
            color: Color(0xFFFEFEFE),
          ),
          child: Padding(
            padding: const EdgeInsets.symmetric(vertical: 14, horizontal: 25),
            child: Row(
              children: [
                Stack(
                  alignment: Alignment.center,
                  children: [
                    Container(
                      width: 55,
                      height: 55,
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        color: color,
                      ),
                    ),
                    Image.asset(
                      imagePath,
                      fit: BoxFit.contain,
                      width: 35,
                      height: 35,
                    ),
                  ],
                ),
                SizedBox(width: 25),
                Expanded(
                  child: Text(
                    title,
                    style: TextStyle(
                      color: title == "Keluar" ? Colors.red : Color(0xFF272528),
                      fontSize: 16,
                      fontFamily: 'Kanit',
                      fontWeight: FontWeight.w400,
                    ),
                  ),
                ),
                Icon(Icons.arrow_forward_ios),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
