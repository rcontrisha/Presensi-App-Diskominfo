import 'package:apsi/Modules/Presence%20Detail/View/pdetail_view.dart';
import 'package:apsi/Modules/Presence%20List/View/plist_view.dart';
import 'package:get/get.dart';
import 'package:apsi/Modules/Login Page/View/login_view.dart'; // Import your login widget file here
import 'package:apsi/Modules/Presence History/View/presence_view.dart'; // Import your presence widget file here
import 'package:apsi/Modules/Home Page/View/home_view.dart';
import '../Modules/Landing Page/landingpage.dart';
import '../Modules/Splash Screen/splash_screen.dart';

class AppRoutes {
  static const String splash = '/splash';
  static const String login = '/login';
  static const String home = '/home';
  static const String presencePage = '/presencePage';
  static const String landing = '/landingPage';
  static const String history = '/history';
  static const String presenceDetail = '/presenceDetail';

  static final List<GetPage> routes = [
    GetPage(name: splash, page: () => SplashScreen()),
    GetPage(name: login, page: () => LoginScreen()),
    GetPage(name: home, page: () => HomePage()),
    GetPage(name: presencePage, page: () => PresencePage()),
    GetPage(name: landing, page: () => LandingPage()),
    GetPage(name: history, page: () => PListView()),
    GetPage(name: presenceDetail, page: () => PresenceDetailView()),
  ];
}
