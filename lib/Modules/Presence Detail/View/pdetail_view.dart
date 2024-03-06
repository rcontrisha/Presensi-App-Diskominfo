import 'package:apsi/Modules/Presence%20Detail/Controller/pdetail_controller.dart';
import 'package:apsi/Modules/Presence%20List/View/plist_view.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';

class PresenceDetailView extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final PresenceDetailController controller =
        Get.put(PresenceDetailController());

    return Scaffold(
      appBar: AppBar(
        title: Text(
          "Detail Presensi",
          style: TextStyle(
              fontFamily: 'Kanit',
              fontSize: 15,
              fontWeight: FontWeight.w500,
              color: Colors.black),
        ),
        backgroundColor: Color(0xFFFEFEFE),
        centerTitle: true,
        automaticallyImplyLeading: false,
        leading: IconButton(
          icon: Icon(Icons.arrow_back_ios_new),
          color: Colors.black,
          onPressed: () {
            Get.back();
          },
        ),
        bottom: PreferredSize(
          preferredSize: Size.fromHeight(0), // Tinggi garis bawah
          child: Container(
            color: Color(0xFFD4D3D2), // Warna garis bawah
            height: 1.0, // Ketebalan garis bawah
          ),
        ),
      ),
      body: Obx(() {
        if (controller.isLoading.value) {
          return Center(
            child: CircularProgressIndicator(),
          );
        } else {
          // Mengakses data presensi dari controller
          final presence = controller.presence.value;

          // Mengakses nilai waktu dari data presensi
          final waktu = presence['waktu'] as String;
          final dateTime = DateTime.parse(waktu);

          // Mengonversi waktu menjadi format yang diinginkan
          final formattedDate =
              DateFormat('EEEE, d MMMM yyyy', 'id').format(dateTime);
          final formattedTime = DateFormat('HH:mm').format(dateTime);

          // Mendapatkan detail alamat menggunakan getPlaceMarks
          final addressDetails = controller.getPlaceMarks(
            presence['latitude'].toString(),
            presence['longitude'].toString(),
          );

          return FutureBuilder<AddressDetails>(
            future: addressDetails,
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                return Center(
                  child: CircularProgressIndicator(),
                );
              }

              if (snapshot.hasError) {
                return Center(
                  child: Text('Error: ${snapshot.error}'),
                );
              }

              final address = snapshot.data!;

              return Padding(
                padding: const EdgeInsets.all(10.0),
                child: Container(
                  height: 300.0, // Atur tinggi card di sini
                  child: Card(
                    color: Color(0xFFF7EF17),
                    elevation: 3.0,
                    child: Padding(
                      padding: const EdgeInsets.all(16.0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text(
                                '$formattedTime',
                                style: TextStyle(
                                  fontFamily: 'Kanit',
                                  fontWeight: FontWeight.w500,
                                  fontSize: 18,
                                ),
                              ),
                              Text(
                                '$formattedDate',
                                style: TextStyle(
                                  fontFamily: 'Kanit',
                                  fontWeight: FontWeight.w500,
                                  fontSize: 16,
                                ),
                              ),
                            ],
                          ),
                          SizedBox(height: 10),
                          Text(
                            'NIP',
                            style: TextStyle(
                                fontFamily: 'Kanit',
                                fontWeight: FontWeight.w500,
                                fontSize: 18),
                          ),
                          Text(
                            '${presence['nip']}',
                            style: TextStyle(
                              fontFamily: 'Kanit',
                              fontWeight: FontWeight.w400,
                            ),
                          ),
                          SizedBox(height: 10),
                          Text(
                            'Latitude',
                            style: TextStyle(
                                fontFamily: 'Kanit',
                                fontWeight: FontWeight.w500,
                                fontSize: 18),
                          ),
                          Text(
                            '${presence['latitude']}',
                            style: TextStyle(
                              fontFamily: 'Kanit',
                              fontWeight: FontWeight.w400,
                            ),
                          ),
                          SizedBox(height: 10),
                          Text(
                            'Longitude',
                            style: TextStyle(
                                fontFamily: 'Kanit',
                                fontWeight: FontWeight.w500,
                                fontSize: 18),
                          ),
                          Text(
                            '${presence['longitude']}',
                            style: TextStyle(
                              fontFamily: 'Kanit',
                              fontWeight: FontWeight.w400,
                            ),
                          ),
                          SizedBox(height: 10),
                          Text(
                            'ID Perangkat',
                            style: TextStyle(
                                fontFamily: 'Kanit',
                                fontWeight: FontWeight.w500,
                                fontSize: 18),
                          ),
                          Text(
                            '${presence['device_id']}',
                            style: TextStyle(
                              fontFamily: 'Kanit',
                              fontWeight: FontWeight.w400,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              );
            },
          );
        }
      }),
    );
  }
}
