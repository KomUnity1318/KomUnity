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
              drugaIkonica: Icon(
                LucideIcons.slidersHorizontal,
                size: 30,
              ),
              drugaIkonicaFunkcija: () {},
              isCenter: false,
            ),
            Container(
              child: Row(
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
            ),
            SizedBox(height: (medijakveri.size.height - medijakveri.padding.top) * 0.02),
            Container(
              height: (medijakveri.size.height - medijakveri.padding.top - medijakveri.viewInsets.bottom) * 0.76,
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

                        final objaveP = snapshot.data!.docs;
                        if (objaveP.isEmpty) {
                          return Center(
                            child: Text(
                              'Trenutno nema objava',
                              style: Theme.of(context).textTheme.headlineMedium,
                            ),
                          );
                        }
                        objaveP.sort((a, b) {
                          if (DateTime.parse(a.data()['createdAt']).isAfter(DateTime.parse(b.data()['createdAt']))) {
                            return 0;
                          } else {
                            return 1;
                          }
                        });
                        List<QueryDocumentSnapshot<Map<String, dynamic>>> objave = [];
                        if (danasFilter) {
                          objaveP.forEach((value) {
                            if (Metode.timeAgo(value.data()['createdAt']).contains('min') || Metode.timeAgo(value.data()['createdAt']).contains('h')) {
                              objave.add(value);
                            }
                          });
                        } else {
                          objaveP.forEach((value) {
                            if (DateTime.parse(value.data()['createdAt']).isAfter(DateTime.now().subtract(Duration(days: 15)))) {
                              objave.add(value);
                            }
                          });
                          // objave = objaveP;
                        }
                        if (objave.isEmpty) {
                          return Center(
                            child: Text(
                              'Trenutno nema objava',
                              style: Theme.of(context).textTheme.headlineMedium,
                            ),
                          );
                        }

                        try {
                          return ListView.builder(
                            itemCount: objave.length,
                            padding: const EdgeInsets.symmetric(vertical: 0),
                            itemBuilder: (context, index) {
                              final user = users!.docs.where((value) => value.id == objave[index].data()['ownerId']).toList();
                              return ObjavaCard(
                                naslov: objave[index].data()['naslov'],
                                opis: objave[index].data()['opis'],
                                ownerName: user[0].data()['userName'],
                                ownerId: objave[index].data()['ownerId'],
                                medijakveri: medijakveri,
                                createdAt: objave[index].data()['createdAt'],
                                kategorija: objave[index].data()['kategorija'],
                                dobrovoljci: objave[index].data()['dobrovoljci'],
                                location: user[0].data()['location'],
                                brojTel: user[0].data()['broj'],
                                objavaId: objave[index].id,
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
    );
  }
}
