import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:komunity/account/AccountEditScreen.dart';
import 'package:komunity/components/CustomAppbar.dart';
import 'package:komunity/components/metode.dart';
import 'package:lucide_icons_flutter/lucide_icons.dart';

class SettingsScreen extends StatefulWidget {
  static const String routeName = '/SettingsScreen';

  const SettingsScreen({super.key});

  @override
  State<SettingsScreen> createState() => _SettingsScreenState();
}

class _SettingsScreenState extends State<SettingsScreen> {
  bool value = false;
  bool isLoading = false;
  @override
  Widget build(BuildContext context) {
    final medijakveri = MediaQuery.of(context);
    return Scaffold(
      body: SafeArea(
        child: Container(
          margin: EdgeInsets.symmetric(horizontal: medijakveri.size.width * 0.039),
          child: Column(
            children: [
              CustomAppBar(
                pageTitle: Row(
                  children: [
                    Text(
                      'Podešavanja',
                      style: Theme.of(context).textTheme.headlineLarge,
                    ),
                  ],
                ),
                prvaIkonica: Icon(
                  LucideIcons.circleArrowLeft,
                  size: 30,
                ),
                prvaIkonicaFunkcija: () {
                  Navigator.pop(context);
                },
                drugaIkonica: SizedBox(
                  height: 30,
                  width: 30,
                ),
                drugaIkonicaFunkcija: () {},
                isCenter: true,
              ),
              Container(
                padding: EdgeInsets.symmetric(horizontal: 10, vertical: 0),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(5),
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text('Notifikacije', style: Theme.of(context).textTheme.headlineLarge),
                    Switch(
                      value: value,
                      onChanged: (newValue) {
                        setState(() {
                          value = newValue;
                        });
                      },
                      padding: EdgeInsets.zero,
                      activeTrackColor: Colors.grey.shade300,
                      activeColor: Theme.of(context).colorScheme.tertiary,
                      inactiveTrackColor: Colors.grey.shade300,
                    ),
                  ],
                ),
              ),
              SizedBox(height: 10),
              Container(
                padding: EdgeInsets.symmetric(horizontal: 10, vertical: 8),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(5),
                ),
                child: Row(
                  children: [
                    Text(
                      'Promijenite šifru',
                      style: Theme.of(context).textTheme.headlineLarge,
                    ),
                    SizedBox(width: 10),
                    Icon(
                      LucideIcons.lockKeyhole,
                      size: 27,
                    )
                  ],
                ),
              ),
              SizedBox(height: 10),
              GestureDetector(
                onTap: () {
                  Navigator.push(
                    context,
                    PageRouteBuilder(
                      transitionDuration: const Duration(milliseconds: 500),
                      reverseTransitionDuration: const Duration(milliseconds: 500),
                      transitionsBuilder: (context, animation, secondaryAnimation, child) {
                        return SlideTransition(
                          position: Tween<Offset>(
                            begin: const Offset(-1, 0),
                            end: Offset.zero,
                          ).animate(
                            CurvedAnimation(parent: animation, curve: Curves.easeInOutExpo),
                          ),
                          child: child,
                        );
                      },
                      pageBuilder: (context, animation, duration) => AccountEditScreen(),
                    ),
                  );
                },
                child: Container(
                  padding: EdgeInsets.symmetric(horizontal: 10, vertical: 8),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(5),
                  ),
                  child: Row(
                    children: [
                      Text(
                        'Uredite nalog',
                        style: Theme.of(context).textTheme.headlineLarge,
                      ),
                      SizedBox(width: 10),
                      Icon(
                        LucideIcons.userPen,
                        size: 27,
                      )
                    ],
                  ),
                ),
              ),
              SizedBox(height: 10),
              Container(
                padding: EdgeInsets.symmetric(horizontal: 10, vertical: 8),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(5),
                ),
                child: Row(
                  children: [
                    Text(
                      'Obrišite nalog',
                      style: Theme.of(context).textTheme.headlineLarge,
                    ),
                    SizedBox(width: 10),
                    Icon(
                      LucideIcons.userX,
                      size: 27,
                    )
                  ],
                ),
              ),
              SizedBox(height: 10),
              GestureDetector(
                onTap: () async {
                  try {
                    Metode.checkConnection(context: context);
                  } catch (e) {
                    Metode.showErrorDialog(
                      isJednoPoredDrugog: false,
                      context: context,
                      naslov: 'Nema veze',
                      button1Text: 'Zatvori',
                      button1Fun: () {
                        Navigator.pop(context);
                      },
                      isButton2: false,
                    );
                  }
                  try {
                    FirebaseAuth.instance.signOut();
                    Navigator.pushNamedAndRemoveUntil(context, '/', (Route<dynamic> route) => false);
                  } catch (e) {
                    Metode.showErrorDialog(
                      isJednoPoredDrugog: false,
                      context: context,
                      naslov: 'Došlo je do greške',
                      button1Text: 'Zatvori',
                      button1Fun: () {
                        Navigator.pop(context);
                      },
                      isButton2: false,
                    );
                  }
                },
                child: Container(
                  padding: EdgeInsets.symmetric(horizontal: 10, vertical: 8),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(5),
                  ),
                  child: Row(
                    children: [
                      Text(
                        'Odjavite se',
                        style: Theme.of(context).textTheme.headlineLarge,
                      ),
                      SizedBox(width: 10),
                      Icon(
                        LucideIcons.logOut,
                        size: 27,
                      )
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
