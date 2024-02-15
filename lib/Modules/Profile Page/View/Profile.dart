import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../Widgets/custom_bottom_navigation_bar.dart';

class ProfilePage extends StatefulWidget {
  const ProfilePage({super.key});

  @override
  State<ProfilePage> createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
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
                radius: 70,
              ),
              SizedBox(height: 20,),
              Column(
                children: [
                  Text(
                    "Dilo Syuja Sherlieno",
                    style: TextStyle(
                      color: Color(0xFF000000),
                      fontFamily: 'Kanit',
                      fontSize: 16,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                  SizedBox(height: 5,),
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
              SizedBox(height: 70,),
              Container(
                decoration: BoxDecoration(
                  shape: BoxShape.rectangle,
                  border: Border.all(width: 35),
                ),
              ),
              Container(
                decoration: BoxDecoration(
                    shape: BoxShape.rectangle,
                    border: Border.all(width: 35, color: Colors.transparent),
                    color: Colors.yellowAccent
                ),
              ),
            ],
          ),
        ),
      ),
      bottomNavigationBar: CustomBottomNavigationBar(),
    );
  }
}
