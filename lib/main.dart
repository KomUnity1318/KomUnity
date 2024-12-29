import 'package:device_preview/device_preview.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:komunity/MojProvider.dart';
import 'package:komunity/auth/WelcomeScreen.dart';
import 'package:komunity/auth/LoginScreen.dart';
import 'package:komunity/auth/RegisterScreen.dart';
import 'package:komunity/firebase_options.dart';
import 'package:komunity/main/BottomNavigationBar.dart';
import 'package:lucide_icons_flutter/lucide_icons.dart';
import 'package:provider/provider.dart';

Future main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  runApp(
    DevicePreview(
      enabled: false,
      builder: (context) => MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    SystemChrome.setPreferredOrientations(
      [
        DeviceOrientation.portraitUp,
        DeviceOrientation.portraitDown,
      ],
    );
    return ChangeNotifierProvider(
      create: (ctx) => MojProvider(),
      child: StreamBuilder<User?>(
          stream: FirebaseAuth.instance.authStateChanges(),
          initialData: FirebaseAuth.instance.currentUser,
          builder: (context, snapshot) {
            return MaterialApp(
              debugShowCheckedModeBanner: false,
              theme: ThemeData(
                scaffoldBackgroundColor: Color(0xFFD9F0FF),
                primaryColor: Color(0xFF2C3160),
                colorScheme: ThemeData().colorScheme.copyWith(
                      primary: Color(0xFF2C3160),
                      secondary: Color(0xFF91BFDD),
                      tertiary: Color(0xFF0097FD),
                    ),
                textTheme: TextTheme(
                  displayLarge: TextStyle(
                    fontFamily: 'Inter',
                    fontSize: 36,
                    color: Colors.black,
                    fontWeight: FontWeight.bold,
                  ),
                  headlineLarge: TextStyle(
                    fontFamily: 'Inter',
                    fontSize: 24,
                    color: Colors.black,
                  ),
                  headlineMedium: TextStyle(
                    fontFamily: 'Inter',
                    fontSize: 20,
                    color: Colors.black,
                  ),
                  labelLarge: TextStyle(
                    fontFamily: 'Inter',
                    fontSize: 16,
                    color: Colors.black,
                  ),
                  titleLarge: TextStyle(
                    fontFamily: 'Inter',
                    fontSize: 12,
                    color: Colors.black,
                  ),
                ),
              ),
              title: 'KomUnity',
              home: snapshot.data == null ? const WelcomeScreen() : const BottomNavigationBarScreen(),
            );
          }),
    );
  }
}
