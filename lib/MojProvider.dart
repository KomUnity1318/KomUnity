import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

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
      await FirebaseFirestore.instance.collection('posts').doc(objavaId).update({
        'dobrovoljci.${FirebaseAuth.instance.currentUser!.uid}': FieldValue.delete(),
      });
      notifyListeners();
    } else {
      await FirebaseFirestore.instance.collection('posts').doc(objavaId).update({
        'dobrovoljci': {
          FirebaseAuth.instance.currentUser!.uid: DateTime.now().toIso8601String(),
        },
      });
      notifyListeners();
    }
    notifyListeners();
  }
}
