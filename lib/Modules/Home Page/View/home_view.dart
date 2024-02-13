import 'dart:async';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
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
  late Stream<String> _timeStream = Stream.empty();
  late AnimationController _opacityController;

  @override
  void initState() {
    super.initState();
    // Initialize the timezone database
    tzf_data.initializeTimeZones();
    // Initialize the time stream
    _timeStream = TimeUtils.getWIBTimeStream();
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

    return Scaffold(
      appBar: AppBar(
        backgroundColor: Color(0xFFFEFEFE),
        toolbarHeight: 0,
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
                  if (_controller.currentPosition != null)
                    Column(
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
                                      fontWeight: FontWeight.w400,
                                    ),
                                  ),
                                  SizedBox(height: 3),
                                  Text(
                                    "Dilo Syuja Sherlieno",
                                    style: TextStyle(
                                      color: Color(0xFF000000),
                                      fontFamily: 'Kanit',
                                      fontSize: 15,
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
                          height: containerHeight - 135 - 545,
                          child: Card(
                            color: Color(0xFF04A3EA),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(15.0),
                            ),
                            elevation: 4,
                            child: Stack(
                              children: [
                                Padding(
                                  padding: const EdgeInsets.symmetric(horizontal: 25.0, vertical: 20),
                                  child: Column(
                                    mainAxisAlignment: MainAxisAlignment.start,
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        "Pengawas II",
                                        style: TextStyle(
                                          color: Color(0xFFFEFEFE),
                                          fontFamily: 'Kanit',
                                          fontSize: 15,
                                          fontWeight: FontWeight.w400,
                                        ),
                                      ),
                                      Text(
                                        "10000001",
                                        style: TextStyle(
                                          color: Color(0xFFFEFEFE),
                                          fontFamily: 'Kanit',
                                          fontSize: 15,
                                          fontWeight: FontWeight.w500,
                                        ),
                                      )
                                    ],
                                  ),
                                ),
                                Positioned.fill(
                                  child: ClipRRect(
                                    borderRadius: BorderRadius.circular(15.0),
                                    child: Opacity(
                                      opacity: 0.65,
                                      child: Image.asset(
                                        'assets/images/home.png',
                                        fit: BoxFit.cover,
                                      ),
                                    ),
                                  ),
                                ),
                                Center(
                                  child: Padding(
                                    padding: const EdgeInsets.only(top: 85.0, bottom: 13, left: 15, right: 15),
                                    child: Container(
                                      width: 320,
                                      height: 72,
                                      child: Card(
                                        color: Color(0xFFF7EF17),
                                        shape: RoundedRectangleBorder(
                                          borderRadius: BorderRadius.circular(12.0),
                                        ),
                                        child: Padding(
                                          padding: const EdgeInsets.symmetric(vertical: 10.0, horizontal: 30.0),
                                          child: Stack(
                                            alignment: Alignment.center,
                                            children: [
                                              Positioned(
                                                left: 15,
                                                child: Column(
                                                  mainAxisAlignment: MainAxisAlignment.center,
                                                  crossAxisAlignment: CrossAxisAlignment.center,
                                                  children: [
                                                    Text(
                                                      "Presensi",
                                                      style: TextStyle(
                                                        fontSize: 14,
                                                        fontFamily: 'Kanit',
                                                        fontWeight: FontWeight.w500,
                                                      ),
                                                    ),
                                                    Text(
                                                      "07:39 AM",
                                                      style: TextStyle(
                                                        fontSize: 15,
                                                        fontFamily: 'Sans',
                                                        fontWeight: FontWeight.w800,
                                                      ),
                                                    ),
                                                  ],
                                                ),
                                              ),
                                              Positioned(
                                                left: 125,
                                                child: Container(
                                                  width: 1.5,
                                                  height: 40,
                                                  color: Color(0xFF272528),
                                                ),
                                              ),
                                              Positioned(
                                                right: 0,
                                                child: StreamBuilder<String>(
                                                  stream: _timeStream,
                                                  builder: (context, snapshot) {
                                                    if (snapshot.hasData) {
                                                      final timeParts = snapshot.data!.split(':');
                                                      final hourPart = timeParts[0];
                                                      final minutePart = timeParts[1];
                                                      final isPM = int.parse(hourPart) >= 12;

                                                      return Padding(
                                                        padding: const EdgeInsets.only(top: 0, right: 0), // Sesuaikan padding kanan agar tidak terlalu rapat dengan tepi layar
                                                        child: Row(
                                                          mainAxisSize: MainAxisSize.min,
                                                          crossAxisAlignment: CrossAxisAlignment.center,
                                                          children: [
                                                            Text(
                                                              '$hourPart', // Tampilkan jam
                                                              style: TextStyle(fontSize: 32, fontFamily: 'Sans', fontWeight: FontWeight.w800, fontStyle: FontStyle.italic),
                                                            ),
                                                            Opacity(
                                                              opacity: DateTime.now().second % 2 == 0 ? 1.0 : 0.0, // Set opacity menjadi 0 atau 1 bergantung pada detik genap atau ganjil
                                                              child: Text(
                                                                ':',
                                                                style: TextStyle(
                                                                  fontSize: 29,
                                                                  fontFamily: 'Sans',
                                                                  fontWeight: FontWeight.w800,
                                                                  fontStyle: FontStyle.italic
                                                                ),
                                                              ),
                                                            ),
                                                            Text(
                                                              '$minutePart', // Tampilkan menit
                                                              style: TextStyle(fontSize: 32, fontFamily: 'Sans', fontWeight: FontWeight.w800, fontStyle: FontStyle.italic),
                                                            ),
                                                            SizedBox(width: 5), // Beri sedikit jarak antara jam dan AM/PM
                                                          ],
                                                        ),
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
                                            ],
                                          ),
                                        ),
                                      ),
                                    ),
                                  ),
                                ),
                              ],
                            ),
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
                                onPressed: () => Get.to(() => HomePage()),
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
                        ListView.builder(
                          shrinkWrap: true,
                          physics: NeverScrollableScrollPhysics(),
                          itemCount: 2,
                          itemBuilder: (context, index) {
                            String loc = "(-7.3320625, 110.5009375)";
                            String time = "0${index + 7}:39 AM";

                            return BlogTile(
                              time: time,
                              loc: loc,
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

class BlogTile extends StatelessWidget {
  final String time;
  final String loc;

  const BlogTile({
    Key? key,
    required this.time,
    required this.loc,
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
                    "19 Januari 2024",
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