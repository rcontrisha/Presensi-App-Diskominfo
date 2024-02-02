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
                      String formattedDate = DateFormat('EEEE, MMM d, y')
                          .format(DateTime.parse(presence['tanggal']));
                      return ListTile(
                        title: Text('NIP: ${presence['nip']}'),
                        subtitle: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                                'Location: ${addressDetails.street}, ${addressDetails.district}, ${addressDetails.kecamatan}, ${addressDetails.city}, ${addressDetails.province}'),
                            Text('Latitude: ${presence['latitude']}'),
                            Text('Longitude: ${presence['longitude']}'),
                            Text('Date: ${presence['tanggal']}'),
                            Text(
                                'Check In: ${presence['check_in'] as String? ?? 'N/A'}'),
                            Text(
                                'Check Out: ${presence['check_out'] as String? ?? 'N/A'}'),
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
