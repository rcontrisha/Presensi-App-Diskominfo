import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../Routes/routes.dart';

class SplashScreen extends StatefulWidget {
  @override
  _SplashScreenState createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> with SingleTickerProviderStateMixin {
  double _size = 0.0;
  bool _logoVisible = false;

  @override
  void initState() {
    super.initState();
    _startAnimation();
    _navigateToMainScreen();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Center(
        child: Stack(
          fit: StackFit.expand,
          children: [
            AnimatedOpacity(
              duration: Duration(seconds: 1),
              opacity: _logoVisible ? 1 : 0,
              child: Center(
                child: Image.asset('assets/images/logo.png', width: MediaQuery.of(context).size.width / 2.5, height: MediaQuery.of(context).size.height / 2.5),
              ),
            ),
            AnimatedPositioned(
              duration: Duration(milliseconds: 700),
              left: MediaQuery.of(context).size.width / 2 - _size / 2,
              top: MediaQuery.of(context).size.height / 2 - _size / 2,
              child: AnimatedContainer(
                duration: Duration(milliseconds: 700),
                decoration: BoxDecoration(
                  color: Colors.blue,
                  shape: BoxShape.circle,
                ),
                width: _size,
                height: _size,
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _startAnimation() {
    Future.delayed(Duration(milliseconds: 600), () {
      setState(() {
        _logoVisible = true;
      });
    });

    Future.delayed(Duration(milliseconds: 2300), () {
      setState(() {
        _size = MediaQuery.of(context).size.width * 3;
      });
    });
  }

  void _navigateToMainScreen() {
    Future.delayed(Duration(milliseconds: 3400), () {
      Get.offNamed(AppRoutes.landing);
    });
  }
}
