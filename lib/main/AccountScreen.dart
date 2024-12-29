import 'dart:io';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:komunity/components/metode.dart';

class AccountScreen extends StatefulWidget {
  static const String routeName = '/AccountScreen';

  const AccountScreen({super.key});

  @override
  State<AccountScreen> createState() => _AccountScreenState();
}

class _AccountScreenState extends State<AccountScreen> {
  @override
  Widget build(BuildContext context) {
    final medijakveri = MediaQuery.of(context);
    return Scaffold(
      body: SafeArea(
        child: Column(
          children: [
            GestureDetector(
              onTap: () async {
                try {
                  await InternetAddress.lookup('google.com');
                } catch (e) {
                  Metode.showErrorDialog(
                    isJednoPoredDrugog: false,
                    context: context,
                    naslov: 'Nema veze',
                    button1Text: 'Zatvori',
                    button1Fun: () {
                      Navigator.pop(context);
                    },
                    isButton2: false,
                  );
                }
                try {
                  FirebaseAuth.instance.signOut();
                  Navigator.pushNamedAndRemoveUntil(context, '/', (Route<dynamic> route) => false);
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
              },
              child: Text('AccountScreen'),
            ),
          ],
        ),
      ),
    );
  }
}
