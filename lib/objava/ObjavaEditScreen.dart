import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:komunity/components/CustomAppbar.dart';
import 'package:komunity/components/InputField.dart';
import 'package:komunity/components/metode.dart';
import 'package:lucide_icons_flutter/lucide_icons.dart';

class ObjavaEditScreen extends StatefulWidget {
  static const String routeName = '/ObjavaEditScreen';

  final String naslov;
  final String opis;
  final String kategorija;
  final String objavaId;

  const ObjavaEditScreen({super.key, required this.naslov, required this.opis, required this.kategorija, required this.objavaId});

  @override
  State<ObjavaEditScreen> createState() => _ObjavaEditScreenState();
}

class _ObjavaEditScreenState extends State<ObjavaEditScreen> {
  final form = GlobalKey<FormState>();
  Map<String, String> objavaData = {
    'naslov': '',
    'opis': '',
    'kategorija': 'Pomoć',
  };
  bool isLoading = false;
  @override
  void initState() {
    super.initState();
    objavaData['naslov'] = widget.naslov;
    objavaData['opis'] = widget.opis;
    objavaData['kategorija'] = widget.kategorija;
  }

  void editObjavu() async {
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

      await FirebaseFirestore.instance.collection('posts').doc(widget.objavaId).update({
        'ownerName': userInfo.data()!['userName'],
        'broj': userInfo.data()!['broj'],
        'adresa': {
          'lat': userInfo.data()!['location']['lat'],
          'long': userInfo.data()!['location']['long'],
        },
        'naslov': objavaData['naslov'],
        'opis': objavaData['opis'],
        'kategorija': objavaData['kategorija'],
        'createdAt': DateTime.now().toIso8601String(),
      }).then((value) {
        Navigator.pop(context);
        ScaffoldMessenger.of(context).hideCurrentSnackBar();
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(
              'Uspješno ste uredili objavu!',
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
    return GestureDetector(
      onTap: () {
        FocusManager.instance.primaryFocus!.unfocus();
      },
      child: Scaffold(
        body: SingleChildScrollView(
          child: Container(
            margin: EdgeInsets.symmetric(horizontal: medijakveri.size.width * 0.039),
            child: SafeArea(
              child: Column(
                children: [
                  CustomAppBar(
                    pageTitle: Text(
                      'Uredite objavu',
                      style: Theme.of(context).textTheme.headlineLarge,
                    ),
                    isCenter: true,
                    prvaIkonica: Icon(
                      LucideIcons.circleArrowLeft,
                      size: 30,
                    ),
                    prvaIkonicaFunkcija: () {
                      Navigator.pop(context);
                    },
                    drugaIkonica: isLoading
                        ? CircularProgressIndicator()
                        : Icon(
                            LucideIcons.squareCheck,
                            size: 30,
                          ),
                    drugaIkonicaFunkcija: () {
                      editObjavu();
                    },
                  ),
                  Form(
                    key: form,
                    child: Column(
                      children: [
                        InputField(
                          medijakveri: medijakveri,
                          hintText: 'Naslov',
                          initalValue: widget.naslov,
                          inputAction: TextInputAction.next,
                          inputType: TextInputType.text,
                          obscureText: false,
                          isLabel: true,
                          label: 'Naslov',
                          visina: 18,
                          brMinLinija: 1,
                          brMaxLinija: 2,
                          kapitulacija: TextCapitalization.sentences,
                          borderRadijus: 10,
                          validator: (value) {
                            if (value == '' || value == null) {
                              return 'Molimo Vas unesite naslov';
                            } else if (value.length < 4) {
                              return 'Naslov mora biti duži';
                            } else if (value.length > 50) {
                              print(value.length);
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
                          initalValue: widget.opis,
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
                                value: objavaData['kategorija'],
                                isExpanded: true,
                                menuWidth: medijakveri.size.width - (medijakveri.size.width * 0.039),
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
      ),
    );
  }
}
