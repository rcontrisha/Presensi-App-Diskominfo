import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:maps/Modules/Profile%20Page/View/Profile.dart';

class ProfileDetail extends StatefulWidget {
  const ProfileDetail({Key? key}) : super(key: key);

  @override
  State<ProfileDetail> createState() => _ProfileDetailState();
}

class _ProfileDetailState extends State<ProfileDetail> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          "Informasi Profil",
          style: TextStyle(
            fontFamily: 'Kanit',
            fontSize: 15,
            fontWeight: FontWeight.w500,
          ),
        ),
        backgroundColor: Color(0xFFFEFEFE),
        centerTitle: true,
        automaticallyImplyLeading: false,
        leading: IconButton(
          icon: Icon(Icons.arrow_back_ios_new),
          onPressed: () {
            Get.offAll(() => ProfilePage());
          },
        ),
        bottom: PreferredSize(
          preferredSize: Size.fromHeight(0), // Tinggi garis bawah
          child: Container(
            color: Color(0xFFD4D3D2), // Warna garis bawah
            height: 1.0, // Ketebalan garis bawah
          ),
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(vertical: 20.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Center(
              child: CircleAvatar(
                radius: 70,
              ),
            ),
            SizedBox(height: 15),
            _buildList("NIP", "10000001"),
            _buildList("Nama Lengkap", "Dilo Syuja Sherlieno"),
            _buildList("Jabatan", "Pengawas II"),
            _buildList("Email", "dilosyuja@gmail.com"),
            _buildList("Nama Perangkat", "Xiaomi Redmi 9 Pro MaxWin"),
            _buildList("ID Perangkat", "531728506629275a"),
          ],
        ),
      ),
    );
  }

  Widget _buildList(String label, String value) {
    double screenWidth = MediaQuery.of(context).size.width;

    return Container(
      margin: EdgeInsets.symmetric(vertical: 8),
      padding: EdgeInsets.symmetric(
        horizontal: screenWidth * 0.04, // Tambah padding kiri dan kanan
        vertical: screenWidth * 0.03, // Padding atas dan bawah
      ),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(15),
        color: Color(0xFFE7E7FF),
        border: Border.all(
          color: Color(0xFFD4D3D2), // Warna garis
          width: 1, // Ketebalan garis
        ),
      ),
      child: SizedBox(
        width: screenWidth - (2 * screenWidth * 0.12), // Lebar konten list responsif
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(
              padding: EdgeInsets.only(
                left: screenWidth * 0.025, // Geser label ke kanan
                bottom: screenWidth * 0.005, // Padding bawah label
              ),
              child: Text(
                label,
                style: TextStyle(
                  color: Color(0xFFB3B1B0),
                  fontFamily: 'Kanit',
                  fontSize: 13,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ),
            Padding(
              padding: EdgeInsets.only(left: screenWidth * 0.025), // Geser value ke kanan
              child: Text(
                value,
                textAlign: TextAlign.left,
                style: TextStyle(
                  color: Color(0xFF272528),
                  fontFamily: 'Kanit',
                  fontSize: 15,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}