import 'package:firebase_app_check/firebase_app_check.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:saasaki_assignment/firebase_options.dart';
import 'package:saasaki_assignment/providers/authentication_provider.dart';
import 'package:saasaki_assignment/screens/home_screen.dart';
import 'package:saasaki_assignment/screens/otp_screen.dart';
import 'package:saasaki_assignment/screens/phone_number_screen.dart';
import 'package:saasaki_assignment/screens/splash_screen.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);
  await FirebaseAppCheck.instance.activate();
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (context) => AuthProvider(),
      child: MaterialApp(
        title: 'Assignment',
        routes: {
          // "home_screen": (context) => const HomeScreen(),
          "phone_number_screen": (context) => const PhoneNumberScreen(),
          "otp_screen": (context) => const OtpScreen(),
          "home_screen": (context) => HomeScreen(),
        },
        theme: ThemeData(
            primarySwatch: Colors.purple, canvasColor: Colors.purple.shade50),
        home: SplashScreen(),
      ),
    );
  }
}
