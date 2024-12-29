import 'package:flutter/material.dart';
import 'package:komunity/auth/WelcomeScreen.dart';
import 'package:komunity/components/Button.dart';
import 'package:komunity/components/InputField.dart';

class ForgotPasswordScreen extends StatefulWidget {
  static const String routeName = '/ForgotPasswordScreen';

  const ForgotPasswordScreen({super.key});

  @override
  State<ForgotPasswordScreen> createState() => _ForgotPasswordScreenState();
}

class _ForgotPasswordScreenState extends State<ForgotPasswordScreen> {
  @override
  Widget build(BuildContext context) {
    final medijakveri = MediaQuery.of(context);
    return GestureDetector(
      onTap: () => FocusManager.instance.primaryFocus!.unfocus(),
      child: Scaffold(
        body: SafeArea(
          child: Container(
            margin: EdgeInsets.symmetric(horizontal: medijakveri.size.width * 0.05),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                SizedBox(height: 1),
                Column(
                  children: [
                    Text(
                      'Zaboravili ste šifru?',
                      style: Theme.of(context).textTheme.displayLarge,
                    ),
                    SizedBox(height: (medijakveri.size.height - medijakveri.padding.top) * 0.09),
                    Form(
                      child: InputField(
                        isLabel: true,
                        label: "Email",
                        medijakveri: medijakveri,
                        hintText: "E-mail",
                        inputAction: TextInputAction.next,
                        inputType: TextInputType.emailAddress,
                        borderRadijus: 10,
                        visina: 18,
                        obscureText: false,
                        validator: (value) {},
                        onSaved: (value) {},
                        isMargin: false,
                      ),
                    ),
                    SizedBox(height: (medijakveri.size.height - medijakveri.padding.top) * 0.09),
                    Button(
                      buttonText: "Pošaljite zahtjev",
                      borderRadius: 10,
                      visina: 16,
                      backgroundColor: Theme.of(context).colorScheme.secondary,
                      isBorder: true,
                      textColor: Colors.black,
                      funkcija: () {},
                      isFullWidth: true,
                    ),
                  ],
                ),
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
                        pageBuilder: (context, animation, duration) => WelcomeScreen(),
                      ),
                    );
                  },
                  child: Text(
                    'Nazad na početnu',
                    style: Theme.of(context).textTheme.labelLarge,
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
