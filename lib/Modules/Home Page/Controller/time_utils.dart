import 'dart:async';
import 'package:intl/intl.dart';
import 'package:timezone/timezone.dart' as tzf;
import 'package:flutter/animation.dart';

class TimeUtils {
  static Stream<String> getWIBTimeStream() async* {
    while (true) {
      final wibTimeZone = tzf.getLocation('Asia/Jakarta');
      final wibDateTime = tzf.TZDateTime.now(wibTimeZone);
      yield DateFormat('HH:mm').format(wibDateTime);
      await Future.delayed(Duration(seconds: 1));
    }
  }

  static Animation<double> getOpacityAnimation(AnimationController controller) {
    return Tween<double>(
      begin: 1.0,
      end: 0.0,
    ).animate(controller);
  }
}

