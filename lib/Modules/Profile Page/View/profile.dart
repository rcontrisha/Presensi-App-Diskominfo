import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../../../Widgets/custom_bottom_navigation_bar.dart';
import '../../Landing Page/landingpage.dart';
import '../../Login Page/View/login_view.dart';
import '../../Profile Detail/View/profile_detail.dart';
import '../Controller/profile_controller.dart';

final SharedPreferences _sharedPreferences = Get.find<SharedPreferences>();

class ProfilePage extends StatefulWidget {
  const ProfilePage({Key? key}) : super(key: key);

  @override
  State<ProfilePage> createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  final ProfileController _profileController = ProfileController(); // Instance dari controller

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Color(0xFFFEFEFE),
        toolbarHeight: 0,
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(vertical: 30.0),
        child: Center(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              CircleAvatar(
                radius: 65,
              ),
              SizedBox(height: 20),
              Column(
                children: [
                  Text(
                    "Dilo Syuja Sherlieno",
                    style: TextStyle(
                      color: Color(0xFF272528),
                      fontFamily: 'Kanit',
                      fontSize: 16,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                  SizedBox(height: 5),
                  Text(
                    "Pengawas II",
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
                            _profileController.buildField("Informasi Profil", "assets/images/profile.png", Color(0xFF04A3EA), () {
                              // Navigasi ke halaman ProfileDetail
                              Get.to(() => ProfileDetail());
                            }),
                            _profileController.buildField("Keluar", "assets/images/logout.png", Color(0xFF04A3EA), () {
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
        ),
      ),
      bottomNavigationBar: CustomBottomNavigationBar(),
    );
  }

  void logout() {
    _sharedPreferences.remove('hasLoggedIn');
    _sharedPreferences.remove('nip');
    Get.to(() => LoginScreen());
  }
}