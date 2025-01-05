import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:komunity/MojProvider.dart';
import 'package:komunity/auth/LocationScreen.dart';
import 'package:komunity/auth/LoginScreen.dart';
import 'package:komunity/components/Button.dart';
import 'package:komunity/components/InputField.dart';
import 'package:komunity/components/metode.dart';
import 'package:lucide_icons_flutter/lucide_icons.dart';
import 'package:provider/provider.dart';

class RegisterScreen extends StatefulWidget {
  static const String routeName = '/RegisterScreen';

  const RegisterScreen({super.key});

  @override
  State<RegisterScreen> createState() => _RegisterScreenState();
}

class _RegisterScreenState extends State<RegisterScreen> {
  final _form = GlobalKey<FormState>();
  Map<String, String> _authData = {
    'ime': '',
    'prezime': '',
    'email': '',
    'broj': '',
    'sifra': '',
  };

  final _passwordController = TextEditingController();
  bool isLoading = false;
  final imeNode = FocusNode();
  final prezimeNode = FocusNode();
  final emailNode = FocusNode();
  final brojNode = FocusNode();
  final pass1Node = FocusNode();
  final pass2Node = FocusNode();

  @override
  void initState() {
    super.initState();
    pass1Node.addListener(() {
      setState(() {});
    });
    imeNode.addListener(() {
      setState(() {});
    });
    prezimeNode.addListener(() {
      setState(() {});
    });
    emailNode.addListener(() {
      setState(() {});
    });
    brojNode.addListener(() {
      setState(() {});
    });
    pass2Node.addListener(() {
      setState(() {});
    });
  }

  bool isPassHidden = true;
  void changePassVisibility() {
    setState(() {
      isPassHidden = !isPassHidden;
    });
  }

  bool isPassHidden2 = true;
  void changePassVisibility2() {
    setState(() {
      isPassHidden2 = !isPassHidden2;
    });
  }

  void _register() async {
    if (!_form.currentState!.validate()) {
      return;
    }
    _form.currentState!.save();

    try {
      setState(() {
        isLoading = true;
      });
      if (!await Metode.checkConnection(context: context)) {
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
        setState(() {
          isLoading = false;
        });
        return;
      }

      await FirebaseAuth.instance.createUserWithEmailAndPassword(email: _authData['email']!, password: _authData['sifra']!).then((value) async {
        await FirebaseFirestore.instance.collection('users').doc(FirebaseAuth.instance.currentUser!.uid).set({
          'userId': FirebaseAuth.instance.currentUser!.uid,
          'email': FirebaseAuth.instance.currentUser!.email,
          'userName': '${_authData['ime']} ${_authData['prezime']}',
          'broj': _authData['broj'],
          'location': {
            'lat': '',
            'long': '',
          },
          'ratings': {},
          'znanjaVjestine': [],
        });
        LatLng currentPosition = LatLng(0, 0);
        await Provider.of<MojProvider>(context, listen: false).setCurrentPosition().then((valuE) {
          currentPosition = Provider.of<MojProvider>(context, listen: false).getCurrentPosition;
        });
        await FirebaseAuth.instance.currentUser!.updateDisplayName('${_authData['ime']} ${_authData['prezime']}').then((value) {
          setState(() {
            isLoading = false;
          });
          Navigator.pushReplacement(
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
              pageBuilder: (context, animation, duration) => LocationScreen(
                currentPosition: currentPosition,
                isAppBar: false,
              ),
            ),
          );
        });
      });
    } on FirebaseAuthException catch (error) {
      setState(() {
        isLoading = false;
      });
      Metode.showErrorDialog(
        isJednoPoredDrugog: false,
        // message: '$error',
        message: Metode.getMessageFromErrorCode(error),
        context: context,
        naslov: 'Greška',
        button1Text: 'Zatvori',
        button1Fun: () => Navigator.pop(context),
        isButton2: false,
      );
    } catch (error) {
      setState(() {
        isLoading = false;
      });

      Metode.showErrorDialog(
        isJednoPoredDrugog: false,
        // message: '$error',
        message: 'Došlo je do greške',
        context: context,
        naslov: 'Greška',
        button1Text: 'Zatvori',
        button1Fun: () => Navigator.pop(context),
        isButton2: false,
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final medijakveri = MediaQuery.of(context);
    return GestureDetector(
      onTap: () => FocusManager.instance.primaryFocus?.unfocus(),
      child: Scaffold(
        body: SafeArea(
          child: Align(
            alignment: Alignment.bottomCenter,
            child: SingleChildScrollView(
              child: Container(
                margin: EdgeInsets.symmetric(horizontal: medijakveri.size.width * 0.05), // margin horizontal 20px
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    SizedBox(height: (medijakveri.size.height - medijakveri.padding.top) * 0.035),
                    Text(
                      'Registrujte se',
                      style: Theme.of(context).textTheme.displayLarge,
                    ),
                    SizedBox(height: (medijakveri.size.height - medijakveri.padding.top) * 0.047),
                    Form(
                      key: _form,
                      child: Column(
                        children: [
                          InputField(
                            isLabel: true,
                            label: "Ime",
                            focusNode: imeNode,
                            medijakveri: medijakveri,
                            hintText: "Ime",
                            inputAction: TextInputAction.next,
                            kapitulacija: TextCapitalization.sentences,
                            inputType: TextInputType.name,
                            borderRadijus: 10,
                            visina: 18,
                            obscureText: false,
                            isMargin: false,
                            onChanged: (_) => _form.currentState!.validate(),
                            validator: (value) {
                              if (emailNode.hasFocus || prezimeNode.hasFocus || pass1Node.hasFocus || pass2Node.hasFocus || brojNode.hasFocus) {
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
                          SizedBox(height: 15),
                          InputField(
                            isLabel: true,
                            label: "Prezime",
                            focusNode: prezimeNode,
                            medijakveri: medijakveri,
                            hintText: "Prezime",
                            inputAction: TextInputAction.next,
                            kapitulacija: TextCapitalization.sentences,
                            inputType: TextInputType.name,
                            borderRadijus: 10,
                            visina: 18,
                            obscureText: false,
                            isMargin: false,
                            onChanged: (_) => _form.currentState!.validate(),
                            validator: (value) {
                              if (imeNode.hasFocus || emailNode.hasFocus || pass1Node.hasFocus || pass2Node.hasFocus || brojNode.hasFocus) {
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
                          SizedBox(height: 15),
                          InputField(
                            isLabel: true,
                            label: "Email",
                            focusNode: emailNode,
                            medijakveri: medijakveri,
                            hintText: "E-mail",
                            inputAction: TextInputAction.next,
                            inputType: TextInputType.emailAddress,
                            kapitulacija: TextCapitalization.none,
                            borderRadijus: 10,
                            visina: 18,
                            isMargin: false,
                            obscureText: false,
                            onChanged: (_) => _form.currentState!.validate(),
                            validator: (value) {
                              if (imeNode.hasFocus || prezimeNode.hasFocus || pass1Node.hasFocus || pass2Node.hasFocus || brojNode.hasFocus) {
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
                          SizedBox(height: 15),
                          InputField(
                            isLabel: true,
                            label: "Broj telefona",
                            focusNode: brojNode,
                            medijakveri: medijakveri,
                            hintText: "068123456",
                            inputAction: TextInputAction.next,
                            inputType: TextInputType.phone,
                            kapitulacija: TextCapitalization.none,
                            borderRadijus: 10,
                            visina: 18,
                            isMargin: false,
                            obscureText: false,
                            onChanged: (_) => _form.currentState!.validate(),
                            validator: (value) {
                              if (imeNode.hasFocus || prezimeNode.hasFocus || pass1Node.hasFocus || pass2Node.hasFocus || emailNode.hasFocus) {
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
                          SizedBox(height: 15),
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Container(
                                margin: EdgeInsets.only(
                                  bottom: (medijakveri.size.height - medijakveri.padding.top) * 0.005,
                                  left: medijakveri.size.width * 0.02,
                                ),
                                child: Text(
                                  'Šifra',
                                  style: Theme.of(context).textTheme.headlineMedium,
                                ),
                              ),
                              TextFormField(
                                focusNode: pass1Node,
                                keyboardType: TextInputType.text,
                                textInputAction: TextInputAction.next,
                                obscureText: isPassHidden,
                                controller: _passwordController,
                                onFieldSubmitted: (_) {
                                  FocusScope.of(context).requestFocus(pass2Node);
                                },
                                onChanged: (_) => _form.currentState!.validate(),
                                validator: (value) {
                                  if (imeNode.hasFocus || prezimeNode.hasFocus || emailNode.hasFocus || pass2Node.hasFocus || brojNode.hasFocus) {
                                    return null;
                                  } else if (value!.isEmpty || !value.contains(RegExp(r'[A-Za-z]'))) {
                                    return 'Molimo Vas unesite šifru';
                                  } else if (value.length < 5) {
                                    return 'Šifra mora imati više od 4 karaktera';
                                  } else if (value.length > 50) {
                                    return 'Šifra mora imati manje od 50 karaktera';
                                  } else if (!RegExp(r'^[a-zA-Z\S]+$').hasMatch(value)) {
                                    return 'Šifra nije validna';
                                  }
                                },
                                decoration: InputDecoration(
                                  hintText: 'Šifra',
                                  hintStyle: Theme.of(context).textTheme.labelLarge?.copyWith(
                                        color: Colors.grey,
                                        fontSize: 16,
                                      ),
                                  filled: true,
                                  fillColor: Colors.white,
                                  contentPadding: const EdgeInsets.symmetric(horizontal: 18, vertical: 18),
                                  focusedBorder: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(10),
                                    borderSide: BorderSide(
                                      color: Theme.of(context).colorScheme.tertiary,
                                    ),
                                  ),
                                  enabledBorder: OutlineInputBorder(
                                    borderSide: const BorderSide(color: Color(0xFF91BFDD)),
                                    borderRadius: BorderRadius.circular(10),
                                  ),
                                  border: OutlineInputBorder(
                                    borderSide: const BorderSide(color: Colors.white),
                                    borderRadius: BorderRadius.circular(10),
                                  ),
                                  suffixIcon: pass1Node.hasFocus
                                      ? IconButton(
                                          onPressed: () => changePassVisibility(),
                                          icon: isPassHidden ? const Icon(LucideIcons.eye) : const Icon(LucideIcons.eyeOff),
                                        )
                                      : null,
                                ),
                              ),
                            ],
                          ),
                          SizedBox(height: 15),
                          Container(
                            margin: EdgeInsets.only(bottom: (medijakveri.size.height - medijakveri.padding.top) * 0.025),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Container(
                                  margin: EdgeInsets.only(
                                    bottom: (medijakveri.size.height - medijakveri.padding.top) * 0.005,
                                    left: medijakveri.size.width * 0.02,
                                  ),
                                  child: Text(
                                    'Potvrdite šifru',
                                    style: Theme.of(context).textTheme.headlineMedium,
                                  ),
                                ),
                                TextFormField(
                                  focusNode: pass2Node,
                                  keyboardType: TextInputType.text,
                                  textInputAction: TextInputAction.done,
                                  obscureText: isPassHidden2,
                                  onChanged: (_) => _form.currentState!.validate(),
                                  validator: (value) {
                                    if (imeNode.hasFocus || prezimeNode.hasFocus || pass1Node.hasFocus || emailNode.hasFocus || brojNode.hasFocus) {
                                      return null;
                                    } else if (value!.isEmpty) {
                                      return 'Molimo Vas unesite šifru';
                                    } else if (value != _passwordController.text) {
                                      return 'Šifre moraju biti iste';
                                    }
                                  },
                                  onSaved: (value) {
                                    _authData['sifra'] = value!;
                                  },
                                  onFieldSubmitted: (_) {
                                    FocusManager.instance.primaryFocus?.unfocus();
                                    FocusScope.of(context).unfocus();

                                    imeNode.unfocus();
                                    prezimeNode.unfocus();
                                    emailNode.unfocus();
                                    pass1Node.unfocus();
                                    pass2Node.unfocus();

                                    _register();
                                  },
                                  decoration: InputDecoration(
                                    hintText: 'Potvrdite šifru',
                                    hintStyle: Theme.of(context).textTheme.labelLarge?.copyWith(
                                          color: Colors.grey,
                                          fontSize: 16,
                                        ),
                                    filled: true,
                                    fillColor: Colors.white,
                                    contentPadding: const EdgeInsets.symmetric(horizontal: 18, vertical: 18),
                                    enabledBorder: OutlineInputBorder(
                                      borderSide: const BorderSide(color: Color(0xFF91BFDD)),
                                      borderRadius: BorderRadius.circular(10),
                                    ),
                                    border: OutlineInputBorder(
                                      borderSide: const BorderSide(color: Colors.white),
                                      borderRadius: BorderRadius.circular(10),
                                    ),
                                    focusedBorder: OutlineInputBorder(
                                      borderRadius: BorderRadius.circular(10),
                                      borderSide: BorderSide(
                                        color: Theme.of(context).colorScheme.tertiary,
                                      ),
                                    ),
                                    suffixIcon: pass2Node.hasFocus
                                        ? IconButton(
                                            onPressed: () => changePassVisibility2(),
                                            icon: isPassHidden2 ? const Icon(LucideIcons.eye) : const Icon(LucideIcons.eyeOff),
                                          )
                                        : null,
                                  ),
                                ),
                              ],
                            ),
                          ),
                          SizedBox(height: (medijakveri.size.height - medijakveri.padding.top) * 0.05),
                          isLoading
                              ? CircularProgressIndicator()
                              : Button(
                                  buttonText: "Registrujte se",
                                  borderRadius: 10,
                                  visina: 16,
                                  backgroundColor: Theme.of(context).colorScheme.secondary,
                                  isBorder: true,
                                  textColor: Colors.black,
                                  funkcija: () {
                                    FocusManager.instance.primaryFocus?.unfocus();
                                    FocusScope.of(context).unfocus();

                                    imeNode.unfocus();
                                    prezimeNode.unfocus();
                                    emailNode.unfocus();
                                    pass1Node.unfocus();
                                    pass2Node.unfocus();
                                    _register();
                                  },
                                ),
                        ],
                      ),
                    ),
                    SizedBox(height: (medijakveri.size.height - medijakveri.padding.top) * 0.06),
                    GestureDetector(
                      onTap: () {
                        Navigator.pushReplacement(
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
                            pageBuilder: (context, animation, duration) => LoginScreen(),
                          ),
                        );
                      },
                      child: Text(
                        'Već imate nalog?',
                        style: Theme.of(context).textTheme.labelLarge,
                      ),
                    ),
                    SizedBox(height: 10),
                  ],
                ),
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
    pass1Node.dispose();
    pass2Node.dispose();
    imeNode.dispose();
    brojNode.dispose();
    prezimeNode.dispose();
    emailNode.dispose();
  }
}
