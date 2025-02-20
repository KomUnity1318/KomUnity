import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:url_launcher/url_launcher.dart';

class Metode {
  static Future<bool> checkConnection({required context}) async {
    try {
      await InternetAddress.lookup('google.com');
      return true;
    } catch (error) {
      return false;
    }
  }

  static Future<void> launchInBrowser(String juarel) async {
    final url = Uri.parse(juarel);
    if (!await launchUrl(
      url,
      mode: LaunchMode.externalApplication,
    )) {
      throw Exception('Could not launch $url');
    }
  }

  static void showErrorDialog({
    String? message,
    Widget? sifra,
    required BuildContext context,
    required String naslov,
    required String button1Text,
    required Function button1Fun,
    bool isButton1Icon = false,
    Widget? button1Icon,
    required bool isButton2,
    String? button2Text,
    Function? button2Fun,
    bool isButton2Icon = false,
    Widget? button2Icon,
    required bool isJednoPoredDrugog,
  }) {
    showDialog(
      context: context,
      builder: (context) {
        final medijakveri = MediaQuery.of(context);

        return AlertDialog(
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
          title: Text(
            naslov,
            style: Theme.of(context).textTheme.headlineMedium!.copyWith(
                  color: Theme.of(context).colorScheme.primary,
                ),
            textAlign: TextAlign.center,
          ),
          content: message != null
              ? Padding(
                  padding: const EdgeInsets.only(top: 18.0, bottom: 24),
                  child: Text(
                    message,
                    style: TextStyle(
                      fontSize: 20,
                      color: Theme.of(context).colorScheme.primary,
                    ),
                    textAlign: TextAlign.center,
                  ),
                )
              : sifra != null
                  ? sifra
                  : null,
          actions: [
            isJednoPoredDrugog == true
                ? Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          GestureDetector(
                            onTap: () => button1Fun(),
                            child: Container(
                              padding: const EdgeInsets.symmetric(
                                vertical: 10,
                                horizontal: 10,
                              ),
                              decoration: BoxDecoration(
                                // color: Theme.of(context).primaryColor,
                                borderRadius: BorderRadius.circular(20),
                              ),
                              child: Row(
                                children: [
                                  if (isButton1Icon) button1Icon!,
                                  if (isButton1Icon) const SizedBox(width: 5),
                                  Text(
                                    button1Text,
                                    style: TextStyle(
                                      fontSize: 20,
                                      fontWeight: FontWeight.bold,
                                      color: Theme.of(context).colorScheme.primary,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ],
                      ),
                      if (isButton2)
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            GestureDetector(
                              onTap: () => button2Fun!(),
                              child: Container(
                                padding: const EdgeInsets.symmetric(
                                  vertical: 10,
                                  horizontal: 10,
                                ),
                                decoration: BoxDecoration(
                                  // color: Theme.of(context).primaryColor,
                                  borderRadius: BorderRadius.circular(20),
                                ),
                                child: Row(
                                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                  children: [
                                    if (isButton2Icon) button2Icon!,
                                    if (isButton2Icon) const SizedBox(width: 5),
                                    Text(
                                      button2Text!,
                                      style: TextStyle(
                                        fontWeight: FontWeight.bold,
                                        fontSize: 20,
                                        // color: Colors.white,
                                        color: Theme.of(context).colorScheme.primary,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          ],
                        ),
                    ],
                  )
                : Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      GestureDetector(
                        onTap: () => button1Fun(),
                        child: Container(
                          padding: const EdgeInsets.symmetric(
                            vertical: 10,
                            horizontal: 10,
                          ),
                          decoration: BoxDecoration(
                            // color: Theme.of(context).primaryColor,
                            borderRadius: BorderRadius.circular(20),
                          ),
                          child: Row(
                            children: [
                              if (isButton1Icon) button1Icon!,
                              if (isButton1Icon) const SizedBox(width: 5),
                              Text(
                                button1Text,
                                style: TextStyle(
                                  fontSize: 20,
                                  fontWeight: FontWeight.bold,
                                  color: Theme.of(context).primaryColor,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),
            if (!isJednoPoredDrugog)
              if (isButton2) const SizedBox(height: 20),
            if (isButton2)
              if (!isJednoPoredDrugog)
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    GestureDetector(
                      onTap: () => button2Fun!(),
                      child: Container(
                        padding: const EdgeInsets.symmetric(
                          vertical: 10,
                          horizontal: 10,
                        ),
                        decoration: BoxDecoration(
                          // color: Theme.of(context).primaryColor,
                          borderRadius: BorderRadius.circular(20),
                        ),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            if (isButton2Icon) button2Icon!,
                            if (isButton2Icon) const SizedBox(width: 5),
                            Text(
                              button2Text!,
                              style: TextStyle(
                                fontWeight: FontWeight.bold,
                                fontSize: 20,
                                color: Theme.of(context).primaryColor,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
          ],
        );
      },
    );
  }

  static String getMessageFromErrorCode(error) {
    switch (error.code) {
      case "ERROR_EMAIL_ALREADY_IN_USE":
      case "account-exists-with-different-credential":
      case "email-already-in-use":
        return "Taj E-mail je već u upotrebi.";
      case 'invalid-phone-number':
        return 'Taj broj telefona nije validan';
      case "network-request-failed":
        return "Nema internet konekcije";
      case "ERROR_WRONG_PASSWORD":
      case "wrong-password":
        return "Pogrešna šifra";
      case "ERROR_USER_NOT_FOUND":
      case "user-not-found":
        return "Ne možemo naći korisnika sa tim E-mailom.";
      case "ERROR_USER_DISABLED":
      case "user-disabled":
        return "User disabled.";
      case "ERROR_TOO_MANY_REQUESTS":
      case "operation-not-allowed":
        return "Too many requests to log into this account.";
      case "ERROR_OPERATION_NOT_ALLOWED":
      case "operation-not-allowed":
        return "Server error, please try again later.";
      case "ERROR_INVALID_EMAIL":
      case "invalid-email":
        return "Molimo Vas unesite validnu E-mail adresu.";
      case "invalid-credential":
        return "E-mail ili šifra nisu tačni.";
      default:
        return "Došlo je do greške. Molimo Vas pokušajte kasnije.";
      // return "${error.code}";
    }
  }

  static String timeAgo(t1) {
    DateTime time1 = DateTime.parse(t1);
    DateTime time2 = DateTime.now();

    var sekunde1 = time1.millisecondsSinceEpoch / 1000;
    var sekunde2 = time2.millisecondsSinceEpoch / 1000;
    var sekunde = (sekunde2 - sekunde1);
    var minuti = sekunde.floor() / 60;
    var sati = sekunde.floor() / 3600;
    var dani = sekunde.floor() / 86400;
    var meseci = sekunde.floor() / 2592000;
    var godine = sekunde.floor() / 31104000;

    if (godine.floor() != 0) {
      return '${godine.floor()}g';
    } else if (meseci.floor() != 0) {
      return '${meseci.floor()}m';
    } else if (dani.floor() != 0) {
      return '${dani.floor()}d';
    } else if (sati.floor() != 0) {
      return '${sati.floor()}h';
    } else if (minuti.floor() != 0) {
      return '${minuti.floor()}min';
    } else {
      return '1min';
    }
  }

  // static Future<void> createDynamicLink(String refCode) async {
  //   String url = 'https://com.example.mealy?ref=$refCode';
  //   final DynamicLinkParameters parameters = DynamicLinkParameters(
  //     link: Uri.parse(url),
  //     uriPrefix: 'https://mealy.page.link',
  //     androidParameters: AndroidParameters(
  //       packageName: 'com.example.mealy',
  //       minimumVersion: 0,
  //     ),
  //   );
  //   FirebaseDynamicLinks link = FirebaseDynamicLinks.instance;

  //   final refLink = await link.buildShortLink(parameters);

  //   Share.share(refLink.shortUrl.toString());
  // }

  // static String? stavke(int kolicina) {
  //   if (kolicina % 10 == 1 && kolicina != 11) {
  //     return 'stavka';
  //   } else if ((kolicina % 10 <= 4 && (kolicina % 100 != 12 && kolicina % 100 != 13 && kolicina % 100 != 14) && kolicina != 0)) {
  //     return 'stavke';
  //   } else {
  //     return 'stavki';
  //   }
  // }

  // static Future<String?> stavke2(Future<int> kolicina) async {
  //   int kolicinaValue = await kolicina;
  //   if (kolicinaValue % 10 == 1 && kolicinaValue != 11) {
  //     return 'stavka';
  //   } else if (kolicinaValue % 10 <= 4 && (kolicinaValue % 100 != 12 && kolicinaValue % 100 != 13 && kolicinaValue % 100 != 14)) {
  //     return 'stavke';
  //   } else {
  //     return 'stavki';
  //   }
  // }
}
