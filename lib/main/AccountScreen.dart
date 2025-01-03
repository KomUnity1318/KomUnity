import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:komunity/account/AccountEditScreen.dart';
import 'package:komunity/account/SettingsScreen.dart';
import 'package:komunity/components/CustomAppbar.dart';
import 'package:komunity/components/ObjavaCard.dart';
import 'package:komunity/components/metode.dart';
import 'package:lucide_icons_flutter/lucide_icons.dart';

class AccountScreen extends StatefulWidget {
  static const String routeName = '/AccountScreen';

  const AccountScreen({super.key});

  @override
  State<AccountScreen> createState() => _AccountScreenState();
}

class _AccountScreenState extends State<AccountScreen> {
  @override
  Widget build(BuildContext context) {
    final medijakveri = MediaQuery.of(context);
    return Scaffold(
      body: SingleChildScrollView(
        primary: false,
        child: SafeArea(
          child: Column(
            children: [
              CustomAppBar(
                pageTitle: Row(
                  children: [
                    Text(
                      'Nalog',
                      style: Theme.of(context).textTheme.headlineLarge,
                    ),
                  ],
                ),
                prvaIkonica: Container(
                  height: 27,
                  width: 27,
                  child: SvgPicture.asset(
                    "assets/icons/LogoZnak.svg",
                  ),
                ),
                drugaIkonica: Icon(
                  LucideIcons.settings,
                  size: 30,
                ),
                drugaIkonicaFunkcija: () {
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
                      pageBuilder: (context, animation, duration) => SettingsScreen(),
                    ),
                  );
                },
                isCenter: false,
              ),
              Container(
                width: medijakveri.size.width,
                padding: EdgeInsets.all(10),
                decoration: BoxDecoration(
                  color: Theme.of(context).colorScheme.secondary,
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Column(
                  children: [
                    Container(
                      decoration: BoxDecoration(
                        color: Colors.grey.shade300,
                        borderRadius: BorderRadius.circular(15),
                      ),
                      child: SvgPicture.asset(
                        'assets/icons/ProfilePic.svg',
                        height: (medijakveri.size.height - medijakveri.padding.top) * 0.123,
                        // height: 100,
                      ),
                    ),
                    SizedBox(height: 10),
                    Container(
                      constraints: BoxConstraints(
                        maxWidth: medijakveri.size.width,
                      ),
                      child: FittedBox(
                        child: Text(
                          FirebaseAuth.instance.currentUser!.displayName!,
                          style: Theme.of(context).textTheme.headlineLarge,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              SizedBox(height: 20),
              Row(
                children: [
                  Text(
                    'Moje objave',
                    style: Theme.of(context).textTheme.headlineLarge,
                  ),
                ],
              ),
              SizedBox(height: 10),
              Container(
                height: (medijakveri.size.height - medijakveri.padding.top) * 0.555,
                child: StreamBuilder(
                  stream: FirebaseFirestore.instance.collection('posts').snapshots(),
                  builder: (context, snapshot) {
                    if (snapshot.connectionState == ConnectionState.waiting) {
                      return const Center(
                        child: CircularProgressIndicator(),
                      );
                    }

                    final sveObjave = snapshot.data!.docs;
                    final mojeObjave = sveObjave.where((element) => element.data()['ownerId'] == FirebaseAuth.instance.currentUser!.uid).toList();

                    if (mojeObjave.isEmpty) {
                      return Center(
                        child: Text(
                          'Nema objava',
                          style: Theme.of(context).textTheme.headlineMedium,
                        ),
                      );
                    }
                    mojeObjave.sort((a, b) {
                      if (DateTime.parse(a.data()['createdAt']).isAfter(DateTime.parse(b.data()['createdAt']))) {
                        return 0;
                      } else {
                        return 1;
                      }
                    });
                    return ListView.builder(
                      itemCount: mojeObjave.length,
                      itemBuilder: (context, index) {
                        return ObjavaCard(
                          naslov: mojeObjave[index].data()['naslov'],
                          opis: mojeObjave[index].data()['opis'],
                          ownerName: mojeObjave[index].data()['ownerName'],
                          ownerId: mojeObjave[index].data()['ownerId'],
                          medijakveri: medijakveri,
                          createdAt: mojeObjave[index].data()['createdAt'],
                          kategorija: mojeObjave[index].data()['kategorija'],
                          dobrovoljci: mojeObjave[index].data()['dobrovoljci'],
                          location: mojeObjave[index].data()['adresa'],
                          brojTel: mojeObjave[index].data()['broj'],
                          objavaId: mojeObjave[index].id,
                          ownerProfileClick: false,
                        );
                      },
                    );
                  },
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
