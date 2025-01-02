import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:komunity/MojProvider.dart';
import 'package:komunity/components/Button.dart';
import 'package:komunity/components/metode.dart';
import 'package:lucide_icons_flutter/lucide_icons.dart';
import 'dart:convert';

import 'package:provider/provider.dart';

class LocationScreen extends StatefulWidget {
  static const String routeName = '/LocationScreen';
  final LatLng currentPosition;
  LocationScreen({
    super.key,
    required this.currentPosition,
  });

  @override
  State<LocationScreen> createState() => _LocationScreenState();
}

class _LocationScreenState extends State<LocationScreen> {
  User? currentUser;
  bool isLoading = false;

  bool isCurrentPosition = false;

  GoogleMapController? yourMapController;
  Set<Marker> markeri = {};
  String lokacijaError = '';

  Map<String, String> lokacijaData = {
    'lat': '',
    'long': '',
  };

  void changeMapMode(GoogleMapController mapController) {
    getJsonFile("assets/map_style.json").then((value) => setMapStyle(value, mapController));
  }

  void setMapStyle(String mapStyle, GoogleMapController mapController) {
    mapController.setMapStyle(mapStyle);
  }

  Future<String> getJsonFile(String path) async {
    ByteData byte = await rootBundle.load(path);
    var list = byte.buffer.asUint8List(byte.offsetInBytes, byte.lengthInBytes);
    return utf8.decode(list);
  }

  void addLocation() async {
    if (lokacijaData['lat'] == '' || lokacijaData['long'] == '') {
      setState(() {
        lokacijaError = 'Molimo Vas izaberite lokaciju.';
      });
    } else {
      setState(() {
        isLoading = true;
      });
      try {
        Metode.checkConnection(context: context);
      } catch (e) {
        setState(() {
          isLoading = false;
        });
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
        return;
      }
      try {
        await FirebaseFirestore.instance.collection('users').doc(FirebaseAuth.instance.currentUser!.uid).update({
          'location': {
            'lat': lokacijaData['lat'],
            'long': lokacijaData['long'],
          }
        }).then((value) {
          setState(() {
            isLoading = false;
          });
          Navigator.pushNamedAndRemoveUntil(context, '/', (route) => false);
        });
      } catch (error) {
        setState(() {
          isLoading = false;
        });
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
    }
  }

  @override
  Widget build(BuildContext context) {
    final medijakveri = MediaQuery.of(context);
    return Scaffold(
      body: GestureDetector(
        onTap: () {
          setState(() {
            markeri = {};
            lokacijaData['lat'] = '';
            lokacijaData['long'] = '';
          });
        },
        child: SafeArea(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              Container(
                child: Column(
                  children: [
                    SizedBox(height: (medijakveri.size.height - medijakveri.padding.top) * 0.05),
                    Text(
                      'Gdje je Vaš komšiluk?',
                      style: Theme.of(context).textTheme.displayLarge,
                    ),
                    SizedBox(height: 20),
                    Container(
                      margin: EdgeInsets.symmetric(horizontal: medijakveri.size.width * 0.05),
                      child: Text(
                        'Molimo Vas izaberite lokaciju Vaše kuće ili stana.',
                        style: Theme.of(context).textTheme.headlineLarge,
                        textAlign: TextAlign.center,
                      ),
                    ),
                  ],
                ),
              ),
              Column(
                children: [
                  Container(
                    height: (medijakveri.size.height - medijakveri.padding.top) * 0.45,
                    margin: EdgeInsets.symmetric(horizontal: medijakveri.size.width * 0.05),
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(10),
                      child: GoogleMap(
                        initialCameraPosition: CameraPosition(
                          // target: LatLng(43.072267184509066, 19.77565134246493),
                          target: widget.currentPosition,
                          zoom: 15,
                        ),
                        onMapCreated: (GoogleMapController c) {
                          yourMapController = c;
                          changeMapMode(yourMapController!);
                        },
                        compassEnabled: false,
                        mapToolbarEnabled: false,
                        mapType: MapType.normal,
                        myLocationButtonEnabled: true,
                        myLocationEnabled: true,
                        zoomControlsEnabled: false,
                        onTap: (position) {
                          setState(() {
                            markeri.clear();
                            markeri.add(
                              Marker(
                                markerId: MarkerId(
                                  DateTime.now().toIso8601String(),
                                ),
                                position: position,
                                icon: BitmapDescriptor.defaultMarker,
                              ),
                            );
                            lokacijaData['lat'] = position.latitude.toString();
                            lokacijaData['long'] = position.longitude.toString();
                            lokacijaError = '';
                          });
                        },
                        markers: markeri,
                      ),
                    ),
                  ),
                  SizedBox(height: 5),
                  if (lokacijaError != '')
                    Container(
                      margin: EdgeInsets.symmetric(horizontal: medijakveri.size.width * 0.05),
                      child: Row(
                        children: [
                          Text(
                            lokacijaError,
                            style: Theme.of(context).textTheme.labelLarge!.copyWith(
                                  color: Colors.red,
                                ),
                          ),
                        ],
                      ),
                    ),
                ],
              ),
              Container(
                margin: EdgeInsets.symmetric(horizontal: medijakveri.size.width * 0.05),
                child: Column(
                  children: [
                    Button(
                      buttonText: "Trenutna lokacija",
                      borderRadius: 10,
                      visina: 16,
                      icon: Icon(
                        LucideIcons.mapPin,
                        color: Colors.white,
                        size: 26,
                      ),
                      backgroundColor: Theme.of(context).colorScheme.primary,
                      isBorder: false,
                      funkcija: () {
                        setState(() {
                          markeri.clear();
                          markeri.add(
                            Marker(
                              markerId: MarkerId(
                                DateTime.now().toIso8601String(),
                              ),
                              position: widget.currentPosition,
                              icon: BitmapDescriptor.defaultMarker,
                            ),
                          );
                          lokacijaData['lat'] = widget.currentPosition.latitude.toString();
                          lokacijaData['long'] = widget.currentPosition.longitude.toString();
                          lokacijaError = '';
                        });
                      },
                    ),
                    SizedBox(height: 15),
                    Button(
                      buttonText: 'Potvrdi',
                      borderRadius: 10,
                      visina: 16,
                      icon: Icon(LucideIcons.circleCheckBig),
                      backgroundColor: Theme.of(context).colorScheme.secondary,
                      textColor: Colors.black,
                      isBorder: true,
                      funkcija: () {
                        addLocation();
                      },
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
