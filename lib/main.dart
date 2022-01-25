import 'package:ars_progress_dialog/ars_progress_dialog.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:rento_admin/screens/admin_users.dart';
import 'package:rento_admin/screens/category_screen.dart';
import 'package:rento_admin/screens/login_screen.dart';
import 'package:rento_admin/screens/home_screen.dart';
import 'package:rento_admin/screens/manage_banners.dart';
import 'package:rento_admin/screens/notifications_screen.dart';
import 'package:rento_admin/screens/orders_screen.dart';
import 'package:rento_admin/screens/service_providers_boys.dart';
import 'package:rento_admin/screens/settings_screen.dart';
import 'package:rento_admin/screens/splash_screen.dart';
import 'package:rento_admin/screens/vendors_screen.dart';

Future main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    // progressDialog.show(); // show dialog
    // progressDialog.dismiss(); //close dialog
    return MaterialApp(
      scrollBehavior: MyCustomScrollBehavior(),
      debugShowCheckedModeBanner: false,
      title: 'Rento App Admin Dashboard',
      theme: ThemeData(
        primaryColor: const Color(0xFF3c5784),
      ),
      home: const SplashScreen(),
      routes: {
        HomeScreen.id: (context) => HomeScreen(),
        SplashScreen.id: (context) => SplashScreen(),
        LoginScreen.id: (context) => LoginScreen(),
        BannerScreen.id: (context) => BannerScreen(),
        CategoryScreen.id: (context) => CategoryScreen(),
        OrdersScreen.id: (context) => OrdersScreen(),
        NotificationsScreen.id: (context) => NotificationsScreen(),
        AdminUsers.id: (context) => AdminUsers(),
        SettingsScreen.id: (context) => SettingsScreen(),
        VendorsScreen.id: (context) => VendorsScreen(),
        ServiceProviderBoys.id: (context) => ServiceProviderBoys(),
      },
      builder: EasyLoading.init(),
    );
  }
}

class MyCustomScrollBehavior extends MaterialScrollBehavior {
  // Override behavior methods and getters like dragDevices
  @override
  Set<PointerDeviceKind> get dragDevices => {
        PointerDeviceKind.touch,
        PointerDeviceKind.mouse,
      };
}
