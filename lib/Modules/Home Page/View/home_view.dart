// home_page.dart
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../Presence History/View/presence_view.dart';
import '../Controller/home_controller.dart';

class HomePage extends StatelessWidget {
  final HomeController _controller = Get.put(HomeController());

  @override
  Widget build(BuildContext context) {
    double screenWidth = MediaQuery.of(context).size.width;
    double screenHeight = MediaQuery.of(context).size.height;

    return Scaffold(
      body: Obx(() => _controller.isLoading
          ? Center(child: CircularProgressIndicator())
          : SingleChildScrollView(
              child: Padding(
                padding: const EdgeInsets.only(top: 45.0),
                child: Column(
                  children: [
                    if (_controller.currentPosition != null)
                      Padding(
                        padding: const EdgeInsets.only(left: 27.0, right: 27.0),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Row(
                              children: [
                                CircleAvatar(radius: 40),
                                Padding(
                                  padding: const EdgeInsets.only(left: 15.0),
                                  child: Column(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        "Selamat Datang,",
                                        style: TextStyle(
                                          color: Color(0xFFB3B1B0),
                                          fontFamily: 'Kanit',
                                          fontSize: 14,
                                          fontWeight: FontWeight.w400
                                        ),
                                      ),
                                      SizedBox(height: 3,),
                                      Text(
                                        "Wan Dilo Syuja Sherlieno",
                                        style: TextStyle(
                                          color: Color(0xFF000000),
                                          fontFamily: 'Kanit',
                                          fontSize: 15,
                                          fontWeight: FontWeight.w500
                                        ),
                                      )
                                    ],
                                  ),
                                ),
                              ],
                            ),
                            Container(
                              width: screenWidth - 27.0 * 2,
                              height: 158,
                              child: Card(
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(15.0),
                                ),
                                elevation: 5,
                                child: Padding(
                                  padding: const EdgeInsets.all(16.0),
                                  child: Container(
                                    width: 269,
                                    height: 58,
                                    child: Card(
                                      shape: RoundedRectangleBorder(
                                        borderRadius: BorderRadius.circular(15.0),
                                      ),
                                      elevation: 5,
                                      child: Center(
                                        child: Text(
                                          "Inner Card b",
                                          style: TextStyle(fontSize: 16),
                                        ),
                                      ),
                                    ),
                                  ),
                                ),
                              ),
                            ),
                            Text(
                              'Latitude: ${_controller.currentPosition!.latitude}\nLongitude: ${_controller.currentPosition!.longitude}',
                              style: TextStyle(fontSize: 18),
                            ),
                            SizedBox(height: 20),
                            Text(
                              'Distance to Office: ${_controller.calculateDistance(_controller.currentPosition, CompanyData.office)} meters',
                              style: TextStyle(fontSize: 18),
                            ),
                            ElevatedButton(
                              onPressed: _controller.handlePresensi,
                              child: Text('Presensi'),
                            ),
                            SizedBox(height: 20),
                            ElevatedButton(
                              onPressed: _controller.launchOfficeOnMap,
                              child: Text('Launch Office on Map'),
                            ),
                            SizedBox(height: 20),
                            ElevatedButton(
                              onPressed: () {
                                // Navigate to the Presence History page
                                Get.to(() => PresencePage());
                              },
                              child: Text('Presence History'),
                            ),
                            SizedBox(height: 20),
                            ElevatedButton(
                              onPressed: _controller.logout,
                              child: Text('Log Out'),
                            ),
                          ],
                        ),
                      ),
                  ],
                ),
              ),
            )),
    );
  }
}
