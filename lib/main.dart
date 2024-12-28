import 'package:device_preview/device_preview.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:komunity/auth/DobrodosliScreen.dart';
import 'package:komunity/auth/LoginScreen.dart';
import 'package:komunity/auth/RegisterScreen.dart';
import 'package:lucide_icons_flutter/lucide_icons.dart';

void main() => runApp(
      DevicePreview(
        enabled: false,
        builder: (context) => MyApp(),
      ),
    );

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
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
            fontFamily: 'Lato',
            fontSize: 36,
            color: Colors.black,
            fontWeight: FontWeight.bold,
          ),
          headlineLarge: TextStyle(
            fontFamily: 'Lato',
            fontSize: 24,
            color: Colors.black,
          ),
          headlineMedium: TextStyle(
            fontFamily: 'Lato',
            fontSize: 20,
            color: Colors.black,
          ),
          labelLarge: TextStyle(
            fontFamily: 'Lato',
            fontSize: 16,
            color: Colors.black,
          ),
          titleLarge: TextStyle(
            fontFamily: 'Lato',
            fontSize: 12,
            color: Colors.black,
          ),
        ),
      ),
      title: 'KomUnity',
      home: RegisterScreen(),
    );
  }
}

// class MyHomePage extends StatelessWidget {
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       body: SafeArea(
//         child: Center(
//           child: Column(
//             children: [
//               Text(
//                 'KomUnity',
//                 style: Theme.of(context).textTheme.displayLarge,
//               ),
//               Icon(
//                 LucideIcons.heartHandshake,
//               ),
//               //   Image.asset("assets/icons/Logo.png"),
//               //   Container(
//               //     child:
//               //     height: 100,
//               //     width: 100,
//               //   ),
//               Container(
//                 decoration: BoxDecoration(
//                   boxShadow: [],
//                 ),
//                 child: SvgPicture.asset(
//                   "assets/icons/LogoZnakSenka.svg",
//                   height: 100,
//                 ),
//               ),
//             ],
//           ),
//         ),
//       ),
//     );
//   }
// }
