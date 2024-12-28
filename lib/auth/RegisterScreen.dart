import 'package:flutter/material.dart';
import 'package:komunity/components/Button.dart';
import 'package:komunity/components/InputField.dart';

class RegisterScreen extends StatefulWidget {
  static const String routeName = '/RegisterScreen';

  const RegisterScreen({super.key});

  @override
  State<RegisterScreen> createState() => _RegisterScreenState();
}

class _RegisterScreenState extends State<RegisterScreen> {
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
                      child: Column(
                        children: [
                          InputField(
                            isLabel: true,
                            label: "Ime",
                            medijakveri: medijakveri,
                            hintText: "Ime",
                            inputAction: TextInputAction.next,
                            inputType: TextInputType.name,
                            borderRadijus: 10,
                            visina: 18,
                            obscureText: false,
                            validator: (value) {},
                            onSaved: (value) {},
                            isMargin: false,
                          ),
                          SizedBox(height: (medijakveri.size.height - medijakveri.padding.top) * 0.02),
                          InputField(
                            isLabel: true,
                            label: "Prezime",
                            medijakveri: medijakveri,
                            hintText: "Prezime",
                            inputAction: TextInputAction.next,
                            inputType: TextInputType.name,
                            borderRadijus: 10,
                            visina: 18,
                            obscureText: false,
                            validator: (value) {},
                            onSaved: (value) {},
                            isMargin: false,
                          ),
                          SizedBox(height: (medijakveri.size.height - medijakveri.padding.top) * 0.02),
                          InputField(
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
                          SizedBox(height: (medijakveri.size.height - medijakveri.padding.top) * 0.02),
                          InputField(
                            isLabel: true,
                            label: "Šifra",
                            medijakveri: medijakveri,
                            hintText: "Šifra",
                            inputAction: TextInputAction.next,
                            inputType: TextInputType.emailAddress,
                            borderRadijus: 10,
                            visina: 18,
                            obscureText: true,
                            validator: (value) {},
                            onSaved: (value) {},
                            isMargin: false,
                          ),
                          SizedBox(height: (medijakveri.size.height - medijakveri.padding.top) * 0.02),
                          InputField(
                            isLabel: true,
                            label: "Potvrdite šifru",
                            medijakveri: medijakveri,
                            hintText: "Potvrdite šifru",
                            inputAction: TextInputAction.next,
                            inputType: TextInputType.emailAddress,
                            borderRadijus: 10,
                            visina: 18,
                            obscureText: true,
                            validator: (value) {},
                            onSaved: (value) {},
                            isMargin: false,
                          ),
                          SizedBox(height: (medijakveri.size.height - medijakveri.padding.top) * 0.05),
                          Button(
                            buttonText: "Registrujte se",
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
                    ),
                    SizedBox(height: (medijakveri.size.height - medijakveri.padding.top) * 0.06),
                    Text(
                      'Već imate nalog?',
                      style: Theme.of(context).textTheme.labelLarge,
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
