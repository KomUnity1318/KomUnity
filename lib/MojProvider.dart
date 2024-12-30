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
}
