// presence_view.dart
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import '../Controller/presence_controller.dart';

class PresencePage extends StatelessWidget {
  final PresenceController _controller = Get.put(PresenceController());

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Presence History'),
        centerTitle: true,
        backgroundColor: Colors.blue[700],
        foregroundColor: Colors.white,
      ),
      body: Obx(
        () {
          if (_controller.isLoading.value) {
            return Center(child: CircularProgressIndicator());
          } else if (_controller.presenceData.isEmpty) {
            return Center(child: Text('No data available.'));
          } else {
            return ListView.builder(
              itemCount: _controller.presenceData.length,
              itemBuilder: (context, index) {
                final presence = _controller.presenceData[index];
                return FutureBuilder<AddressDetails>(
                  future: _controller.getPlaceMarks(
                    presence['latitude'],
                    presence['longitude'],
                  ),
                  builder: (context, snapshot) {
                    if (snapshot.connectionState == ConnectionState.waiting) {
                      return ListTile(
                        title: Text('NIP: ${presence['nip']}'),
                        subtitle: CircularProgressIndicator(),
                      );
                    } else if (snapshot.hasError) {
                      return ListTile(
                        title: Text('NIP: ${presence['nip']}'),
                        subtitle: Text('Error fetching location'),
                      );
                    } else if (!snapshot.hasData) {
                      return ListTile(
                        title: Text('NIP: ${presence['nip']}'),
                        subtitle: Text('Location not found'),
                      );
                    } else {
                      final addressDetails = snapshot.data!;
                      return ListTile(
                        title: Text('NIP: ${presence['nip']}'),
                        subtitle: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                                'Lokasi: ${addressDetails.street}, ${addressDetails.district}, ${addressDetails.kecamatan}, ${addressDetails.city}, ${addressDetails.province}'),
                            Text('Latitude: ${presence['latitude']}'),
                            Text('Longitude: ${presence['longitude']}'),
                            Text('Waktu Presensi: ${presence['waktu']}'),
                            Text('Device ID: ${presence['device_id']}'),
                          ],
                        ),
                      );
                    }
                  },
                );
              },
            );
          }
        },
      ),
    );
  }
}
