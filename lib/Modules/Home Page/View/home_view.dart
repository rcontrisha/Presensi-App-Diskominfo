import 'dart:async';
import 'package:apsi/Modules/Presence%20List/View/plist_view.dart';
import 'package:apsi/Routes/routes.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import '../../../Widgets/custom_bottom_navigation_bar.dart';
import '../../Presence History/View/presence_view.dart';
import '../Controller/home_controller.dart';
import 'package:timezone/data/latest.dart' as tzf_data;
import '../Controller/time_utils.dart';

class HomePage extends StatefulWidget {
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> with TickerProviderStateMixin {
  final HomeController _controller = Get.put(HomeController());
  late AnimationController _opacityController;

  @override
  void initState() {
    super.initState();
    // Initialize the timezone database
    tzf_data.initializeTimeZones();
    // Set initial time
    _opacityController = AnimationController(
      vsync: this,
      duration: Duration(milliseconds: 100),
    );
    _startAnimation();
  }

  void _startAnimation() {
    _opacityController.repeat(reverse: true);
  }

  @override
  Widget build(BuildContext context) {
    double screenWidth = MediaQuery.of(context).size.width;
    double containerHeight = MediaQuery.of(context).size.height;
    late Stream<String> _timeStream =
        TimeUtils.getWIBTimeStream(); // Moved declaration here

    return Scaffold(
      appBar: AppBar(
        backgroundColor: Color(0xFFFEFEFE),
        toolbarHeight: 0,
      ),
      body: Obx(() {
        if (_controller.userData.isEmpty) {
          return Center(child: CircularProgressIndicator());
        } else {
          final List<Map<String, dynamic>> latestPresences =
              _controller.presenceData.length > 3
                  ? _controller.presenceData
                      .sublist(_controller.presenceData.length - 3)
                  : _controller.presenceData;
          return SingleChildScrollView(
            child: Padding(
              padding: const EdgeInsets.only(left: 27.0, right: 27.0, top: 8),
              child: Column(
                children: [
                  Column(
                    children: [
                      Row(
                        children: [
                          CircleAvatar(
                            radius: 40,
                            backgroundImage: NetworkImage(_controller
                                .userImageUrl), // Menampilkan gambar dari URL
                          ),
                          Padding(
                            padding: const EdgeInsets.only(left: 18.0),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  "Selamat Datang,",
                                  style: TextStyle(
                                    color: Color(0xFFB3B1B0),
                                    fontFamily: 'Kanit',
                                    fontSize: 14,
                                    fontWeight: FontWeight.w400,
                                  ),
                                ),
                                SizedBox(height: 2),
                                Text(
                                  "${_controller.userData[0]['nama']}",
                                  style: TextStyle(
                                    color: Color(0xFF000000),
                                    fontFamily: 'Kanit',
                                    fontSize: 15,
                                    fontWeight: FontWeight.w500,
                                  ),
                                ),
                                SizedBox(height: 2),
                                Text(
                                  "${_controller.userData[0]['nip']}",
                                  style: TextStyle(
                                    color: Color(0xFF000000),
                                    fontFamily: 'Kanit',
                                    fontSize: 13,
                                    fontWeight: FontWeight.w500,
                                  ),
                                )
                              ],
                            ),
                          ),
                        ],
                      ),
                      SizedBox(height: 9),
                      Container(
                        width: screenWidth - 27.0 * 2,
                        child: Stack(
                          children: [
                            // Kontainer Biru dan Gambar
                            Container(
                              width: double.infinity,
                              decoration: BoxDecoration(
                                color: Color(0xFF04A3EA),
                                borderRadius: BorderRadius.circular(15.0),
                              ),
                              child: Stack(
                                children: [
                                  // Gambar
                                  Positioned.fill(
                                    child: Image.asset(
                                      'assets/images/home.png',
                                      fit: BoxFit.cover,
                                    ),
                                  ),
                                  // Kontainer Biru
                                  Padding(
                                    padding: const EdgeInsets.all(8),
                                    child: Row(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        // Bagian kiri (Presensi)
                                        Expanded(child: _buildPresensiCard()),
                                        SizedBox(width: 5),
                                        // Bagian kanan (Jam dan Tanggal)
                                        Expanded(
                                            child: _buildJamCard(_timeStream)),
                                      ],
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ),
                      SizedBox(height: 9),
                      Container(
                        width: screenWidth - 27.0 * 2,
                        height: containerHeight - 135 - 545,
                        child: Card(
                          color: Color(0xFFB3B1B0),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(15.0),
                          ),
                          elevation: 4,
                          child: Positioned.fill(
                            child: ClipRRect(
                              borderRadius: BorderRadius.circular(15.0),
                              child: Image.asset(
                                'assets/images/map.png',
                                fit: BoxFit.cover,
                              ),
                            ),
                          ),
                        ),
                      ),
                      SizedBox(height: 10),
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 10),
                        child: Container(
                          child: Text(
                            "Letjend., Jl. Sukowati No.51, Kalicacing, Sidomukti, Salatiga City, Central Java",
                            style: TextStyle(
                              color: Color(0xFFB3B1B0),
                              fontFamily: 'Kanit',
                              fontSize: 12.5,
                              fontWeight: FontWeight.w400,
                            ),
                          ),
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 6),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            const Text(
                              "Riwayat Presensi",
                              style: TextStyle(
                                color: Color(0xFF272528),
                                fontWeight: FontWeight.w500,
                                fontSize: 15.0,
                                fontFamily: 'Kanit',
                              ),
                            ),
                            TextButton(
                              onPressed: () => Get.to(() => PListView()),
                              child: Text(
                                "show all",
                                style: TextStyle(
                                  fontFamily: 'Kanit',
                                  fontWeight: FontWeight.w500,
                                  fontSize: 15,
                                ),
                              ),
                              style: TextButton.styleFrom(
                                primary: Color(0xFF04A3EA),
                              ),
                            ),
                          ],
                        ),
                      ),
                      SizedBox(height: 5),
                      if (latestPresences == null || latestPresences.isEmpty)
                        CircularProgressIndicator()
                      else
                        ListView.builder(
                          shrinkWrap: true,
                          physics: NeverScrollableScrollPhysics(),
                          itemCount: latestPresences.length,
                          itemBuilder: (context, index) {
                            final presence =
                                latestPresences.reversed.toList()[index];
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
                              child: ListTile(
                                time: formattedTime,
                                date: formattedDate,
                              ),
                            );
                          },
                        ),
                    ],
                  ),
                ],
              ),
            ),
          );
        }
      }),
      bottomNavigationBar: CustomBottomNavigationBar(),
    );
  }

  @override
  void dispose() {
    _opacityController.dispose();
    super.dispose();
  }
}

Widget _buildPresensiCard() {
  return Card(
    color: Color(0xFFF7EF17),
    shape: RoundedRectangleBorder(
      borderRadius: BorderRadius.circular(12.0),
    ),
    child: Padding(
      padding: const EdgeInsets.symmetric(vertical: 5.0, horizontal: 15.0),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Text(
            "Presensi Terakhir",
            style: TextStyle(
              fontSize: 15,
              fontFamily: 'Kanit',
              fontWeight: FontWeight.w400,
            ),
          ),
          SizedBox(height: 7), // Beri sedikit jarak antara teks
          Text(
            "07:39", // Anda dapat mempertahankan waktu ini atau menyesuaikannya dengan logika aplikasi Anda
            style: TextStyle(
              fontSize: 32,
              fontFamily: 'Sans',
              fontWeight: FontWeight.w800,
            ),
          ),
        ],
      ),
    ),
  );
}

Widget _buildJamCard(Stream<String> timeStream) {
  return Card(
    color: Color(0xFFF7EF17),
    shape: RoundedRectangleBorder(
      borderRadius: BorderRadius.circular(12.0),
    ),
    child: Padding(
      padding: const EdgeInsets.symmetric(horizontal: 10.0, vertical: 5),
      child: StreamBuilder<String>(
        stream: timeStream,
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            final timeParts = snapshot.data!.split(':');
            final hourPart = timeParts[0];
            final minutePart = timeParts[1];

            final hari = DateTime.now().weekday;
            final tanggal = DateTime.now().day;
            final bulan = DateTime.now().month;
            final tahun = DateTime.now().year;

            final hariStr = [
              'Senin',
              'Selasa',
              'Rabu',
              'Kamis',
              'Jumat',
              'Sabtu',
              'Minggu'
            ][hari - 1]; // -1 karena weekday dimulai dari 1

            final bulanStr = [
              'Jan',
              'Feb',
              'Mar',
              'Apr',
              'Mei',
              'Jun',
              'Jul',
              'Agu',
              'Sep',
              'Okt',
              'Nov',
              'Des'
            ][bulan - 1]; // -1 karena month dimulai dari 1

            return Column(
              mainAxisSize: MainAxisSize.min, // Set mainAxisSize menjadi min
              mainAxisAlignment: MainAxisAlignment
                  .start, // Set mainAxisAlignment menjadi start
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Text(
                  '$hariStr, $tanggal $bulanStr $tahun', // Tampilkan tanggal dan jam
                  style: TextStyle(
                    fontSize: 13,
                    fontFamily: 'Sans',
                    fontWeight: FontWeight.w400,
                  ),
                ),
                SizedBox(height: 10), // Tambahkan jarak antara tanggal dan jam
                Text(
                  '$hourPart:${minutePart}', // Tampilkan jam dan menit
                  style: TextStyle(
                    fontSize: 32,
                    fontFamily: 'Sans',
                    fontWeight: FontWeight.w800,
                  ),
                ),
              ],
            );
          } else {
            return Text(
              'Loading...',
              style: TextStyle(fontSize: 16),
            );
          }
        },
      ),
    ),
  );
}

class ListTile extends StatelessWidget {
  final String time;
  final String date;

  const ListTile({
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
