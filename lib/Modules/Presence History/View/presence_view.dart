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
                      return Padding(
                        padding: const EdgeInsets.symmetric(
                            vertical: 5, horizontal: 10),
                        child: Card(
                          shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(20)),
                          color: Colors.blue[300],
                          child: Padding(
                            padding: const EdgeInsets.all(16.0),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    Text(
                                      'Waktu Presensi',
                                      style: TextStyle(
                                          color: Colors.white,
                                          fontWeight: FontWeight.normal),
                                    ),
                                    Text(
                                      '${DateFormat('EEEE, dd MMMM yyyy', 'id').format(DateTime.parse(presence['waktu']))}',
                                      style: TextStyle(
                                          color: Colors.white,
                                          fontWeight: FontWeight.normal),
                                    )
                                  ],
                                ),
                                SizedBox(
                                  height: 5,
                                ),
                                Text(
                                  '${DateFormat('HH:mm:ss').format(DateTime.parse(presence['waktu']))}',
                                  style: TextStyle(
                                      color: Colors.white,
                                      fontWeight: FontWeight.bold,
                                      fontSize: 18),
                                ),
                                SizedBox(
                                  height: 15,
                                ),
                                Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      'Koordinat',
                                      style: TextStyle(
                                          color: Colors.white,
                                          fontWeight: FontWeight.normal),
                                    ),
                                    SizedBox(height: 5),
                                    Text(
                                      '${presence['latitude']}, ${presence['longitude']}',
                                      style: TextStyle(
                                          color: Colors.white,
                                          fontWeight: FontWeight.bold,
                                          fontSize: 18),
                                    ),
                                  ],
                                ),
                                SizedBox(
                                  height: 15,
                                ),
                                Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      'Device ID',
                                      style: TextStyle(
                                          color: Colors.white,
                                          fontWeight: FontWeight.normal),
                                    ),
                                    SizedBox(height: 5),
                                    Text(
                                      '${presence['device_id']}',
                                      style: TextStyle(
                                          color: Colors.white,
                                          fontWeight: FontWeight.bold,
                                          fontSize: 18),
                                    ),
                                  ],
                                ),
                                SizedBox(height: 15),
                                Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      'Lokasi',
                                      style: TextStyle(
                                          color: Colors.white,
                                          fontWeight: FontWeight.normal),
                                    ),
                                    SizedBox(height: 5),
                                    Text(
                                      '${addressDetails.street}, ${addressDetails.district}, ${addressDetails.kecamatan}, ${addressDetails.city}, ${addressDetails.province}',
                                      style: TextStyle(
                                          color: Colors.white,
                                          fontWeight: FontWeight.bold,
                                          fontSize: 18),
                                    ),
                                  ],
                                )
                              ],
                            ),
                            // child: ListTile(
                            //   textColor: Colors.white,
                            //   title: Text(
                            //       'Waktu Presensi\n${DateFormat('HH:mm:ss').format(DateTime.parse(presence['waktu']))}'),
                            //   trailing: Text(
                            //       '${DateFormat('yyyy-MM-dd').format(DateTime.parse(presence['waktu']))}'),
                            //   subtitle: Column(
                            //     crossAxisAlignment: CrossAxisAlignment.start,
                            //     children: [
                            //       Text(
                            //           'Koordinat\n${presence['latitude']}, ${presence['longitude']}'),
                            //       Text(
                            //           'Lokasi: ${addressDetails.street}, ${addressDetails.district}, ${addressDetails.kecamatan}, ${addressDetails.city}, ${addressDetails.province}'),
                            //       Text('Device ID\n${presence['device_id']}'),
                            //     ],
                            //   ),
                            // ),
                          ),
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
