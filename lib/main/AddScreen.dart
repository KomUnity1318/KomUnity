import 'dart:ui';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:komunity/components/CustomAppbar.dart';
import 'package:komunity/components/InputField.dart';
import 'package:komunity/components/metode.dart';
import 'package:lucide_icons_flutter/lucide_icons.dart';

class AddScreen extends StatefulWidget {
  static const String routeName = '/AddScreen';

  const AddScreen({super.key});

  @override
  State<AddScreen> createState() => _AddScreenState();
}

class _AddScreenState extends State<AddScreen> {
  final form = GlobalKey<FormState>();
  Map<String, String> objavaData = {
    'naslov': '',
    'opis': '',
    'kategorija': 'Pomoć',
  };
  bool isLoading = false;

  void addObjavu() async {
    if (!form.currentState!.validate()) {
      return;
    }
    form.currentState!.save();
    try {
      setState(() {
        isLoading = true;
      });

      try {
        Metode.checkConnection(context: context);
      } catch (e) {
        setState(() {
          isLoading = false;
        });
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
        return;
      }
      DocumentSnapshot<Map<String, dynamic>>? userInfo;
      try {
        userInfo = await FirebaseFirestore.instance.collection('users').doc(FirebaseAuth.instance.currentUser!.uid).get();
      } catch (e) {
        setState(() {
          isLoading = false;
        });
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
        return;
      }

      await FirebaseFirestore.instance.collection('posts').add({
        'ownerId': FirebaseAuth.instance.currentUser!.uid,
        'dobrovoljci': {},
        'naslov': objavaData['naslov'],
        'opis': objavaData['opis'],
        'kategorija': objavaData['kategorija'],
        'createdAt': DateTime.now().toIso8601String(),
      }).then((value) {
        setState(() {
          isLoading = false;
          objavaData['naslov'] = '';
          objavaData['opis'] = '';
          objavaData['kategorija'] = '';
          form.currentState!.reset();
        });
        ScaffoldMessenger.of(context).hideCurrentSnackBar();
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(
              'Uspješno ste dodali objavu!',
              style: Theme.of(context).textTheme.labelLarge!.copyWith(
                    color: Colors.white,
                  ),
            ),
            duration: const Duration(milliseconds: 1500),
            behavior: SnackBarBehavior.floating,
            backgroundColor: Theme.of(context).colorScheme.tertiary,
            elevation: 4,
          ),
        );
      });
    } catch (e) {
      setState(() {
        isLoading = false;
      });
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
      resizeToAvoidBottomInset: false,
      body: SingleChildScrollView(
        child: GestureDetector(
          onTap: () {
            FocusManager.instance.primaryFocus!.unfocus();
          },
          child: SafeArea(
            child: Column(
              children: [
                CustomAppBar(
                  pageTitle: Row(
                    children: [
                      Text(
                        'Dodajte objavu',
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
                  drugaIkonica: isLoading
                      ? Container(
                          height: 30,
                          width: 30,
                          child: CircularProgressIndicator(),
                        )
                      : Icon(
                          LucideIcons.squareCheck,
                          size: 30,
                        ),
                  drugaIkonicaFunkcija: isLoading
                      ? () {}
                      : () {
                          FocusManager.instance.primaryFocus!.unfocus();
                          addObjavu();
                        },
                  isCenter: false,
                ),
                Form(
                  key: form,
                  child: Column(
                    children: [
                      SizedBox(height: 20),
                      InputField(
                        medijakveri: medijakveri,
                        hintText: 'Naslov',
                        inputAction: TextInputAction.next,
                        inputType: TextInputType.text,
                        obscureText: false,
                        isLabel: true,
                        label: 'Naslov',
                        visina: 18,
                        kapitulacija: TextCapitalization.sentences,
                        borderRadijus: 10,
                        validator: (value) {
                          if (value == '' || value == null) {
                            return 'Molimo Vas unesite naslov';
                          } else if (value.length < 4) {
                            return 'Naslov mora biti duži';
                          } else if (value.length > 50) {
                            return 'Naslov mora biti kraći';
                          }
                        },
                        onSaved: (value) {
                          objavaData['naslov'] = value!.trim();
                        },
                        isMargin: false,
                      ),
                      SizedBox(height: 20),
                      InputField(
                        medijakveri: medijakveri,
                        hintText: 'Opis',
                        inputAction: TextInputAction.next,
                        inputType: TextInputType.text,
                        obscureText: false,
                        isLabel: true,
                        label: 'Opis',
                        visina: 18,
                        brMinLinija: 1,
                        brMaxLinija: 5,
                        kapitulacija: TextCapitalization.sentences,
                        borderRadijus: 10,
                        validator: (value) {
                          if (value == '' || value == null) {
                            return 'Molimo Vas unesite opis';
                          } else if (value.length < 4) {
                            return 'Opis mora biti duži';
                          } else if (value.length > 300) {
                            return 'Opis mora biti kraći';
                          }
                        },
                        onSaved: (value) {
                          objavaData['opis'] = value!.trim();
                        },
                        isMargin: false,
                      ),
                      SizedBox(height: 20),
                      Column(
                        children: [
                          Row(
                            children: [
                              Container(
                                margin: EdgeInsets.only(
                                  bottom: 8,
                                  left: medijakveri.size.width * 0.02,
                                ),
                                child: Text(
                                  'Kategorija',
                                  style: Theme.of(context).textTheme.headlineMedium!,
                                ),
                              ),
                            ],
                          ),
                          Container(
                            width: medijakveri.size.width,
                            padding: EdgeInsets.symmetric(horizontal: 15, vertical: 5),
                            decoration: BoxDecoration(
                              color: Colors.white,
                              borderRadius: BorderRadius.circular(10),
                              border: Border.all(
                                color: Color(0xFF91BFDD),
                              ),
                            ),
                            child: DropdownButton(
                              value: objavaData['kategorija'] == '' ? 'Pomoć' : objavaData['kategorija'],
                              isExpanded: true,
                              menuWidth: medijakveri.size.width - (medijakveri.size.width * 0.05),
                              underline: Container(),
                              style: Theme.of(context).textTheme.labelLarge,
                              items: [
                                DropdownMenuItem(
                                  value: 'Pomoć',
                                  child: Text('Pomoć'),
                                ),
                                DropdownMenuItem(
                                  value: 'Poklanjam',
                                  child: Text('Poklanjam'),
                                ),
                                DropdownMenuItem(
                                  value: 'Pomoć - Fizički rad',
                                  child: Text('Pomoć - Fizički rad'),
                                ),
                                DropdownMenuItem(
                                  value: 'Prevoz',
                                  child: Text('Prevoz'),
                                ),
                              ],
                              onChanged: (value) {
                                setState(() {
                                  objavaData['kategorija'] = value!;
                                });
                              },
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                )
              ],
            ),
          ),
        ),
      ),
    );
  }
}
