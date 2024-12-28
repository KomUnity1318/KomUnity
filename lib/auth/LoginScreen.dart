import 'package:flutter/material.dart';
import 'package:komunity/components/Button.dart';
import 'package:komunity/components/InputField.dart';

class LoginScreen extends StatefulWidget {
  static const String routeName = '/LoginScreen';

  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
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
                    SizedBox(height: (medijakveri.size.height - medijakveri.padding.top) * 0.1),
                    Text(
                      'Prijavite se',
                      style: Theme.of(context).textTheme.displayLarge,
                    ),
                  ],
                ),
                Column(
                  children: [
                    InputField(
                      isLabel: true,
                      label: "Email",
                      medijakveri: medijakveri,
                      hintText: "E-mail",
                      inputAction: TextInputAction.next,
                      inputType: TextInputType.emailAddress,
                      borderRadijus: 10,
                      visina: 20,
                      obscureText: false,
                      validator: (value) {},
                      onSaved: (value) {},
                      isMargin: false,
                    ),
                    SizedBox(height: 30),
                    InputField(
                      isLabel: true,
                      label: "Šifra",
                      medijakveri: medijakveri,
                      hintText: "Šifra",
                      inputAction: TextInputAction.next,
                      inputType: TextInputType.emailAddress,
                      borderRadijus: 10,
                      visina: 20,
                      obscureText: true,
                      validator: (value) {},
                      onSaved: (value) {},
                      isMargin: false,
                    ),
                    SizedBox(height: 15),
                    Row(
                      children: [
                        Text(
                          'Zaboravili ste šifru?',
                          style: Theme.of(context).textTheme.labelLarge,
                        ),
                      ],
                    ),
                  ],
                ),
                Button(
                  buttonText: "Prijavite se",
                  borderRadius: 10,
                  visina: 16,
                  backgroundColor: Theme.of(context).colorScheme.primary,
                  isBorder: false,
                  funkcija: () {},
                  isFullWidth: true,
                ),
                Text(
                  'Nemate nalog?',
                  style: Theme.of(context).textTheme.labelLarge,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
