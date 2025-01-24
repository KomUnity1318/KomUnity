import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:komunity/auth/ForgotPassScreen.dart';
import 'package:komunity/auth/RegisterScreen.dart';
import 'package:komunity/components/Button.dart';
import 'package:komunity/components/InputField.dart';
import 'package:komunity/components/metode.dart';
import 'package:lucide_icons_flutter/lucide_icons.dart';

class LoginScreen extends StatefulWidget {
  static const String routeName = '/LoginScreen';

  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final _form = GlobalKey<FormState>();

  final emailNode = FocusNode();
  final sifraNode = FocusNode();
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    emailNode.addListener(() {
      setState(() {});
    });
    sifraNode.addListener(() {
      setState(() {});
    });
  }

  Map<String, String> _authData = {
    'email': '',
    'sifra': '',
  };

  bool isLoading = false;

  void _login() async {
    if (!_form.currentState!.validate()) {
      return;
    }
    _form.currentState!.save();

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
      await FirebaseAuth.instance.signInWithEmailAndPassword(email: _authData['email']!, password: _authData['sifra']!).then((value) {
        Navigator.pop(context);
        setState(() {
          isLoading = false;
        });
      });
    } on FirebaseAuthException catch (error) {
      setState(() {
        isLoading = false;
      });

      Metode.showErrorDialog(
        isJednoPoredDrugog: false,
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
        message: 'Došlo je do greške',
        context: context,
        naslov: 'Greška',
        button1Text: 'Zatvori',
        button1Fun: () => Navigator.pop(context),
        isButton2: false,
      );
    }
  }

  bool isPassHidden = true;
  void changePassVisibility() {
    setState(() {
      isPassHidden = !isPassHidden;
    });
  }

  @override
  Widget build(BuildContext context) {
    final medijakveri = MediaQuery.of(context);
    return GestureDetector(
      onTap: () => FocusManager.instance.primaryFocus!.unfocus(),
      child: Scaffold(
        body: SafeArea(
          child: Container(
            margin: EdgeInsets.symmetric(horizontal: medijakveri.size.width * 0.05), // margin horizontal 20px
            child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Column(
                  children: [
                    SizedBox(height: (medijakveri.size.height - medijakveri.padding.top - (medijakveri.viewInsets.bottom)) * 0.1),
                    Text(
                      'Prijavite se',
                      style: Theme.of(context).textTheme.displayLarge,
                    ),
                  ],
                ),
                Form(
                  key: _form,
                  child: Column(
                    children: [
                      InputField(
                        isLabel: true,
                        isMargin: false,
                        visina: 18,
                        borderRadijus: 10,
                        medijakveri: medijakveri,
                        label: 'Email',
                        focusNode: emailNode,
                        inputAction: TextInputAction.next,
                        inputType: TextInputType.emailAddress,
                        obscureText: false,
                        onChanged: (_) => _form.currentState!.validate(),
                        validator: (value) {
                          if (sifraNode.hasFocus) {
                            return null;
                          } else if (value!.isEmpty) {
                            return 'Molimo Vas da unesete email adresu';
                          }
                        },
                        onSaved: (value) {
                          _authData['email'] = value!.trim();
                        },
                        hintText: 'E-mail',
                      ),
                      SizedBox(height: 30),
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
                            focusNode: sifraNode,
                            keyboardType: TextInputType.text,
                            textInputAction: TextInputAction.done,
                            obscureText: isPassHidden,
                            onFieldSubmitted: (_) {
                              FocusManager.instance.primaryFocus?.unfocus();
                              FocusScope.of(context).unfocus();

                              emailNode.unfocus();
                              sifraNode.unfocus();
                              _login();
                            },
                            onChanged: (_) => _form.currentState!.validate(),
                            validator: (value) {
                              if (emailNode.hasFocus) {
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
                            onSaved: (value) {
                              _authData['sifra'] = value!;
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
                              suffixIcon: sifraNode.hasFocus
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
                      Row(
                        children: [
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
                                  pageBuilder: (context, animation, duration) => ForgotPasswordScreen(),
                                ),
                              );
                            },
                            child: Text(
                              'Zaboravili ste šifru?',
                              style: Theme.of(context).textTheme.labelLarge,
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
                isLoading
                    ? CircularProgressIndicator()
                    : Button(
                        buttonText: "Prijavite se",
                        borderRadius: 10,
                        visina: 16,
                        backgroundColor: Theme.of(context).colorScheme.primary,
                        isBorder: false,
                        funkcija: () async {
                          FocusManager.instance.primaryFocus?.unfocus();
                          FocusScope.of(context).unfocus();

                          emailNode.unfocus();
                          sifraNode.unfocus();
                          _login();
                        },
                      ),
                Column(
                  children: [
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
                            pageBuilder: (context, animation, duration) => RegisterScreen(),
                          ),
                        );
                      },
                      child: Text(
                        'Nemate nalog?',
                        style: Theme.of(context).textTheme.labelLarge,
                      ),
                    ),
                    SizedBox(height: 10),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
