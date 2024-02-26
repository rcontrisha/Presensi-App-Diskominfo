import 'package:flutter/material.dart';

class ProfileController {
  Widget buildField(String title, String imagePath, Color color, VoidCallback onTap) {
    return Container(
      decoration: BoxDecoration(
        border: title == "Informasi Profil"
            ? Border(
          top: BorderSide(
            color: Colors.grey.withOpacity(1), // Warna dan ketebalan garis tepi atas
            width: 1.0,
          ),
          bottom: BorderSide(
            color: Colors.grey.withOpacity(1), // Warna dan ketebalan garis tepi bawah
            width: 1.0,
          ),
        )
            : Border(
          bottom: BorderSide(
            color: Colors.grey.withOpacity(1), // Warna dan ketebalan garis tepi bawah
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
