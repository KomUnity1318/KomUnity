import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:komunity/components/CustomAppbar.dart';
import 'package:komunity/components/InputField.dart';
import 'package:lucide_icons_flutter/lucide_icons.dart';

class AccountEditScreen extends StatefulWidget {
  static const String routeName = '/AccountEditScreen';

  const AccountEditScreen({super.key});

  @override
  State<AccountEditScreen> createState() => _AccountEditScreenState();
}

class _AccountEditScreenState extends State<AccountEditScreen> {
  final formKey = GlobalKey<FormState>();
  bool isLoading = false;
  @override
  Widget build(BuildContext context) {
    final medijakveri = MediaQuery.of(context);
    return Scaffold(
      body: Container(
        margin: EdgeInsets.symmetric(horizontal: medijakveri.size.width * 0.039),
        child: SafeArea(
          child: Column(
            children: [
              CustomAppBar(
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
                drugaIkonica: isLoading
                    ? CircularProgressIndicator()
                    : Icon(
                        LucideIcons.squareCheck,
                        size: 30,
                      ),
                drugaIkonicaFunkcija: () {},
              ),
              FutureBuilder(
                future: FirebaseFirestore.instance.collection('users').doc(FirebaseAuth.instance.currentUser!.uid).get(),
                builder: (context, snapshot) {
                  return Form(
                    key: formKey,
                    child: Column(
                      children: [
                        // InputField(
                        //   isLabel: true,
                        //   label: "Ime",
                        //   focusNode: imeNode,
                        //   medijakveri: medijakveri,
                        //   hintText: "Ime",
                        //   inputAction: TextInputAction.next,
                        //   kapitulacija: TextCapitalization.sentences,
                        //   inputType: TextInputType.name,
                        //   borderRadijus: 10,
                        //   visina: 18,
                        //   obscureText: false,
                        //   isMargin: false,
                        //   onChanged: (_) => _form.currentState!.validate(),
                        //   validator: (value) {
                        //     if (emailNode.hasFocus || prezimeNode.hasFocus || pass1Node.hasFocus || pass2Node.hasFocus || brojNode.hasFocus) {
                        //       return null;
                        //     } else if (value!.isEmpty) {
                        //       return 'Molimo Vas da unesete ime';
                        //     } else if (value.length < 2) {
                        //       return 'Ime mora biti duže';
                        //     } else if (!RegExp(r'^[a-zA-Z\S]+$').hasMatch(value)) {
                        //       return 'Ime nije validano';
                        //     } else if (value.length > 30) {
                        //       return 'Ime mora biti kraće';
                        //     } else if (value.contains(RegExp(r'[0-9]')) || value.contains(' ')) {
                        //       return 'Ime smije sadržati samo velika i mala slova i simbole';
                        //     }
                        //   },
                        //   onSaved: (value) {
                        //     _authData['ime'] = value!.trim();
                        //   },
                        // ),
                      ],
                    ),
                  );
                },
              )
            ],
          ),
        ),
      ),
    );
  }
}
