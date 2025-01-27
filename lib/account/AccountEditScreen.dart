import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:geocoding/geocoding.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:komunity/MojProvider.dart';
import 'package:komunity/auth/LocationScreen.dart';
import 'package:komunity/components/CustomAppbar.dart';
import 'package:komunity/components/InputField.dart';
import 'package:komunity/components/InputFieldDisabled.dart';
import 'package:komunity/components/metode.dart';
import 'package:komunity/main/LocationEditScreen.dart';
import 'package:lucide_icons_flutter/lucide_icons.dart';
import 'package:provider/provider.dart';

class AccountEditScreen extends StatefulWidget {
  static const String routeName = '/AccountEditScreen';

  const AccountEditScreen({super.key});

  @override
  State<AccountEditScreen> createState() => _AccountEditScreenState();
}

class _AccountEditScreenState extends State<AccountEditScreen> {
  final formKey = GlobalKey<FormState>();
  bool isLoading = false;
  bool isDugmeLoading = false;
  List<Placemark> mjesto = [];
  LatLng currentPosition = LatLng(0, 0);
  List<TextEditingController> znanjaInput = [];
  List<FocusNode> znanjaFokus = [];
  List<String> znanja = [];

  DocumentSnapshot<Map<String, dynamic>>? userData;
  void didChangeDependencies() async {
    // TODO: implement didChangeDependencies
    super.didChangeDependencies();
    if (userData != null) {
      return;
    }

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
    }

    try {
      userData = await FirebaseFirestore.instance.collection('users').doc(FirebaseAuth.instance.currentUser!.uid).get();
      if (userData!.data()!['znanjaVjestine'].isNotEmpty) {
        for (var i = 0; i < userData!.data()!['znanjaVjestine'].length; i++) {
          znanjaInput.add(TextEditingController(text: userData!.data()!['znanjaVjestine'][i]));
          znanjaFokus.add(FocusNode());
        }
      } else {
        znanjaInput.add(TextEditingController());
        znanjaFokus.add(FocusNode());
      }

      // print(userData!.data()!['znanjaVjestine']);
      mjesto = await placemarkFromCoordinates(double.parse(userData!.data()!['location']['lat']), double.parse(userData!.data()!['location']['long'])).then((value) async {
        await Provider.of<MojProvider>(context, listen: false).setCurrentPosition().then((value) {
          currentPosition = Provider.of<MojProvider>(context, listen: false).getCurrentPosition;
        });
        setState(() {
          isLoading = false;
        });
        return value;
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

  Map<String, String> _authData = {
    'ime': '',
    'prezime': '',
    'email': '',
    'broj': '',
  };

  void updateUser() async {
    if (!formKey.currentState!.validate()) {
      return;
    }
    formKey.currentState!.save();
    // print(_authData['ime']);
    // print(_authData['prezime']);
    // print(_authData['email']);
    // print(_authData['broj']);
    // print(userData!.id);
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
        isDugmeLoading = true;
      });
      await FirebaseFirestore.instance.collection('users').doc(userData!.id).update({
        'email': _authData['email'],
        'userName': '${_authData['ime']} ${_authData['prezime']}',
        'broj': _authData['broj'],
        'znanjaVjestine': znanja.isEmpty ? [] : znanja,
      }).then((value) async {
        await FirebaseAuth.instance.currentUser!.updateDisplayName('${_authData['ime']} ${_authData['prezime']}');
        await FirebaseAuth.instance.currentUser!.updateEmail(_authData['email']!);
        setState(() {
          isDugmeLoading = false;
        });
        Navigator.pushNamedAndRemoveUntil(context, '/', (Route<dynamic> route) => false);
      });
    } catch (e) {
      setState(() {
        isDugmeLoading = false;
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

  final imeNode = FocusNode();
  final prezimeNode = FocusNode();
  final emailNode = FocusNode();
  final brojNode = FocusNode();
  @override
  Widget build(BuildContext context) {
    final medijakveri = MediaQuery.of(context);
    return GestureDetector(
      onTap: () {
        FocusManager.instance.primaryFocus!.unfocus();
      },
      child: Scaffold(
        appBar: PreferredSize(
          preferredSize: Size(100, 100),
          child: SafeArea(
            child: Container(
              margin: EdgeInsets.symmetric(horizontal: medijakveri.size.width * 0.039),
              child: CustomAppBar(
                pageTitle: Text(
                  'Uredite nalog',
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
                drugaIkonica: isDugmeLoading
                    ? SizedBox(
                        height: 30,
                        width: 30,
                        child: CircularProgressIndicator(),
                      )
                    : Icon(
                        LucideIcons.squareCheck,
                        size: 30,
                      ),
                drugaIkonicaFunkcija: isDugmeLoading
                    ? () {}
                    : () {
                        FocusManager.instance.primaryFocus!.unfocus();
                        updateUser();
                      },
              ),
            ),
          ),
        ),
        body: SingleChildScrollView(
          child: Container(
            margin: EdgeInsets.symmetric(horizontal: medijakveri.size.width * 0.039),
            child: SafeArea(
              child: Column(
                children: [
                  isLoading
                      ? Container(
                          height: (medijakveri.size.height - medijakveri.padding.top) * 0.8,
                          child: Center(
                            child: CircularProgressIndicator(),
                          ),
                        )
                      : Form(
                          key: formKey,
                          child: Column(
                            children: [
                              InputField(
                                isLabel: true,
                                label: "Ime",
                                focusNode: imeNode,
                                medijakveri: medijakveri,
                                hintText: "Ime",
                                initalValue: userData!.data()!['userName'].toString().substring(
                                      0,
                                      userData!.data()!['userName'].toString().indexOf(' '),
                                    ),
                                inputAction: TextInputAction.next,
                                kapitulacija: TextCapitalization.sentences,
                                inputType: TextInputType.name,
                                borderRadijus: 10,
                                visina: 18,
                                obscureText: false,
                                isMargin: false,
                                onChanged: (_) => formKey.currentState!.validate(),
                                validator: (value) {
                                  if (emailNode.hasFocus || prezimeNode.hasFocus || brojNode.hasFocus) {
                                    return null;
                                  } else if (value!.isEmpty) {
                                    return 'Molimo Vas da unesete ime';
                                  } else if (value.length < 2) {
                                    return 'Ime mora biti duže';
                                  } else if (!RegExp(r'^[a-zA-Z\S]+$').hasMatch(value)) {
                                    return 'Ime nije validano';
                                  } else if (value.length > 15) {
                                    return 'Ime mora biti kraće';
                                  } else if (value.contains(RegExp(r'[0-9]')) || value.contains(' ')) {
                                    return 'Ime smije sadržati samo velika i mala slova i simbole';
                                  }
                                },
                                onSaved: (value) {
                                  _authData['ime'] = value!.trim();
                                },
                              ),
                              SizedBox(height: 10),
                              InputField(
                                isLabel: true,
                                label: "Prezime",
                                focusNode: prezimeNode,
                                medijakveri: medijakveri,
                                hintText: "Prezime",
                                initalValue: userData!.data()!['userName'].toString().substring(
                                      userData!.data()!['userName'].toString().indexOf(' ') + 1,
                                    ),
                                inputAction: TextInputAction.next,
                                kapitulacija: TextCapitalization.sentences,
                                inputType: TextInputType.name,
                                borderRadijus: 10,
                                visina: 18,
                                obscureText: false,
                                isMargin: false,
                                onChanged: (_) => formKey.currentState!.validate(),
                                validator: (value) {
                                  if (imeNode.hasFocus || emailNode.hasFocus || brojNode.hasFocus) {
                                    return null;
                                  } else if (value!.isEmpty) {
                                    return 'Molimo Vas da unesete prezime';
                                  } else if (value.length < 2) {
                                    return 'Prezime mora biti duže';
                                  } else if (!RegExp(r'^[a-zA-Z\S]+$').hasMatch(value)) {
                                    return 'Prezime nije validano';
                                  } else if (value.length > 15) {
                                    return 'Prezime mora biti kraće';
                                  } else if (value.contains(RegExp(r'[0-9]')) || value.contains(' ')) {
                                    return 'Prezime smije sadržati samo velika i mala slova i simbole';
                                  }
                                },
                                onSaved: (value) {
                                  _authData['prezime'] = value!.trim();
                                },
                              ),
                              SizedBox(height: 10),
                              InputField(
                                isLabel: true,
                                label: "Email",
                                focusNode: emailNode,
                                medijakveri: medijakveri,
                                hintText: "E-mail",
                                inputAction: TextInputAction.next,
                                initalValue: userData!.data()!['email'],
                                inputType: TextInputType.emailAddress,
                                kapitulacija: TextCapitalization.none,
                                borderRadijus: 10,
                                visina: 18,
                                isMargin: false,
                                obscureText: false,
                                onChanged: (_) => formKey.currentState!.validate(),
                                validator: (value) {
                                  if (imeNode.hasFocus || prezimeNode.hasFocus || brojNode.hasFocus) {
                                    return null;
                                  } else if (value!.isEmpty) {
                                    return 'Molimo Vas da unesete email adresu';
                                  } else if (!value.contains(RegExp(r"^[a-zA-Z0-9.a-zA-Z0-9.!#$%&'*+-/=?^_`{|}~]+@[a-zA-Z0-9]+\.[a-zA-Z]+"))) {
                                    return 'Molimo Vas unesite validnu email adresu';
                                  }
                                },
                                onSaved: (value) {
                                  _authData['email'] = value!.trim();
                                },
                              ),
                              SizedBox(height: 10),
                              InputField(
                                isLabel: true,
                                label: "Broj telefona",
                                focusNode: brojNode,
                                medijakveri: medijakveri,
                                hintText: "068123456",
                                initalValue: userData!.data()!['broj'],
                                inputAction: TextInputAction.next,
                                inputType: TextInputType.phone,
                                kapitulacija: TextCapitalization.none,
                                borderRadijus: 10,
                                visina: 18,
                                isMargin: false,
                                obscureText: false,
                                onChanged: (_) => formKey.currentState!.validate(),
                                validator: (value) {
                                  if (imeNode.hasFocus || prezimeNode.hasFocus || emailNode.hasFocus) {
                                    return null;
                                  } else if (value!.isEmpty) {
                                    return 'Molimo Vas da unesete broj telefona';
                                  } else if (!value.contains(RegExp(r"^06\d{7}$"))) {
                                    // return '${!value.contains(RegExp(r"^06\d{7}$"))}';
                                    return 'Molimo Vas unesite validan broj telefona';
                                  }
                                },
                                onSaved: (value) {
                                  _authData['broj'] = value!.trim();
                                },
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
                                      pageBuilder: (context, animation, duration) => LocationEditScreen(
                                        currentPosition: currentPosition,
                                      ),
                                    ),
                                  );
                                },
                                child: InputFieldDisabled(
                                  medijakveri: medijakveri,
                                  label: 'Adresa',
                                  text: '${mjesto[0].subLocality == '' ? mjesto[0].locality == '' ? mjesto[0].name : mjesto[0].locality : mjesto[0].subLocality}, ${mjesto[0].administrativeArea}',
                                  borderRadijus: 10,
                                ),
                              ),
                              SizedBox(height: 10),
                              Row(
                                children: [
                                  Container(
                                    margin: EdgeInsets.only(
                                      bottom: 8,
                                      left: medijakveri.size.width * 0.02,
                                    ),
                                    child: Text(
                                      'Znanja i vještine',
                                      style: Theme.of(context).textTheme.headlineMedium!,
                                    ),
                                  ),
                                ],
                              ),
                              ListView.separated(
                                shrinkWrap: true,
                                primary: false,
                                padding: EdgeInsets.zero,
                                separatorBuilder: (context, index) => const SizedBox(height: 20),
                                itemCount: znanjaInput.length,
                                itemBuilder: (context, index) => Row(
                                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                  children: [
                                    InputField(
                                      isMargin: false,
                                      medijakveri: medijakveri,
                                      hintText: "Znanja i vještine",
                                      inputAction: TextInputAction.done,
                                      inputType: TextInputType.text,
                                      sirina: 0.82,
                                      visina: 18,
                                      borderRadijus: 10,
                                      brMaxLinija: 2,
                                      controller: znanjaInput[index],
                                      focusNode: znanjaFokus[index],
                                      obscureText: false,
                                      kapitulacija: TextCapitalization.sentences,
                                      onFieldSubmitted: (_) {
                                        if (index + 1 < znanjaFokus.length) {
                                          FocusScope.of(context).requestFocus(znanjaFokus[index + 1]);
                                        }
                                      },
                                      validator: (value) {
                                        if (imeNode.hasFocus || prezimeNode.hasFocus || emailNode.hasFocus || brojNode.hasFocus) {
                                          return null;
                                        }
                                        // else if (value!.trim().isEmpty || value == '') {
                                        //   return 'Molimo Vas da unesete polje';
                                        // }
                                        else if (value != null) {
                                          if (!RegExp(r'^[.,;:!?\"()\[\]{}<>@#$%^&*_+=/\\|`~a-zA-Z0-9\S ]*$').hasMatch(value)) {
                                            return 'Polje nije validno';
                                          } else if (value.length > 150) {
                                            return 'Polje mora biti kraće';
                                          }
                                        }
                                      },
                                      onSaved: (value) {
                                        if (value == null || value.isEmpty) {
                                          return;
                                        }
                                        znanja.add(value!.trim());
                                      },
                                    ),
                                    GestureDetector(
                                      onTap: () async {
                                        int brojac = znanjaInput[index].text.length;
                                        if (index == 0 && znanjaInput.length == 1) {
                                          for (var i = 0; i < brojac; i++) {
                                            znanjaInput[index].text = znanjaInput[index].text.substring(0, znanjaInput[index].text.length - 1);

                                            await Future.delayed(Duration(milliseconds: 30));
                                          }
                                          znanja.clear();
                                          // print(znanja);
                                          return;
                                        } else if (index > 0) {
                                          setState(() {
                                            znanjaInput[index].clear();
                                            znanjaInput[index].dispose();
                                            znanjaFokus[index].dispose();
                                            znanjaInput.removeAt(index);
                                            znanjaFokus.removeAt(index);
                                            print(znanja);
                                          });
                                        }
                                      },
                                      child: Icon(
                                        LucideIcons.trash,
                                        size: 30,
                                        color: index == 0 ? Colors.grey : Theme.of(context).colorScheme.primary,
                                        //
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                              SizedBox(height: 10),
                              Center(
                                child: GestureDetector(
                                  onTap: () {
                                    setState(() {
                                      if (znanjaInput.length > 25) {
                                        ScaffoldMessenger.of(context).hideCurrentSnackBar();
                                        ScaffoldMessenger.of(context).showSnackBar(
                                          SnackBar(
                                            content: Text(
                                              'Ne možete dodati više.',
                                              style: Theme.of(context).textTheme.labelLarge,
                                            ),
                                            duration: const Duration(milliseconds: 900),
                                            behavior: SnackBarBehavior.floating,
                                            backgroundColor: Theme.of(context).colorScheme.secondary,
                                            elevation: 4,
                                          ),
                                        );
                                        return;
                                      }

                                      znanjaInput.add(TextEditingController());
                                      znanjaFokus.add(FocusNode());
                                      znanjaFokus[znanjaFokus.length - 1].requestFocus();
                                    });
                                  },
                                  child: Icon(
                                    LucideIcons.circlePlus,
                                    color: Theme.of(context).colorScheme.primary,
                                  ),
                                ),
                              ),
                              SizedBox(height: 30),
                            ],
                          ),
                        ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
    imeNode.dispose();
    brojNode.dispose();
    prezimeNode.dispose();
    emailNode.dispose();
  }
}
