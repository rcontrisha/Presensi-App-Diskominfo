import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:maps/Modules/Profile%20Page/View/Profile.dart';
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
              height: 65,
              width: MediaQuery.of(context).size.width, // Menambahkan ketinggian container untuk menyesuaikan dengan tombol presensi di luar batas atas navbar
              decoration: BoxDecoration(
                border: Border(
                  top: BorderSide(color: Color(0xFFD4D3D2), width: 1),
                ),
              ),
              child: BottomAppBar(
                shape: CircularNotchedRectangle(),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: <Widget>[
                    Expanded(
                      child: InkWell(
                        onTap: () {
                          // Tambahkan logika navigasi ke halaman Home
                          Get.to(() => HomePage());
                        },
                        child: Container(
                          height: 65,
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Container(
                                margin: EdgeInsets.only(bottom: 4),
                                child: Icon(
                                  Icons.home,
                                  size: 17, // Atur ukuran ikon
                                ),
                              ),
                              Text(
                                'Home',
                                style: TextStyle(
                                  fontFamily: 'Kanit',
                                  fontWeight: FontWeight.w400,
                                  fontSize: 10,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                    Container(
                      width: MediaQuery.of(context).size.width / 4,
                      margin: EdgeInsets.only(top: 24),
                      alignment: Alignment.center,
                      child: Text(
                        "Presensi",
                        style: TextStyle(
                          fontSize: 13,
                          fontFamily: 'Kanit',
                          fontWeight: FontWeight.w400,
                        ),
                      ),
                    ),
                    Expanded(
                      child: InkWell(
                        onTap: () {
                          // Tambahkan logika navigasi ke halaman Profile
                          Get.to(() => ProfilePage());
                        },
                        child: Container(
                          height: 65,
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,z
                            children: [
                              Icon(
                                Icons.person,
                                size: 32, // Atur ukuran ikon
                              ),
                              SizedBox(width: 5),
                              Text(
                                'Profil',
                                style: TextStyle(fontFamily: 'Kanit', fontWeight: FontWeight.w400, fontSize: 13),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
          Positioned(
            top: 0, // Menyesuaikan posisi vertikal dari tombol presensi di atas navbar
            child: SizedBox(
              height: 82, // Sesuaikan ketinggian sesuai dengan kebutuhan
              width: 90, // Sesuaikan lebar sesuai dengan kebutuhan
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center, // Menempatkan konten di tengah secara vertikal
                children: [
                  ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      primary: Color(0xFF85817F),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(100), // Setengah dari lebar/tinggi tombol
                      ),
                      padding: EdgeInsets.all(4),
                      elevation: 2
                    ),
                    onPressed: () {
                      // Tambahkan logika untuk tombol presensi
                      //Get.to(() => PresencePage());
                    },
                    child: Icon(Icons.fingerprint, size: 54, color: Color(0xFFFEFEFE)),
                  ),
                  Text(
                    "Presensi",
                    style: TextStyle(fontFamily: 'Kanit', fontWeight: FontWeight.w400, fontSize: 13),
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
