import 'package:apsi/Modules/Home%20Page/View/home_view.dart';
import 'package:apsi/Modules/Presence%20Detail/View/pdetail_view.dart';
import 'package:apsi/Modules/Presence%20List/Controller/plist_controller.dart';
import 'package:apsi/Routes/routes.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';

class PListView extends StatefulWidget {
  @override
  _PListViewState createState() => _PListViewState();
}

class _PListViewState extends State<PListView> {
  final PresenceListController _controller = Get.put(PresenceListController());

  @override
  Widget build(BuildContext context) {
    double screenWidth = MediaQuery.of(context).size.width;

    return Scaffold(
      appBar: AppBar(
        title: Text(
          "Riwayat Presensi",
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
            Get.offAll(() => HomePage());
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
        if (_controller.isLoading) {
          return Center(child: CircularProgressIndicator());
        } else {
          return SingleChildScrollView(
            child: Padding(
              padding: const EdgeInsets.only(left: 27.0, right: 27.0, top: 8),
              child: Column(
                children: [
                  SizedBox(height: 10),
                  ListView.builder(
                    shrinkWrap: true,
                    physics: NeverScrollableScrollPhysics(),
                    itemCount: _controller.presenceData.length,
                    itemBuilder: (context, index) {
                      final presence =
                          _controller.presenceData.reversed.toList()[index];
                      final waktu = presence['waktu'];
                      final dateTime = DateTime.parse(waktu);

                      final formattedDate =
                          DateFormat('dd MMMM yyyy').format(dateTime);
                      final formattedTime =
                          DateFormat('HH:mm').format(dateTime);

                      return GestureDetector(
                        onTap: () {
                          Get.toNamed(
                              '${AppRoutes.presenceDetail}?id=${presence['id']}');
                        },
                        child: CustomListTile(
                          time: formattedTime,
                          date: formattedDate,
                        ),
                      );
                    },
                  ),
                ],
              ),
            ),
          );
        }
      }),
    );
  }
}

class CustomListTile extends StatelessWidget {
  final String time;
  final String date;

  const CustomListTile({
    Key? key,
    required this.time,
    required this.date,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      width: MediaQuery.of(context).size.width - 20,
      margin: const EdgeInsets.only(bottom: 15.0),
      child: Material(
        color: const Color(0xFF04A3EA),
        elevation: 3.0,
        borderRadius: BorderRadius.circular(10),
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: 20.0, horizontal: 10.0),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SizedBox(width: 8.0),
              Row(
                children: [
                  Text(
                    "Presensi  :",
                    maxLines: 1,
                    style: const TextStyle(
                      color: Color(0xFFFEFEFE),
                      fontFamily: 'Kanit',
                      fontWeight: FontWeight.w500,
                      fontSize: 14.0,
                    ),
                  ),
                  SizedBox(width: 10),
                  Text(
                    time,
                    maxLines: 1,
                    style: const TextStyle(
                      color: Color(0xFFFEFEFE),
                      fontFamily: 'Kanit',
                      fontWeight: FontWeight.w500,
                      fontSize: 14.0,
                    ),
                  ),
                ],
              ),
              Expanded(
                child: Align(
                  alignment: Alignment.topRight,
                  child: Text(
                    date,
                    maxLines: 1,
                    style: const TextStyle(
                      color: Color(0xFFFEFEFE),
                      fontFamily: 'Kanit',
                      fontWeight: FontWeight.w400,
                      fontSize: 11.0,
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
