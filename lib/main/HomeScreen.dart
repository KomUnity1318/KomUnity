import 'dart:math';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:komunity/MojProvider.dart';
import 'package:komunity/components/Button.dart';
import 'package:komunity/components/CustomAppbar.dart';
import 'package:komunity/components/ObjavaCard.dart';
import 'package:komunity/components/metode.dart';
import 'package:lucide_icons_flutter/lucide_icons.dart';
import 'package:provider/provider.dart';

class HomeScreen extends StatefulWidget {
  static const String routeName = '/HomeScreen';

  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  bool danasFilter = false;
  String kategorijaFilter = 'nista';
  QuerySnapshot<Map<String, dynamic>>? users;
  bool isLoading = false;
  @override
  void didChangeDependencies() async {
    // TODO: implement didChangeDependencies
    super.didChangeDependencies();
    try {
      Metode.checkConnection(context: context);
    } catch (e) {
      Metode.showErrorDialog(
        isJednoPoredDrugog: false,
        context: context,
        naslov: 'Nema internet konekcije',
        button1Text: 'Zatvori',
        button1Fun: () {
          Navigator.pop(context);
        },
        isButton2: false,
      );
    }
    try {
      setState(() {
        isLoading = true;
      });
      await FirebaseFirestore.instance.collection('users').get().then((usersValue) {
        users = usersValue;
        setState(() {
          isLoading = false;
        });
      });
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
  }

  @override
  Widget build(BuildContext context) {
    final medijakveri = MediaQuery.of(context);
    return Scaffold(
      body: SafeArea(
        child: SingleChildScrollView(
          primary: false,
          child: Column(
            children: [
              CustomAppBar(
                pageTitle: Row(
                  children: [
                    Text('Kom', style: Theme.of(context).textTheme.headlineLarge),
                    Text(
                      'Unity',
                      style: Theme.of(context).textTheme.headlineLarge!.copyWith(
                            color: Theme.of(context).colorScheme.tertiary,
                          ),
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
                drugaIkonica: SizedBox(
                  child: Icon(
                    LucideIcons.slidersHorizontal,
                    size: 30,
                    color: Colors.transparent,
                  ),
                ),
                drugaIkonicaFunkcija: () {},
                isCenter: false,
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  GestureDetector(
                    onTap: () {
                      setState(() {
                        danasFilter = true;
                      });
                    },
                    child: Container(
                      decoration: BoxDecoration(
                        color: danasFilter ? Theme.of(context).colorScheme.secondary : Colors.white,
                        borderRadius: BorderRadius.only(
                          topLeft: Radius.circular(10),
                          bottomLeft: Radius.circular(10),
                        ),
                        border: Border.all(
                          color: Theme.of(context).colorScheme.tertiary,
                        ),
                      ),
                      // height: (medijakveri.size.height - medijakveri.padding.top) * 0.047,
                      height: 38,
                      width: 107,
                      child: Center(
                        child: Text(
                          'Danas',
                          style: Theme.of(context).textTheme.labelLarge!.copyWith(
                                color: danasFilter ? Colors.white : Colors.black,
                              ),
                        ),
                      ),
                    ),
                  ),
                  GestureDetector(
                    onTap: () {
                      setState(() {
                        danasFilter = false;
                      });
                    },
                    child: Container(
                      decoration: BoxDecoration(
                        color: danasFilter ? Colors.white : Theme.of(context).colorScheme.secondary,
                        borderRadius: BorderRadius.only(
                          topRight: Radius.circular(10),
                          bottomRight: Radius.circular(10),
                        ),
                        border: Border.all(
                          color: Theme.of(context).colorScheme.tertiary,
                        ),
                      ),
                      height: 38,
                      width: 107,
                      child: Center(
                        child: Text(
                          'Ostalo',
                          style: Theme.of(context).textTheme.labelLarge!.copyWith(
                                color: danasFilter ? Colors.black : Colors.white,
                              ),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
              SizedBox(height: (medijakveri.size.height - medijakveri.padding.top) * 0.01),
              SingleChildScrollView(
                scrollDirection: Axis.horizontal,
                child: Row(
                  children: [
                    GestureDetector(
                      onTap: () {
                        if (kategorijaFilter == 'Pomoć') {
                          setState(() {
                            kategorijaFilter = 'nista';
                          });
                        } else {
                          setState(() {
                            kategorijaFilter = 'Pomoć';
                          });
                        }
                      },
                      child: Container(
                        padding: EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                        decoration: BoxDecoration(
                            color: kategorijaFilter == 'Pomoć' ? Theme.of(context).colorScheme.secondary : Theme.of(context).colorScheme.tertiary,
                            borderRadius: BorderRadius.circular(6),
                            border: Border.all(
                              color: kategorijaFilter == 'Pomoć' ? Theme.of(context).colorScheme.primary : Theme.of(context).colorScheme.tertiary,
                            )),
                        child: Text(
                          '#Pomoć',
                          // softWrap: true,
                          textAlign: TextAlign.center,
                          style: Theme.of(context).textTheme.labelLarge!.copyWith(
                                color: kategorijaFilter == 'Pomoć' ? Colors.black : Colors.white,
                              ),
                        ),
                      ),
                    ),
                    SizedBox(width: 10),
                    GestureDetector(
                      onTap: () {
                        if (kategorijaFilter == 'Poklanjam') {
                          setState(() {
                            kategorijaFilter = 'nista';
                          });
                        } else {
                          setState(() {
                            kategorijaFilter = 'Poklanjam';
                          });
                        }
                      },
                      child: Container(
                        padding: EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                        decoration: BoxDecoration(
                            color: kategorijaFilter == 'Poklanjam' ? Theme.of(context).colorScheme.secondary : Theme.of(context).colorScheme.tertiary,
                            borderRadius: BorderRadius.circular(6),
                            border: Border.all(
                              color: kategorijaFilter == 'Poklanjam' ? Theme.of(context).colorScheme.primary : Theme.of(context).colorScheme.tertiary,
                            )),
                        child: Text(
                          '#Poklanjam',
                          // softWrap: true,
                          textAlign: TextAlign.center,
                          style: Theme.of(context).textTheme.labelLarge!.copyWith(
                                color: kategorijaFilter == 'Poklanjam' ? Colors.black : Colors.white,
                              ),
                        ),
                      ),
                    ),
                    SizedBox(width: 10),
                    GestureDetector(
                      onTap: () {
                        if (kategorijaFilter == 'Pomoć - Fizički rad') {
                          setState(() {
                            kategorijaFilter = 'nista';
                          });
                        } else {
                          setState(() {
                            kategorijaFilter = 'Pomoć - Fizički rad';
                          });
                        }
                      },
                      child: Container(
                        padding: EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                        decoration: BoxDecoration(
                            color: kategorijaFilter == 'Pomoć - Fizički rad' ? Theme.of(context).colorScheme.secondary : Theme.of(context).colorScheme.tertiary,
                            borderRadius: BorderRadius.circular(6),
                            border: Border.all(
                              color: kategorijaFilter == 'Pomoć - Fizički rad' ? Theme.of(context).colorScheme.primary : Theme.of(context).colorScheme.tertiary,
                            )),
                        child: Text(
                          '#Pomoć - Fizički rad',
                          // softWrap: true,
                          textAlign: TextAlign.center,
                          style: Theme.of(context).textTheme.labelLarge!.copyWith(
                                color: kategorijaFilter == 'Pomoć - Fizički rad' ? Colors.black : Colors.white,
                              ),
                        ),
                      ),
                    ),
                    SizedBox(width: 10),
                    GestureDetector(
                      onTap: () {
                        if (kategorijaFilter == 'Prevoz') {
                          setState(() {
                            kategorijaFilter = 'nista';
                          });
                        } else {
                          setState(() {
                            kategorijaFilter = 'Prevoz';
                          });
                        }
                      },
                      child: Container(
                        padding: EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                        decoration: BoxDecoration(
                            color: kategorijaFilter == 'Prevoz' ? Theme.of(context).colorScheme.secondary : Theme.of(context).colorScheme.tertiary,
                            borderRadius: BorderRadius.circular(6),
                            border: Border.all(
                              color: kategorijaFilter == 'Prevoz' ? Theme.of(context).colorScheme.primary : Theme.of(context).colorScheme.tertiary,
                            )),
                        child: Text(
                          '#Prevoz',
                          // softWrap: true,
                          textAlign: TextAlign.center,
                          style: Theme.of(context).textTheme.labelLarge!.copyWith(
                                color: kategorijaFilter == 'Prevoz' ? Colors.black : Colors.white,
                              ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              SizedBox(height: (medijakveri.size.height - medijakveri.padding.top) * 0.01),
              Container(
                height: (medijakveri.size.height - medijakveri.padding.top - medijakveri.viewInsets.bottom) * 0.72,
                child: isLoading
                    ? Center(
                        child: CircularProgressIndicator(),
                      )
                    : StreamBuilder(
                        stream: FirebaseFirestore.instance.collection('posts').snapshots(),
                        builder: (context, snapshot) {
                          if (snapshot.connectionState == ConnectionState.waiting) {
                            return const Center(
                              child: CircularProgressIndicator(),
                            );
                          }

                          final sveObjave = snapshot.data!.docs;
                          if (sveObjave.isEmpty) {
                            return Center(
                              child: Text(
                                'Trenutno nema objava',
                                style: Theme.of(context).textTheme.headlineMedium,
                              ),
                            );
                          }
                          sveObjave.sort((a, b) {
                            if (DateTime.parse(a.data()['createdAt']).isAfter(DateTime.parse(b.data()['createdAt']))) {
                              return 0;
                            } else {
                              return 1;
                            }
                          });
                          List<QueryDocumentSnapshot<Map<String, dynamic>>> objave = [];
                          List<QueryDocumentSnapshot<Map<String, dynamic>>> objaveF = [];
                          List<QueryDocumentSnapshot<Map<String, dynamic>>> objaveF2 = [];
                          final currentUser = users!.docs.where((value) => value.id == FirebaseAuth.instance.currentUser!.uid).toList();

                          for (var i = 0; i < sveObjave.length; i++) {
                            final owner = users!.docs.where((value) => value.id == sveObjave[i].data()['ownerId']).toList();

                            final duzina = sqrt(
                              (double.parse(owner[0].data()['location']['lat']).abs() - double.parse(currentUser[0].data()['location']['lat']).abs()).abs() + (double.parse(owner[0].data()['location']['long']).abs() - double.parse(currentUser[0].data()['location']['long']).abs()).abs(),
                            );
                            if (duzina < 0.078) {
                              objave.add(sveObjave[i]);
                            }
                          }
                          if (danasFilter) {
                            objave.forEach((value) {
                              if (Metode.timeAgo(value.data()['createdAt']).contains('min') || Metode.timeAgo(value.data()['createdAt']).contains('h')) {
                                objaveF.add(value);
                              }
                            });
                          } else {
                            objave.forEach((value) {
                              if (DateTime.parse(value.data()['createdAt']).isAfter(DateTime.now().subtract(Duration(days: 15)))) {
                                objaveF.add(value);
                              }
                            });
                          }
                          objaveF.forEach((value) {
                            if (kategorijaFilter == 'nista') {
                              objaveF2 = objaveF;
                              return;
                            }
                            if (value.data()['kategorija'] == kategorijaFilter) {
                              objaveF2.add(value);
                            }
                          });
                          if (objaveF2.isEmpty) {
                            return Center(
                              child: Text(
                                'Trenutno nema objava blizu Vas',
                                style: Theme.of(context).textTheme.headlineMedium,
                              ),
                            );
                          }

                          try {
                            return ListView.builder(
                              itemCount: objaveF2.length,
                              padding: const EdgeInsets.symmetric(vertical: 0),
                              itemBuilder: (context, index) {
                                final user = users!.docs.where((value) => value.id == objaveF2[index].data()['ownerId']).toList();
                                return ObjavaCard(
                                  naslov: objaveF2[index].data()['naslov'],
                                  opis: objaveF2[index].data()['opis'],
                                  ownerName: user[0].data()['userName'],
                                  ownerId: objaveF2[index].data()['ownerId'],
                                  medijakveri: medijakveri,
                                  createdAt: objaveF2[index].data()['createdAt'],
                                  kategorija: objaveF2[index].data()['kategorija'],
                                  dobrovoljci: objaveF2[index].data()['dobrovoljci'],
                                  location: user[0].data()['location'],
                                  brojTel: user[0].data()['broj'],
                                  objavaId: objaveF2[index].id,
                                  ownerProfileClick: true,
                                );
                              },
                            );
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
                          return Center(
                            child: Text(
                              'Došlo je do greške',
                              style: Theme.of(context).textTheme.headlineMedium,
                            ),
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
