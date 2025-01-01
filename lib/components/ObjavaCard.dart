import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:komunity/MojProvider.dart';
import 'package:komunity/components/Button.dart';
import 'package:komunity/components/metode.dart';
import 'package:lucide_icons_flutter/lucide_icons.dart';
import 'package:provider/provider.dart';

class ObjavaCard extends StatefulWidget {
  final MediaQueryData medijakveri;
  final String objavaId;
  final String naslov;
  final String opis;
  final String ownerName;
  final String ownerId;
  final String createdAt;
  final String kategorija;
  final Map<String, dynamic> dobrovoljci;
  const ObjavaCard({
    super.key,
    required this.naslov,
    required this.opis,
    required this.ownerName,
    required this.medijakveri,
    required this.createdAt,
    required this.kategorija,
    required this.dobrovoljci,
    required this.objavaId,
    required this.ownerId,
  });

  @override
  State<ObjavaCard> createState() => _ObjavaCardState();
}

class _ObjavaCardState extends State<ObjavaCard> {
  @override
  Widget build(BuildContext context) {
    bool isDobrovoljac = false;
    for (var element in widget.dobrovoljci.keys) {
      if (element == FirebaseAuth.instance.currentUser!.uid) {
        setState(() {
          isDobrovoljac = true;
        });
      }
    }
    return Container(
      margin: EdgeInsets.only(bottom: 5),
      decoration: BoxDecoration(
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.8),
            offset: Offset(1, 2),
            blurRadius: 4,
            spreadRadius: -3,
            blurStyle: BlurStyle.normal,
          ),
        ],
        color: Colors.white,
        borderRadius: BorderRadius.circular(10),
      ),
      padding: EdgeInsets.all(12),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Row(
                children: [
                  Container(
                    decoration: BoxDecoration(
                      color: Colors.grey.shade400,
                      borderRadius: BorderRadius.circular(5),
                    ),
                    child: Icon(
                      LucideIcons.squareUser,
                      size: 30,
                    ),
                  ),
                  SizedBox(width: 5),
                  Container(
                    constraints: BoxConstraints(
                      maxWidth: widget.medijakveri.size.width * 0.4,
                    ),
                    child: FittedBox(
                      child: Text(
                        widget.ownerName,
                        style: Theme.of(context).textTheme.titleLarge,
                      ),
                    ),
                  ),
                  SizedBox(width: 3),
                  Text(
                    Metode.timeAgo(widget.createdAt),
                    style: Theme.of(context).textTheme.titleLarge!.copyWith(
                          color: Theme.of(context).colorScheme.tertiary,
                        ),
                  ),
                  SizedBox(width: 5),
                  Container(
                    padding: EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                    decoration: BoxDecoration(
                      color: Theme.of(context).colorScheme.tertiary,
                      borderRadius: BorderRadius.circular(4),
                    ),
                    child: Text(
                      '#${widget.kategorija}',
                      style: Theme.of(context).textTheme.titleLarge!.copyWith(
                            color: Colors.white,
                          ),
                    ),
                  ),
                ],
              ),
              GestureDetector(
                onTap: () {},
                child: Icon(
                  LucideIcons.ellipsisVertical,
                  size: 20,
                ),
              ),
            ],
          ),
          SizedBox(height: 5),
          Text(
            widget.naslov.length > 30 ? '${widget.naslov.substring(0, 30)}...' : widget.naslov,
            style: Theme.of(context).textTheme.headlineMedium!.copyWith(
                  fontWeight: FontWeight.w600,
                ),
          ),
          SizedBox(height: 5),
          Text(
            widget.opis.length > 80 ? '${widget.opis.substring(0, 80)}...' : widget.opis,
            style: Theme.of(context).textTheme.labelLarge!.copyWith(
                  color: Colors.grey,
                ),
          ),
          if (widget.ownerId != FirebaseAuth.instance.currentUser!.uid) SizedBox(height: 5),
          if (widget.ownerId != FirebaseAuth.instance.currentUser!.uid)
            Button(
              buttonText: isDobrovoljac ? 'Odustani' : 'Pomogni',
              borderRadius: 8,
              visina: 2,
              sirina: 130,
              iconTextRazmak: 5,
              icon: Icon(
                isDobrovoljac ? LucideIcons.heartCrack : LucideIcons.heartHandshake,
                color: isDobrovoljac ? Colors.white : Colors.black,
              ),
              backgroundColor: isDobrovoljac ? Theme.of(context).colorScheme.primary : Theme.of(context).colorScheme.secondary,
              textColor: isDobrovoljac ? Colors.white : Colors.black,
              fontsize: 16,
              isBorder: true,
              funkcija: () async {
                try {
                  try {
                    Metode.checkConnection(context: context);
                  } catch (e) {
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
                  }
                  Provider.of<MojProvider>(context, listen: false).pomogni(widget.dobrovoljci, widget.objavaId);
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
            ),
        ],
      ),
    );
    ;
  }
}
