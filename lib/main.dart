import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/date_symbol_data_local.dart';
import './Routes/routes.dart';
import 'package:shared_preferences/shared_preferences.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await initializeDateFormatting('id', null);

  // Initialize shared preferences
  await Get.putAsync(() => SharedPreferences.getInstance());

  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'APSI',
      initialRoute: AppRoutes.login,
      getPages: AppRoutes.routes,
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
    );
  }
}
