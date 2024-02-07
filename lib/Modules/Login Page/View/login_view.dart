import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../Controller/login_controller.dart';

class LoginScreen extends StatelessWidget {
  final UserController userController = Get.put(UserController());

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBodyBehindAppBar: false,
      backgroundColor: const Color(0xFF04A3EA),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              height: MediaQuery.of(context).size.height * 42 / 100,
              width: MediaQuery.of(context).size.width,
              padding: const EdgeInsets.only(left: 30),
              decoration: const BoxDecoration(
                image: DecorationImage(
                  image: AssetImage('assets/images/pattern_login.png'),
                  fit: BoxFit.cover,
                ),
              ),
              child: const Padding(
                padding: EdgeInsets.only(left: 3.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    SizedBox(height: 90),
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
            Container(
              height: MediaQuery.of(context).size.height * 58 / 100,
              width: MediaQuery.of(context).size.width,
              color: const Color(0xFFFEFEFE),
              padding:
              const EdgeInsets.only(left: 20, right: 20, top: 26, bottom: 84),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Container(
                    margin: const EdgeInsets.only(bottom: 24),
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
                    padding: const EdgeInsets.symmetric(horizontal: 20.0),
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
                          fontFamily: 'Kanit'),
                      maxLines: 1,
                      controller: userController.emailController,
                      decoration: InputDecoration(
                        label: const Padding(
                          padding: EdgeInsets.only(left: 12.0),
                          child: Text(
                            "NIP / Email",
                            style: TextStyle(
                              color: Color(0xFFB3B1B0),
                              fontSize: 17,
                              fontFamily: 'Kanit',
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                        ),
                        focusedBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(16),
                            borderSide: const BorderSide(
                                color: Color(0xFFB3B1B0), width: 1.5)),
                        enabledBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(16),
                          borderSide: const BorderSide(
                              width: 1.5, color: Color(0xFFB3B1B0)
                          ),
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(height: 30),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 20.0),
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
                          fontFamily: 'Kanit'),
                      maxLines: 1,
                      controller: userController.passwordController,
                      obscureText: true,
                      decoration: InputDecoration(
                          label: const Padding(
                            padding: EdgeInsets.only(left: 12.0),
                            child: Text(
                              "Password",
                              style: TextStyle(
                                color: Color(0xFFB3B1B0),
                                fontSize: 17,
                                fontFamily: 'Kanit',
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                          ),
                          focusedBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(16),
                              borderSide: const BorderSide(
                                  color: Color(0xFFB3B1B0), width: 1.5)),
                          enabledBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(16),
                              borderSide: const BorderSide(
                                  width: 1.5, color: Color(0xFFB3B1B0)
                              )
                          )
                      ),
                    ),
                  ),
                  SizedBox(height: 15,),
                  Row(
                    children: [
                      Padding(
                        padding: const EdgeInsets.only(left: 3.0),
                        child: Obx(
                              () => Checkbox(
                            value: userController.rememberMe.value,
                            onChanged: (value) {
                              userController.rememberMe.value =
                              !userController.rememberMe.value;
                            },
                          ),
                        ),
                      ),
                      Text(
                        'Remember Me',
                        style: TextStyle(
                            color: Color(0xFFB3B1B0),
                            fontSize: 15,
                            fontFamily: 'Kanit',
                            fontWeight: FontWeight.w600
                        ),
                      ),
                    ],
                  ),
                  SizedBox(height: 30,),
                  Center(
                    child: ElevatedButton(
                        onPressed: userController.loginUser,
                        style: ElevatedButton.styleFrom(
                          primary: Color(0xFFF7EF17),
                          minimumSize: Size(215, 50),
                          elevation: 6,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(25),
                          ),
                        ),
                        child: Text(
                          'Log In',
                          style: TextStyle(
                              fontSize: 18,
                              fontFamily: 'Kanit',
                              fontWeight: FontWeight.w600
                          ),
                        )
                    ),
                  )
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
