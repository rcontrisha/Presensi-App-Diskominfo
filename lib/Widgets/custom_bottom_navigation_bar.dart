import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:maps/Modules/Home%20Page/Controller/home_controller.dart';
import 'package:maps/Modules/Profile%20Page/View/Profile.dart';
import '../Modules/Home Page/View/home_view.dart';

class CustomBottomNavigationBar extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Stack(
      alignment: Alignment.center,
      children: [
        Container(
          height:
              84, // Menambahkan ketinggian container untuk menyesuaikan dengan tombol presensi di luar batas atas navbar
          decoration: BoxDecoration(
            border: Border(
              top: BorderSide(color: Color(0xFFD4D3D2), width: 1.5),
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
                      top: 17,
                      bottom: 6,
                      right: 45,
                      left: 40), // Menambahkan padding
                  child: Column(
                    mainAxisSize: MainAxisSize.max,
                    children: [
                      Icon(
                        Icons.home,
                        size: 32, // Atur ukuran ikon
                      ),
                      SizedBox(width: 5),
                      Text(
                        'Home',
                        style: TextStyle(
                            fontFamily: 'Kanit',
                            fontWeight: FontWeight.w400,
                            fontSize: 13),
                      ),
                    ],
                  ),
                ),
              ),
              SizedBox(
                  width: 10), // Penambahan widget kosong untuk posisi tengah
              InkWell(
                onTap: () {
                  // Tambahkan logika navigasi ke halaman Profile
                  Get.to(() => ProfilePage());
                },
                child: Ink(
                  padding: EdgeInsets.only(
                      top: 17,
                      bottom: 6,
                      right: 40,
                      left: 45), // Menambahkan padding
                  child: Column(
                    mainAxisSize: MainAxisSize.max,
                    children: [
                      Icon(
                        Icons.person,
                        size: 32, // Atur ukuran ikon
                      ),
                      SizedBox(width: 5),
                      Text(
                        'Profil',
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
        ),
        Positioned(
          top:
              0, // Menyesuaikan posisi vertikal dari tombol presensi di atas navbar
          child: SizedBox(
            height: 82, // Sesuaikan ketinggian sesuai dengan kebutuhan
            width: 90, // Sesuaikan lebar sesuai dengan kebutuhan
            child: Column(
              mainAxisAlignment: MainAxisAlignment
                  .center, // Menempatkan konten di tengah secara vertikal
              children: [
                ElevatedButton(
                  style: ElevatedButton.styleFrom(
                      primary: Color(0xFF85817F),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(
                            100), // Setengah dari lebar/tinggi tombol
                      ),
                      padding: EdgeInsets.all(4),
                      elevation: 2),
                  onPressed: () {
                    // Panggil metode handlePresensi saat tombol ditekan
                    Get.find<HomeController>().handlePresensi();
                  },
                  child: Icon(Icons.fingerprint,
                      size: 54, color: Color(0xFFFEFEFE)),
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
    );
  }
}
