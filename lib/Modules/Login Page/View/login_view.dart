import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../Controller/login_controller.dart';

class LoginScreen extends StatelessWidget {
  final UserController userController = Get.put(UserController());

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBodyBehindAppBar: true,
      backgroundColor: const Color(0xFF04A3EA),
      body: LayoutBuilder(
        builder: (BuildContext context, BoxConstraints constraints) {
          return SingleChildScrollView(
            child: ConstrainedBox(
              constraints: BoxConstraints(
                minHeight: constraints.maxHeight,
              ),
              child: IntrinsicHeight(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Container(
                      height: MediaQuery.of(context).size.height * 42 / 100,
                      width: MediaQuery.of(context).size.width,
                      padding: const EdgeInsets.only(left: 30),
                      decoration: const BoxDecoration(
                        image: DecorationImage(
                          image: AssetImage('assets/images/login.png'),
                          fit: BoxFit.cover,
                        ),
                      ),
                      child: const Padding(
                        padding: EdgeInsets.only(left: 3.0),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            SizedBox(height: 95),
                            Text(
                              "APSI-SALATIGA",
                              style: TextStyle(
                                fontSize: 32,
                                color: Color(0xFFFEFEFE),
                                fontFamily: 'Kanit',
                                height: 150 / 100,
                                fontWeight: FontWeight.w700,
                              ),
                            ),
                            SizedBox(height: 10),
                            Text(
                              "Aplikasi Presensi Pemerintahan\nKota Salatiga",
                              style: TextStyle(
                                  fontSize: 18,
                                  color: Colors.white,
                                  fontFamily: 'Kanit',
                                  fontWeight: FontWeight.w300),
                            ),
                          ],
                        ),
                      ),
                    ),
                    Expanded(
                      child: Container(
                        color: const Color(0xFFFEFEFE),
                        padding: EdgeInsets.symmetric(
                          horizontal: MediaQuery.of(context).size.width * 0.05,
                          vertical: MediaQuery.of(context).size.height * 0.04,
                        ),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.start,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Container(
                              margin: const EdgeInsets.only(bottom: 23),
                              child: const Padding(
                                padding: EdgeInsets.only(left: 17.0),
                                child: Text(
                                  'Selamat Datang!',
                                  style: TextStyle(
                                    color: Color(0xFF14678B),
                                    fontSize: 22,
                                    fontFamily: 'Kanit',
                                    fontWeight: FontWeight.w600,
                                  ),
                                ),
                              ),
                            ),
                            Padding(
                              padding: EdgeInsets.symmetric(horizontal: 20.0),
                              child: TextFormField(
                                validator: (value) {
                                  if (value!.isEmpty) {
                                    return 'Field tidak boleh kosong';
                                  }
                                  return null;
                                },
                                style: const TextStyle(
                                  color: Color(0xFF14678B),
                                  fontSize: 17,
                                  fontWeight: FontWeight.w500,
                                  fontFamily: 'Kanit',
                                ),
                                maxLines: 1,
                                controller: userController.emailController,
                                decoration: InputDecoration(
                                  labelText: "NIP / Email",
                                  labelStyle: TextStyle(
                                    color: Color(0xFFB3B1B0),
                                    fontSize: 17,
                                    fontFamily: 'Kanit',
                                    fontWeight: FontWeight.w500,
                                  ),
                                  focusedBorder: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(16),
                                    borderSide: const BorderSide(
                                      color: Color(0xFFB3B1B0),
                                      width: 1.5,
                                    ),
                                  ),
                                  enabledBorder: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(16),
                                    borderSide: const BorderSide(
                                      width: 1.5,
                                      color: Color(0xFFB3B1B0),
                                    ),
                                  ),
                                ),
                              ),
                            ),
                            const SizedBox(height: 20), // Spasi tambahan
                            Padding(
                              padding: EdgeInsets.symmetric(horizontal: 20.0),
                              child: TextFormField(
                                validator: (value) {
                                  if (value!.isEmpty) {
                                    return 'Field tidak boleh kosong';
                                  }
                                  return null;
                                },
                                style: const TextStyle(
                                  color: Color(0xFF14678B),
                                  fontSize: 17,
                                  fontWeight: FontWeight.w500,
                                  fontFamily: 'Kanit',
                                ),
                                maxLines: 1,
                                controller: userController.passwordController,
                                obscureText: true,
                                decoration: InputDecoration(
                                  labelText: "Password",
                                  labelStyle: TextStyle(
                                    color: Color(0xFFB3B1B0),
                                    fontSize: 17,
                                    fontFamily: 'Kanit',
                                    fontWeight: FontWeight.w500,
                                  ),
                                  focusedBorder: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(16),
                                    borderSide: const BorderSide(
                                      color: Color(0xFFB3B1B0),
                                      width: 1.5,
                                    ),
                                  ),
                                  enabledBorder: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(16),
                                    borderSide: const BorderSide(
                                      width: 1.5,
                                      color: Color(0xFFB3B1B0),
                                    ),
                                  ),
                                ),
                              ),
                            ),
                            SizedBox(height: 15),
                            Padding(
                              padding: const EdgeInsets.only(left: 5.0), // Padding untuk checkbox
                              child: Row(
                                children: [
                                  Obx(
                                        () => Checkbox(
                                      value: userController.rememberMe.value,
                                      onChanged: (value) {
                                        userController.rememberMe.value = !userController.rememberMe.value;
                                      },
                                    ),
                                  ),
                                  Text(
                                    'Remember Me',
                                    style: TextStyle(
                                      color: Color(0xFFB3B1B0),
                                      fontSize: 15,
                                      fontFamily: 'Kanit',
                                      fontWeight: FontWeight.w600,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            const SizedBox(height: 20),
                            Center(
                              child: ElevatedButton(
                                onPressed: userController.loginUser,
                                style: ElevatedButton.styleFrom(
                                  primary: Color(0xFFF7EF17),
                                  minimumSize: Size(
                                    MediaQuery.of(context).size.width * 0.5,
                                    50,
                                  ),
                                  elevation: 3,
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(25),
                                  ),
                                ),
                                child: Text(
                                  'Log In',
                                  style: TextStyle(
                                    fontSize: 18,
                                    fontFamily: 'Kanit',
                                    fontWeight: FontWeight.w600,
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}


/*Text(
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
                          ),*/