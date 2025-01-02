import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:komunity/components/metode.dart';
import 'package:lucide_icons_flutter/lucide_icons.dart';

class MojProvider with ChangeNotifier {
  LatLng currentPosition = LatLng(0, 0);

  LatLng get getCurrentPosition {
    return currentPosition;
  }

  Future<void> setCurrentPosition() async {
    await Geolocator.checkPermission();
    await Geolocator.requestPermission();

    await Geolocator.getCurrentPosition(desiredAccuracy: LocationAccuracy.best).then((devicePosition) {
      currentPosition = LatLng(devicePosition.latitude, devicePosition.longitude);
    });
    notifyListeners();
  }

  void pomogni(Map<String, dynamic> dobrovoljci, String objavaId) async {
    bool isDobrovoljac = false;
    // print(dobrovoljci);
    dobrovoljci.keys.forEach((element) async {
      if (element == FirebaseAuth.instance.currentUser!.uid) {
        isDobrovoljac = true;
      }
    });
    if (isDobrovoljac) {
      await FirebaseFirestore.instance.collection('posts').doc(objavaId).set(
        {
          'dobrovoljci.${FirebaseAuth.instance.currentUser!.uid}': FieldValue.delete(),
        },
        SetOptions(merge: true),
      );

      notifyListeners();
    } else {
      await FirebaseFirestore.instance.collection('posts').doc(objavaId).set(
        {
          'dobrovoljci': {
            FirebaseAuth.instance.currentUser!.uid: DateTime.now().toIso8601String(),
          },
        },
        SetOptions(merge: true),
      );
      notifyListeners();
    }
    notifyListeners();
  }

  void rateDobrovoljac(context, brZvjezdica, ownerId, dobrovoljacId, objavaId) {
    Metode.showErrorDialog(
      isJednoPoredDrugog: true,
      context: context,
      naslov: brZvjezdica == 1
          ? 'Da li želite da ocijenite ovog dobrovoljca sa 1 zvjezdicom?'
          : brZvjezdica == 2
              ? 'Da li želite da ocijenite ovog dobrovoljca sa 2 zvjezdice?'
              : brZvjezdica == 3
                  ? 'Da li želite da ocijenite ovog dobrovoljca sa 3 zvjezdicom?'
                  : brZvjezdica == 4
                      ? 'Da li želite da ocijenite ovog dobrovoljca sa 4 zvjezdicom?'
                      : brZvjezdica == 5
                          ? 'Da li želite da ocijenite ovog dobrovoljca sa 5 zvjezdicom?'
                          : '',
      button1Text: 'Otkaži',
      isButton1Icon: true,
      button1Icon: Icon(
        LucideIcons.circleX,
        color: Theme.of(context).colorScheme.primary,
      ),
      button1Fun: () {
        Navigator.pop(context);
      },
      isButton2: true,
      button2Text: 'Potvrdi',
      isButton2Icon: true,
      button2Icon: Icon(
        LucideIcons.circleCheck,
        color: Theme.of(context).colorScheme.primary,
      ),
      button2Fun: () async {
        try {
          Metode.checkConnection(context: context);
        } catch (error) {
          Navigator.pop(context);

          Metode.showErrorDialog(
            isJednoPoredDrugog: false,
            message: "Došlo je do greške sa internetom. Provjerite svoju konekciju.",
            context: context,
            naslov: 'Greška',
            button1Text: 'Zatvori',
            button1Fun: () => Navigator.pop(context),
            isButton2: false,
          );
          return;
        }
        try {
          FirebaseFirestore.instance.collection('users').doc(dobrovoljacId).set(
            {
              'ratings': {
                '$objavaId$ownerId': brZvjezdica,
              },
            },
            SetOptions(merge: true),
          ).then((value) {
            Navigator.pop(context);
            ScaffoldMessenger.of(context).hideCurrentSnackBar();
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text(
                  'Vaša ocjena je zabilježena.',
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
            notifyListeners();
          });
        } catch (e) {
          Navigator.pop(context);

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
    );
    notifyListeners();
  }

  void removeRateDobrovoljac(context, objavaId, ownerId, dobrovoljacId) {
    Metode.showErrorDialog(
      isJednoPoredDrugog: true,
      context: context,
      naslov: 'Da li ste sigurni da želite da uklonite Vašu ocjenu?',
      button1Text: 'Otkaži',
      isButton1Icon: true,
      button1Icon: Icon(
        LucideIcons.circleX,
        color: Theme.of(context).colorScheme.primary,
      ),
      button1Fun: () {
        Navigator.pop(context);
      },
      isButton2: true,
      button2Text: 'Potvrdi',
      isButton2Icon: true,
      button2Icon: Icon(
        LucideIcons.circleCheck,
        color: Theme.of(context).colorScheme.primary,
      ),
      button2Fun: () async {
        try {
          Metode.checkConnection(context: context);
        } catch (error) {
          Navigator.pop(context);

          Metode.showErrorDialog(
            isJednoPoredDrugog: false,
            message: "Došlo je do greške sa internetom. Provjerite svoju konekciju.",
            context: context,
            naslov: 'Greška',
            button1Text: 'Zatvori',
            button1Fun: () => Navigator.pop(context),
            isButton2: false,
          );
          return;
        }
        try {
          FirebaseFirestore.instance.collection('users').doc(dobrovoljacId).update(
            {
              'ratings.${objavaId}${ownerId}': FieldValue.delete(),
            },
          ).then((value) {
            Navigator.pop(context);
            ScaffoldMessenger.of(context).hideCurrentSnackBar();
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text(
                  'Vaša ocjena je uklonjena.',
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
            notifyListeners();
          });
        } catch (e) {
          Navigator.pop(context);

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
    );
    notifyListeners();
  }
}
