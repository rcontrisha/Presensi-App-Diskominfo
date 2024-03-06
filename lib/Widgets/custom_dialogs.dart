import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../Modules/Profile Page/View/profile.dart';

class CustomDialogs {
  static Future<bool> showAttendanceConfirmation(BuildContext context) async {
    bool? result = await showDialog<bool>(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text(
            "Ingin melakukan presensi?",
            style: TextStyle(fontWeight: FontWeight.w600, fontFamily: 'Kanit', fontSize: 16, color: Color(0xFF000000)),
          ),
          content: Text(
            "Anda perlu melakukan konfirmasi terlebih dahulu sebelum dapat melakukan presensi.",
            style: TextStyle(fontFamily: 'Kanit', fontSize: 16, fontWeight: FontWeight.w300, color: Color(0xFF000000)),
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop(false); // Kembalikan false ketika tombol "Tidak" ditekan
              },
              child: Text("Tidak", style: TextStyle(fontFamily: 'Kanit', fontSize: 16, fontWeight: FontWeight.w400, color: Color(0xFF0500FF))),
            ),
            TextButton(
              onPressed: () {
                Navigator.of(context).pop(true); // Kembalikan true ketika tombol "Ya" ditekan
                // Tambahkan navigasi ke halaman profile di sini
                Get.to(() => ProfilePage());
              },
              child: Text("Ya", style: TextStyle(fontFamily: 'Kanit', fontSize: 16, fontWeight: FontWeight.w400, color: Color(0xFF0500FF)),),
            ),
          ],
        );
      },
    );

    // Mengembalikan nilai default jika hasil adalah null
    return result ?? false;
  }

  static Future<bool> showLogoutConfirmation(BuildContext context) async {
    bool? result = await showDialog<bool>(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text(
            "Anda yakin ingin Keluar?",
            style: TextStyle(fontWeight: FontWeight.w600, fontFamily: 'Kanit', fontSize: 16, color: Color(0xFF000000)),
          ),
          content: Text(
            "Anda perlu melakukan konfirmasi terlebih dahulu sebelum dapat keluar aplikasi.",
            style: TextStyle(fontFamily: 'Kanit', fontSize: 16, fontWeight: FontWeight.w300, color: Color(0xFF000000)),
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop(false); // Mengembalikan false ketika tombol "Tidak" ditekan
              },
              child: Text("Tidak", style: TextStyle(fontFamily: 'Kanit', fontSize: 16, fontWeight: FontWeight.w400, color: Color(0xFF0500FF))),
            ),
            TextButton(
              onPressed: () {
                Navigator.of(context).pop(true); // Mengembalikan true ketika tombol ya ditekan
              },
              child: Text("Ya", style: TextStyle(fontFamily: 'Kanit', fontSize: 16, fontWeight: FontWeight.w400, color: Colors.redAccent)),
            ),
          ],
        );
      },
    );

    // Mengembalikan nilai default jika hasil adalah null
    return result ?? false;
  }

  static Future<void> showLoginFailed(BuildContext context) async {
    return showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text(
            "Login Gagal!",
            style: TextStyle(fontFamily: 'Kanit', fontSize: 16, fontWeight: FontWeight.w600, color: Color(0xFF000000)),
          ),
          content: Text(
            "Silahkan Login menggunakan NIP/Email yang sesuai dengan Device ID yang didaftarkan.",
              style: TextStyle(fontFamily: 'Kanit', fontSize: 16, fontWeight: FontWeight.w300, color: Color(0xFF000000))
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop(); // Menutup dialog ketika tombol ditekan
              },
              child: Text("Mengerti", style: TextStyle(fontFamily: 'Kanit', fontSize: 16, fontWeight: FontWeight.w400, color: Color(0xFF0500FF))),
            ),
          ],
        );
      },
    );
  }
}
