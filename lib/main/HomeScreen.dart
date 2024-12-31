import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:komunity/components/Button.dart';
import 'package:komunity/components/CustomAppbar.dart';
import 'package:komunity/components/metode.dart';
import 'package:lucide_icons_flutter/lucide_icons.dart';

class HomeScreen extends StatefulWidget {
  static const String routeName = '/HomeScreen';

  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
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
            GestureDetector(
              onTap: () {},
              child: Container(
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(10),
                  border: Border.all(
                    color: Theme.of(context).colorScheme.tertiary,
                  ),
                ),
                height: 40,
                width: 200,
              ),
            ),
            SizedBox(height: (medijakveri.size.height - medijakveri.padding.top) * 0.025),
            Container(
              child: StreamBuilder(
                stream: FirebaseFirestore.instance.collection('posts').snapshots(),
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return Container(
                      height: (medijakveri.size.height - medijakveri.padding.top) * 0.753,
                      child: const Center(
                        child: CircularProgressIndicator(),
                      ),
                    );
                  }

                  final objave = snapshot.data!.docs;
                  if (objave.isEmpty) {
                    return Container(
                      height: (medijakveri.size.height - medijakveri.padding.top) * 0.753,
                      child: Center(
                        child: Text(
                          'Trenutno nema objava',
                          style: Theme.of(context).textTheme.headlineMedium,
                        ),
                      ),
                    );
                  }
                  objave.sort((a, b) {
                    if (DateTime.parse(a.data()['createdAt']).isAfter(DateTime.parse(b.data()['createdAt']))) {
                      return 0;
                    } else {
                      return 1;
                    }
                  });

                  try {
                    return Container(
                      height: (medijakveri.size.height - medijakveri.padding.top) * 0.753,
                      child: ListView.builder(
                        itemCount: objave.length,
                        padding: const EdgeInsets.symmetric(vertical: 0),
                        itemBuilder: (context, index) {
                          return Container(
                            margin: EdgeInsets.only(bottom: 5),
                            decoration: BoxDecoration(
                              boxShadow: [
                                BoxShadow(
                                  color: Colors.black.withOpacity(0.8),
                                  offset: Offset(1, 2),
                                  blurRadius: 4,
                                  spreadRadius: -3,
                                  blurStyle: BlurStyle.normal,
                                ),
                              ],
                              color: Colors.white,
                              borderRadius: BorderRadius.circular(10),
                            ),
                            padding: EdgeInsets.all(12),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Row(
                                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                  children: [
                                    Row(
                                      children: [
                                        Container(
                                          decoration: BoxDecoration(
                                            color: Colors.grey.shade400,
                                            borderRadius: BorderRadius.circular(5),
                                          ),
                                          child: Icon(
                                            LucideIcons.squareUser,
                                            size: 30,
                                          ),
                                        ),
                                        SizedBox(width: 5),
                                        Container(
                                          constraints: BoxConstraints(
                                            maxWidth: medijakveri.size.width * 0.4,
                                          ),
                                          child: FittedBox(
                                            child: Text(
                                              '${objave[index].data()['ownerName']}',
                                              // 'Anes Čoković',
                                              style: Theme.of(context).textTheme.titleLarge,
                                            ),
                                          ),
                                        ),
                                        SizedBox(width: 3),
                                        Text(
                                          Metode.timeAgo(objave[index].data()['createdAt']),
                                          style: Theme.of(context).textTheme.titleLarge!.copyWith(
                                                color: Theme.of(context).colorScheme.tertiary,
                                              ),
                                        ),
                                        SizedBox(width: 5),
                                        Container(
                                          padding: EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                                          decoration: BoxDecoration(
                                            color: Theme.of(context).colorScheme.tertiary,
                                            borderRadius: BorderRadius.circular(4),
                                          ),
                                          child: Text(
                                            '#${objave[index].data()['kategorija']}',
                                            style: Theme.of(context).textTheme.titleLarge!.copyWith(
                                                  color: Colors.white,
                                                ),
                                          ),
                                        ),
                                      ],
                                    ),
                                    GestureDetector(
                                      onTap: () {},
                                      child: Icon(
                                        LucideIcons.ellipsisVertical,
                                        size: 20,
                                      ),
                                    ),
                                  ],
                                ),
                                SizedBox(height: 5),
                                Text(
                                  objave[index].data()['naslov'].toString().length > 30 ? '${objave[index].data()['naslov'].toString().substring(0, 30)}...' : '${objave[index].data()['naslov']}',
                                  style: Theme.of(context).textTheme.headlineMedium!.copyWith(
                                        fontWeight: FontWeight.w600,
                                      ),
                                ),
                                SizedBox(height: 5),
                                Text(
                                  objave[index].data()['opis'].toString().length > 80 ? '${objave[index].data()['opis'].toString().substring(0, 80)}...' : '${objave[index].data()['opis']}',
                                  style: Theme.of(context).textTheme.labelLarge!.copyWith(
                                        color: Colors.grey,
                                      ),
                                ),
                                Button(
                                  buttonText: 'Pomogni',
                                  borderRadius: 8,
                                  visina: 2,
                                  sirina: 130,
                                  iconTextRazmak: 5,
                                  icon: Icon(LucideIcons.heartHandshake),
                                  backgroundColor: Theme.of(context).colorScheme.secondary,
                                  textColor: Colors.black,
                                  fontsize: 16,
                                  isBorder: true,
                                  funkcija: () {},
                                ),
                              ],
                            ),
                          );
                        },
                      ),
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
                  return Container(
                    height: (medijakveri.size.height - medijakveri.padding.top) * 0.753,
                    child: Center(
                      child: Text(
                        'Došlo je do greške',
                        style: Theme.of(context).textTheme.headlineMedium,
                      ),
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
