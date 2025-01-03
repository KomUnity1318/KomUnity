import 'dart:ui';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:komunity/components/CustomAppbar.dart';
import 'package:komunity/components/ObjavaCard.dart';
import 'package:komunity/components/metode.dart';
import 'package:lucide_icons_flutter/lucide_icons.dart';

class AccountViewUserScreen extends StatefulWidget {
  static const String routeName = '/AccountViewUserScreen';
  final String nalogId;

  const AccountViewUserScreen({
    super.key,
    required this.nalogId,
  });

  @override
  State<AccountViewUserScreen> createState() => _AccountViewUserScreenState();
}

class _AccountViewUserScreenState extends State<AccountViewUserScreen> {
  DocumentSnapshot<Map<String, dynamic>>? user;

  bool isLoading = false;

  @override
  Widget build(BuildContext context) {
    final medijakveri = MediaQuery.of(context);
    return Scaffold(
      body: SingleChildScrollView(
        primary: false,
        child: Container(
          margin: EdgeInsets.symmetric(horizontal: medijakveri.size.width * 0.039),
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
                FutureBuilder(
                  future: FirebaseFirestore.instance.collection('users').doc(widget.nalogId).get(),
                  builder: (context, snapshot) {
                    if (snapshot.connectionState == ConnectionState.waiting) {
                      return Container(
                        child: Center(
                          child: CircularProgressIndicator(),
                        ),
                      );
                    }
                    // if(snapshot.data!.data()!['ratings'] != ){

                    // }
                    int reputacija = 0;
                    int brojac = 0;
                    if (snapshot.data!.data()!['ratings'].isNotEmpty) {
                      int ratings = int.parse(snapshot.data!.data()!['ratings'].values.toString().replaceAll(RegExp(r'[^0-9]'), ''));

                      // ratings = ratings / 10;
                      // print(ratings % 10);
                      while (ratings > 0) {
                        reputacija += ratings % 10;
                        ratings = (ratings / 10).floor();
                        brojac++;
                      }
                    }

                    return Column(
                      children: [
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
                                    snapshot.data!.data()!['userName'],
                                    style: Theme.of(context).textTheme.headlineLarge,
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                        SizedBox(height: 15),
                        Column(
                          children: [
                            Row(
                              children: [
                                Text(
                                  'Reputacija: ',
                                  style: Theme.of(context).textTheme.headlineMedium,
                                ),
                                Text(
                                  (reputacija / brojac).toStringAsFixed(1),
                                  style: Theme.of(context).textTheme.headlineMedium!.copyWith(
                                        color: Theme.of(context).colorScheme.tertiary,
                                      ),
                                ),
                              ],
                            ),
                            SizedBox(height: 5),
                            Container(
                              padding: EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                              decoration: BoxDecoration(
                                color: Colors.white,
                                borderRadius: BorderRadius.circular(10),
                                border: Border.all(
                                  color: Theme.of(context).colorScheme.secondary,
                                ),
                              ),
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                children: [
                                  SvgPicture.asset(
                                    reputacija / brojac > 1 ? 'assets/icons/StarFilled.svg' : 'assets/icons/Star.svg',
                                    height: 39,
                                  ),
                                  SizedBox(width: 10),
                                  SvgPicture.asset(
                                    reputacija / brojac > 2 ? 'assets/icons/StarFilled.svg' : 'assets/icons/Star.svg',
                                    height: 39,
                                  ),
                                  SizedBox(width: 10),
                                  SvgPicture.asset(
                                    reputacija / brojac > 3 ? 'assets/icons/StarFilled.svg' : 'assets/icons/Star.svg',
                                    height: 39,
                                  ),
                                  SizedBox(width: 10),
                                  SvgPicture.asset(
                                    reputacija / brojac > 4 ? 'assets/icons/StarFilled.svg' : 'assets/icons/Star.svg',
                                    height: 39,
                                  ),
                                  SizedBox(width: 10),
                                  SvgPicture.asset(
                                    reputacija / brojac > 5 ? 'assets/icons/StarFilled.svg' : 'assets/icons/Star.svg',
                                    height: 39,
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                        SizedBox(height: 15),
                        Column(
                          children: [
                            Row(
                              children: [
                                Text(
                                  'Znanja i vještine',
                                  style: Theme.of(context).textTheme.headlineMedium,
                                ),
                              ],
                            ),
                            SizedBox(height: 10),
                            Container(
                              padding: EdgeInsets.all(10),
                              decoration: BoxDecoration(
                                color: Colors.white,
                                borderRadius: BorderRadius.circular(10),
                                border: Border.all(
                                  color: Theme.of(context).colorScheme.secondary,
                                ),
                              ),
                              child: Column(
                                children: [
                                  Row(
                                    children: [
                                      Container(
                                        height: 10,
                                        width: 10,
                                        decoration: BoxDecoration(
                                          shape: BoxShape.circle,
                                          border: Border.all(
                                            color: Theme.of(context).colorScheme.primary,
                                          ),
                                        ),
                                      ),
                                      SizedBox(width: 5),
                                      Text(
                                        'Cijepanje drva',
                                        style: Theme.of(context).textTheme.labelLarge,
                                      ),
                                    ],
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                        SizedBox(height: 15),
                        Column(
                          children: [
                            Row(
                              children: [
                                Text(
                                  'Objave',
                                  style: Theme.of(context).textTheme.headlineLarge,
                                ),
                              ],
                            ),
                            SizedBox(height: 10),
                            Container(
                              height: (medijakveri.size.height - medijakveri.padding.top) * 0.416,
                              child: StreamBuilder(
                                stream: FirebaseFirestore.instance.collection('posts').snapshots(),
                                builder: (context, snapshot) {
                                  if (snapshot.connectionState == ConnectionState.waiting) {
                                    return const Center(
                                      child: CircularProgressIndicator(),
                                    );
                                  }

                                  final sveObjave = snapshot.data!.docs;
                                  final mojeObjave = sveObjave.where((element) => element.data()['ownerId'] == widget.nalogId).toList();

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
                      ],
                    );
                  },
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
