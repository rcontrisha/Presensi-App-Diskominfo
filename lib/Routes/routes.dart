import 'package:get/get.dart';
import 'package:maps/Modules/Login Page/View/login_view.dart'; // Import your login widget file here
import 'package:maps/Modules/Presence History/View/presence_view.dart'; // Import your presence widget file here
import 'package:maps/Modules/Home Page/View/home_view.dart';
import '../Modules/Landing Page/landingpage.dart';

class AppRoutes {
  static const String login = '/login';
  static const String home = '/home';
  static const String presencePage = '/presencePage';
  static const String landing = '/landingPage';

  static final List<GetPage> routes = [
    GetPage(name: login, page: () => LoginScreen()),
    GetPage(name: home, page: () => HomePage()),
    GetPage(name: presencePage, page: () => PresencePage()),
    GetPage(name: landing, page: () => LandingPage()),
  ];
}
