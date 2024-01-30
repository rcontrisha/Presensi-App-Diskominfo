// home_page.dart
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../Presence History/View/presence_view.dart';
import '../Controller/home_controller.dart';

class HomePage extends StatelessWidget {
  final HomeController _controller = Get.put(HomeController());

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Presensi'),
        centerTitle: true,
        backgroundColor: Colors.blue[700],
        foregroundColor: Colors.white,
        automaticallyImplyLeading: false,
      ),
      body: Obx(() => _controller.isLoading
          ? Center(child: CircularProgressIndicator())
          : SingleChildScrollView(
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: Column(
                  children: [
                    if (_controller.currentPosition != null)
                      Center(
                        child: Column(
                          children: [
                            Text(
                              'Latitude: ${_controller.currentPosition!.latitude}\nLongitude: ${_controller.currentPosition!.longitude}',
                              style: TextStyle(fontSize: 18),
                            ),
                            SizedBox(height: 20),
                            Text(
                              'Distance to Office: ${_controller.calculateDistance(_controller.currentPosition, CompanyData.office)} meters',
                              style: TextStyle(fontSize: 18),
                            ),
                            SizedBox(height: 20),
                            ElevatedButton(
                              onPressed: () {
                                _controller.handlePresensi();
                              },
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
