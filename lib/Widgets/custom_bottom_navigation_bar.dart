import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:apsi/Modules/Profile%20Page/View/profile.dart';
import '../Modules/Home Page/Controller/home_controller.dart';
import '../Modules/Home Page/View/home_view.dart';

class CustomBottomNavigationBar extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      height: 97,
      width: MediaQuery.of(context).size.width,
      color: Colors.transparent,
      child: Stack(
        alignment: new FractionalOffset(.5, -1.0),
        children: [
          Positioned(
            bottom: 0,
            child: Container(
              height: 70,
              width: MediaQuery.of(context)
                  .size
                  .width, // Menambahkan ketinggian container untuk menyesuaikan dengan tombol presensi di luar batas atas navbar.
              decoration: BoxDecoration(
                border: Border(
                  top: BorderSide(color: Color(0xFFD4D3D2), width: 1),
                ),
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  InkWell(
                    onTap: () {
                      // Tambahkan logika navigasi ke halaman Home
                      Get.to(() => HomePage());
                    },
                    child: Ink(
                      padding: EdgeInsets.only(
                          top: 5,
                          bottom: 5,
                          left: 30,
                          right: 50), // Menambahkan padding
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(
                            Icons.home,
                            size: 32, // Atur ukuran ikon
                          ),
                          Text(
                            'Home',
                            style: TextStyle(
                                fontSize: 13,
                                fontFamily: 'Kanit',
                                fontWeight: FontWeight.w400),
                          ),
                        ],
                      ),
                    ),
                  ),
                  SizedBox(
                      width: 5), // Penambahan widget kosong untuk posisi tengah
                  InkWell(
                    onTap: () {
                      // Tambahkan logika navigasi ke halaman Profile
                      Get.to(() => ProfilePage());
                    },
                    child: Ink(
                      padding: EdgeInsets.only(
                          top: 5,
                          bottom: 5,
                          left: 50,
                          right: 30), // Menambahkan padding
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(
                            Icons.person,
                            size: 32, // Atur ukuran ikon
                          ),
                          Text(
                            'Profil',
                            style: TextStyle(
                                fontSize: 13,
                                fontFamily: 'Kanit',
                                fontWeight: FontWeight.w400),
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
          Positioned(
            top:
                0, // Menyesuaikan posisi vertikal dari tombol presensi di atas navbar
            child: SizedBox(
              height: 85, // Sesuaikan ketinggian sesuai dengan kebutuhan
              width: 85, // Sesuaikan lebar sesuai dengan kebutuhan
              child: Column(
                mainAxisAlignment: MainAxisAlignment
                    .center, // Menempatkan konten di tengah secara vertikal
                children: [
                  ElevatedButton(
                    style: ElevatedButton.styleFrom(
                        primary: Color(0xFF85817F),
                        padding: EdgeInsets.all(6),
                        elevation: 3),
                    onPressed: () {
                      // Panggil metode handlePresensi saat tombol ditekan
                      Get.find<HomeController>().handlePresensi();
                    },
                    child: Icon(Icons.fingerprint_outlined,
                        size: 50, color: Color(0xFFFEFEFE)),
                  ),
                  SizedBox(
                    height: 3,
                  ),
                  Text(
                    "Presensi",
                    style: TextStyle(
                        fontFamily: 'Kanit',
                        fontWeight: FontWeight.w400,
                        fontSize: 13),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
