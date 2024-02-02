import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../Login Page/View/login_view.dart';

class LandingPage extends StatefulWidget {
  const LandingPage({super.key});

  @override
  State<LandingPage> createState() => _LandingPageState();
}

class _LandingPageState extends State<LandingPage> {

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: const BoxDecoration(
          color: Color(0xFF04A3EA), // Warna latar belakang
        ),
        margin: const EdgeInsets.symmetric(horizontal: 0.0, vertical: 0.0),
        child: Column(
          children: [
            Material(
              elevation: 10, // Tinggi efek bayangan
              shadowColor: Colors.black, // Warna efek bayangan
              borderRadius: BorderRadius.circular(30),
              child: ClipRRect(
                borderRadius: BorderRadius.circular(30),
                child: Image.asset(
                  "assets/images/diskominfo_salatiga.jpg",
                  width: MediaQuery.of(context).size.width,
                  height: MediaQuery.of(context).size.height / 1.7,
                  fit: BoxFit.cover,
                ),
              ),
            ),
            const SizedBox(
              height: 60.0,
            ),
            const Text(
              "APSI-SALATIGA",
              style: TextStyle(
                  color: Color(0xFFFEFEFE),
                  fontSize: 35.0,
                  fontWeight: FontWeight.w700,
                  fontFamily: 'Kanit'
              ),
            ),
            const SizedBox(
              height: 20.0,
            ),
            const Text(
              "Presensi Lebih Mudah, Manajemen\n   Lebih Efisien - APSI Dalam Aksi.",
              style: TextStyle(
                  color: Colors.white,
                  fontSize: 18.0,
                  fontFamily: 'Kanit',
                  fontWeight: FontWeight.w300),
            ),
            const SizedBox(
              height: 40.0,
            ),
            SizedBox(
              height: MediaQuery.of(context).size.height / 17,
              width: MediaQuery.of(context).size.width / 1.6,
              child: ElevatedButton(
                onPressed: () {
                  // Navigate to the Presence History page
                  Get.to(() => LoginScreen());
                },
                style: ElevatedButton.styleFrom(
                  primary: Color(0xFFF7EF17), // Warna latar belakang
                  onPrimary: Color(0xFF14678B), // Warna teks
                  elevation: 6, // Tinggi efek shadow
                  shadowColor: Colors.black, // Warna efek shadow
                ),
                child: Text(
                  'Selanjutnya',
                  style: TextStyle(
                    fontWeight: FontWeight.w600,
                    fontSize: 18,
                    fontFamily: 'Kanit',
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
