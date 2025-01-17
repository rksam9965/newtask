import 'package:firebase_core/firebase_core.dart';
import 'package:fires/screens/signin/signin_page.dart';
import 'package:fires/screens/splash_screen/motion_splashscreen.dart';
import 'firebase_options.dart'; // Import generated file
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'mainscreens/product_list_screen.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // Initialize Firebase with options for web support
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );

  Widget _defaultHome = SplashScreen();
  SharedPreferences prefs = await SharedPreferences.getInstance();
  bool? isValidUser = prefs.getBool('valid_user');

  if (isValidUser == true) {
    _defaultHome = ProductScreen();
  }

  await SystemChrome.setPreferredOrientations([DeviceOrientation.portraitUp]).then((_) {
    runApp(MyApp(defaultHome: _defaultHome));
  });
}

class MyApp extends StatelessWidget {
  final Widget defaultHome;

  MyApp({required this.defaultHome});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Firebase Auth with User Data',
      home: defaultHome,
      routes: {
        '/signin': (BuildContext context) => SignInPage(),
        '/home': (BuildContext context) => ProductScreen()
      },
    );
  }
}
