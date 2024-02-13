import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/date_symbol_data_local.dart';
import 'package:intl/intl.dart';
import '../Controller/presence_controller.dart';

class PresencePage extends StatelessWidget {
  final PresenceController _controller = Get.put(PresenceController());

  @override
  Widget build(BuildContext context) {
    initializeDateFormatting('id', null); // Initialize Indonesian locale

    return Scaffold(
      appBar: AppBar(
        title: Text('Riwayat Kehadiran'),
        centerTitle: true,
        backgroundColor: Colors.blue[700],
        foregroundColor: Colors.white,
      ),
      body: Obx(
        () {
          if (_controller.isLoading.value) {
            return Center(child: CircularProgressIndicator());
          } else if (_controller.presenceData.isEmpty) {
            return Center(child: Text('Tidak ada data.'));
          } else {
            return ListView.builder(
              itemCount: _controller.presenceData.length,
              itemBuilder: (context, index) {
                final presence = _controller.presenceData[index];
                return FutureBuilder<AddressDetails>(
                  future: _controller.getPlaceMarks(
                    presence['latitude']?.toString() ??
                        '', // Pastikan latitude tidak null
                    presence['longitude']?.toString() ??
                        '', // Pastikan longitude tidak null
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
                        subtitle: Text('Gagal mengambil lokasi'),
                      );
                    } else if (!snapshot.hasData) {
                      return ListTile(
                        title: Text('NIP: ${presence['nip']}'),
                        subtitle: Text('Lokasi tidak ditemukan'),
                      );
                    } else {
                      final addressDetails = snapshot.data!;
                      // Memisahkan waktu kehadiran menjadi tanggal dan waktu
                      final DateTime presenceTime =
                          DateTime.parse(presence['waktu']);
                      final formattedDate = DateFormat.yMMMMEEEEd('id')
                          .format(presenceTime); // Hari, d MMMM yyyy
                      final formattedTime =
                          DateFormat('HH:mm:ss').format(presenceTime);
                      return ListTile(
                        title: Text('NIP: ${presence['nip']}'),
                        subtitle: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              'Lokasi: ${addressDetails.street}, ${addressDetails.district}, ${addressDetails.kecamatan}, ${addressDetails.city}, ${addressDetails.province}',
                            ),
                            Text('Latitude: ${presence['latitude']}'),
                            Text('Longitude: ${presence['longitude']}'),
                            Text('Tanggal: $formattedDate'),
                            Text('Waktu: $formattedTime'),
                            Text('ID Perangkat: ${presence['device_id']}'),
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
