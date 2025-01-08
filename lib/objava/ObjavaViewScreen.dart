import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_svg/svg.dart';
import 'package:geocoding/geocoding.dart';
import 'package:komunity/MojProvider.dart';
import 'package:komunity/account/AccountViewUserScreen.dart';
import 'package:komunity/components/CustomAppbar.dart';
import 'package:komunity/components/metode.dart';
import 'package:komunity/objava/ObjavaEditScreen.dart';
import 'package:lucide_icons_flutter/lucide_icons.dart';
import 'package:provider/provider.dart';

class ObjavaViewScreen extends StatefulWidget {
  static const String routeName = '/ObjavaViewScreen';

  final String ownerId;
  final String objavaId;
  final bool ownerProfileClick;

  const ObjavaViewScreen({
    super.key,
    required this.ownerId,
    required this.objavaId,
    required this.ownerProfileClick,
  });

  @override
  State<ObjavaViewScreen> createState() => _ObjavaViewScreenState();
}

class _ObjavaViewScreenState extends State<ObjavaViewScreen> {
  bool isLoading = false;
  List<Placemark> mjesto = [];
  DocumentSnapshot<Map<String, dynamic>>? objava;
  DocumentSnapshot<Map<String, dynamic>>? userData;

  void didChangeDependencies() async {
    // TODO: implement didChangeDependencies
    super.didChangeDependencies();
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
    }
    try {
      await FirebaseFirestore.instance.collection('posts').doc(widget.objavaId).get().then((objavaValue) async {
        objava = objavaValue;
        print(objava);
        await FirebaseFirestore.instance.collection('users').doc(widget.ownerId).get().then((userDataValue) async {
          userData = userDataValue;
          try {
            mjesto = await placemarkFromCoordinates(double.parse(userData!.data()!['location']['lat']), double.parse(userData!.data()!['location']['long'])).then((value) {
              setState(() {
                isLoading = false;
              });
              return value;
            });
          } catch (e) {
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
        });
      });
    } catch (e) {
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

  @override
  Widget build(BuildContext context) {
    final medijakveri = MediaQuery.of(context);
    return Scaffold(
      appBar: PreferredSize(
        preferredSize: Size(100, 100),
        child: SafeArea(
          child: Container(
            margin: EdgeInsets.symmetric(horizontal: medijakveri.size.width * 0.039),
            child: CustomAppBar(
              pageTitle: Text(
                'Objava',
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
              drugaIkonica: Icon(
                LucideIcons.ellipsisVertical,
                size: 30,
              ),
              drugaIkonicaFunkcija: widget.ownerId != FirebaseAuth.instance.currentUser!.uid
                  ? () {
                      Metode.showErrorDialog(
                        context: context,
                        naslov: 'Koju akciju želite da izvršite?',
                        button1Text: 'Prijavi',
                        button1Fun: () {
                          ScaffoldMessenger.of(context).hideCurrentSnackBar();
                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(
                              content: Text(
                                'Uspješno ste prijavili objavu!',
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
                        },
                        isButton2: false,
                        isJednoPoredDrugog: false,
                      );
                    }
                  : () {
                      Metode.showErrorDialog(
                        context: context,
                        naslov: 'Koju akciju želite da izvršite?',
                        button1Text: 'Uredite objavu',
                        button1Icon: Icon(LucideIcons.squarePen),
                        isButton1Icon: true,
                        button1Fun: () {
                          Navigator.pop(context);
                          Navigator.pushReplacement(
                            context,
                            PageRouteBuilder(
                              transitionDuration: const Duration(milliseconds: 500),
                              reverseTransitionDuration: const Duration(milliseconds: 500),
                              transitionsBuilder: (context, animation, secondaryAnimation, child) {
                                return SlideTransition(
                                  position: Tween<Offset>(
                                    begin: const Offset(-1, 0),
                                    end: Offset.zero,
                                  ).animate(
                                    CurvedAnimation(parent: animation, curve: Curves.easeInOutExpo),
                                  ),
                                  child: child,
                                );
                              },
                              pageBuilder: (context, animation, duration) => ObjavaEditScreen(
                                naslov: objava!.data()!['naslov'],
                                opis: objava!.data()!['opis'],
                                kategorija: objava!.data()!['kategorija'],
                                objavaId: widget.objavaId,
                              ),
                            ),
                          );
                        },
                        isButton2: true,
                        button2Text: 'Obrišite objavu',
                        isButton2Icon: true,
                        button2Icon: Icon(LucideIcons.trash),
                        button2Fun: () async {
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
                          try {
                            await FirebaseFirestore.instance.collection('posts').doc(widget.objavaId).delete().then((value) {
                              Navigator.pop(context);
                              Navigator.pushNamedAndRemoveUntil(context, '/', (Route<dynamic> route) => false);

                              ScaffoldMessenger.of(context).hideCurrentSnackBar();
                              ScaffoldMessenger.of(context).showSnackBar(
                                SnackBar(
                                  content: Text(
                                    'Uspješno ste obrisali objavu!',
                                    style: Theme.of(context).textTheme.labelLarge!.copyWith(
                                          color: Colors.white,
                                        ),
                                  ),
                                  duration: const Duration(milliseconds: 1500),
                                  behavior: SnackBarBehavior.floating,
                                  backgroundColor: Colors.red,
                                  elevation: 4,
                                ),
                              );
                            });
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
                        isJednoPoredDrugog: false,
                      );
                    },
            ),
          ),
        ),
      ),
      body: SingleChildScrollView(
        primary: false,
        child: Container(
          margin: EdgeInsets.symmetric(horizontal: medijakveri.size.width * 0.039),
          child: SafeArea(
            child: isLoading
                ? Container(
                    height: (medijakveri.size.height - medijakveri.padding.top) * 0.8,
                    child: Center(
                      child: CircularProgressIndicator(),
                    ),
                  )
                : Column(
                    children: [
                      GestureDetector(
                        onTap: () {
                          print(userData!.data()!['location']['lat']);
                        },
                        child: Row(
                          children: [
                            Container(
                              // width: medijakveri.size.width * 0.9,
                              constraints: BoxConstraints(
                                maxWidth: medijakveri.size.width * 0.9,
                                maxHeight: 40,
                              ),
                              child: FittedBox(
                                child: Text(
                                  objava!.data()!['naslov'],
                                  style: Theme.of(context).textTheme.displayLarge!.copyWith(
                                        color: Theme.of(context).colorScheme.primary,
                                      ),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                      SizedBox(height: 15),
                      GestureDetector(
                        onTap: widget.ownerId != FirebaseAuth.instance.currentUser!.uid
                            ? widget.ownerProfileClick
                                ? () {
                                    Navigator.push(
                                      context,
                                      PageRouteBuilder(
                                        transitionDuration: const Duration(milliseconds: 500),
                                        reverseTransitionDuration: const Duration(milliseconds: 500),
                                        transitionsBuilder: (context, animation, secondaryAnimation, child) {
                                          return SlideTransition(
                                            position: Tween<Offset>(
                                              begin: const Offset(-1, 0),
                                              end: Offset.zero,
                                            ).animate(
                                              CurvedAnimation(parent: animation, curve: Curves.easeInOutExpo),
                                            ),
                                            child: child,
                                          );
                                        },
                                        pageBuilder: (context, animation, duration) => AccountViewUserScreen(
                                          nalogId: widget.ownerId,
                                        ),
                                      ),
                                    );
                                  }
                                : () {}
                            : () {},
                        child: Row(
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            Container(
                              decoration: BoxDecoration(
                                color: Colors.grey.shade300,
                                borderRadius: BorderRadius.circular(5),
                              ),
                              child: Icon(
                                LucideIcons.squareUser,
                                size: 50,
                              ),
                            ),
                            SizedBox(width: 5),
                            Row(
                              crossAxisAlignment: CrossAxisAlignment.end,
                              children: [
                                Container(
                                  constraints: BoxConstraints(
                                    maxWidth: medijakveri.size.width * 0.45,
                                    minHeight: 20,
                                  ),
                                  child: FittedBox(
                                    child: Text(
                                      userData!.data()!['userName'].length > 25 ? '${userData!.data()!['userName'].toString().substring(0, 20)}...' : userData!.data()!['userName'],
                                      style: Theme.of(context).textTheme.headlineMedium,
                                    ),
                                  ),
                                ),
                                SizedBox(width: 3),
                                Text(
                                  Metode.timeAgo(objava!.data()!['createdAt']),
                                  style: Theme.of(context).textTheme.labelLarge!.copyWith(
                                        color: Theme.of(context).colorScheme.tertiary,
                                      ),
                                ),
                              ],
                            ),
                            SizedBox(width: 5),
                            Container(
                              constraints: BoxConstraints(maxWidth: 80),
                              padding: EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                              decoration: BoxDecoration(
                                color: Theme.of(context).colorScheme.tertiary,
                                borderRadius: BorderRadius.circular(4),
                              ),
                              child: Text(
                                '#${objava!.data()!['kategorija']}',
                                style: Theme.of(context).textTheme.titleLarge!.copyWith(
                                      color: Colors.white,
                                    ),
                              ),
                            ),
                          ],
                        ),
                      ),
                      SizedBox(height: 15),
                      Container(
                        width: medijakveri.size.width * 0.961,
                        child: Text(
                          objava!.data()!['opis'],
                          style: Theme.of(context).textTheme.headlineMedium!.copyWith(
                                color: Colors.grey,
                              ),
                        ),
                      ),
                      SizedBox(height: 15),
                      Container(
                        width: medijakveri.size.width,
                        padding: EdgeInsets.symmetric(horizontal: 10, vertical: 15),
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(10),
                        ),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              'Kontakt',
                              style: Theme.of(context).textTheme.headlineMedium,
                            ),
                            SizedBox(height: 10),
                            Row(
                              children: [
                                Text(
                                  'Adresa: ',
                                  style: Theme.of(context).textTheme.labelLarge,
                                ),
                                GestureDetector(
                                  onTap: () {
                                    Metode.launchInBrowser('https://www.google.com/maps/search/?api=1&query=${userData!.data()!['location']['lat']},${userData!.data()!['location']['long']}');
                                  },
                                  child: Container(
                                    constraints: BoxConstraints(
                                      maxWidth: medijakveri.size.width * 0.65,
                                    ),
                                    child: FittedBox(
                                      child: Text(
                                        // '${mjesto[0]}, ${mjesto[0].administrativeArea}',
                                        '${mjesto[0].subLocality == '' ? mjesto[0].locality == '' ? mjesto[0].name : mjesto[0].locality : mjesto[0].subLocality}, ${mjesto[0].administrativeArea}',
                                        style: Theme.of(context).textTheme.labelLarge?.copyWith(
                                              color: Theme.of(context).colorScheme.tertiary,
                                              decoration: TextDecoration.underline,
                                              decorationColor: Theme.of(context).colorScheme.tertiary,
                                            ),
                                      ),
                                    ),
                                  ),
                                ),
                              ],
                            ),
                            SizedBox(height: 10),
                            Text(
                              'Broj telefona: ${userData!.data()!['broj']}',
                              style: Theme.of(context).textTheme.labelLarge,
                            ),
                          ],
                        ),
                      ),
                      Column(
                        children: [
                          SizedBox(height: 15),
                          Row(
                            children: [
                              Text(
                                'Dobrovoljci',
                                style: Theme.of(context).textTheme.headlineMedium,
                              ),
                            ],
                          ),
                          SizedBox(height: 10),
                          Container(
                            height: (medijakveri.size.height - medijakveri.padding.top) * 0.515,
                            child: StreamBuilder(
                              stream: FirebaseFirestore.instance.collection('users').snapshots(),
                              builder: (context, snapshot) {
                                if (snapshot.connectionState == ConnectionState.waiting) {
                                  return const Center(
                                    child: CircularProgressIndicator(),
                                  );
                                }
                                List<QueryDocumentSnapshot<Map<String, dynamic>>> users;
                                users = snapshot.data!.docs;
                                List<QueryDocumentSnapshot<Map<String, dynamic>>> dobrovoljciProfili = [];
                                if (objava!.data()!['dobrovoljci'] != {}) {
                                  dobrovoljciProfili = users.where((element) => objava!.data()!['dobrovoljci'].containsKey(element['userId'])).toList();
                                }
                                if (dobrovoljciProfili.isEmpty) {
                                  return Center(
                                    child: Text(
                                      'Nema dobrovoljaca',
                                      style: Theme.of(context).textTheme.headlineMedium,
                                    ),
                                  );
                                }
                                return ListView.builder(
                                  primary: false,
                                  itemCount: dobrovoljciProfili.length,
                                  itemBuilder: (context, index) {
                                    return GestureDetector(
                                      onTap: () {
                                        Navigator.push(
                                          context,
                                          PageRouteBuilder(
                                            transitionDuration: const Duration(milliseconds: 500),
                                            reverseTransitionDuration: const Duration(milliseconds: 500),
                                            transitionsBuilder: (context, animation, secondaryAnimation, child) {
                                              return SlideTransition(
                                                position: Tween<Offset>(
                                                  begin: const Offset(-1, 0),
                                                  end: Offset.zero,
                                                ).animate(
                                                  CurvedAnimation(parent: animation, curve: Curves.easeInOutExpo),
                                                ),
                                                child: child,
                                              );
                                            },
                                            pageBuilder: (context, animation, duration) => AccountViewUserScreen(
                                              nalogId: dobrovoljciProfili[index].data()['userId'],
                                            ),
                                          ),
                                        );
                                      },
                                      child: Container(
                                        margin: EdgeInsets.only(bottom: 5),
                                        padding: EdgeInsets.all(10),
                                        decoration: BoxDecoration(
                                          color: Colors.white,
                                          borderRadius: BorderRadius.circular(10),
                                          boxShadow: [
                                            BoxShadow(
                                              color: Colors.black.withOpacity(0.8),
                                              offset: Offset(1, 2),
                                              blurRadius: 4,
                                              spreadRadius: -3,
                                              blurStyle: BlurStyle.normal,
                                            ),
                                          ],
                                        ),
                                        child: Row(
                                          children: [
                                            Container(
                                              decoration: BoxDecoration(
                                                color: Colors.grey.shade300,
                                                borderRadius: BorderRadius.circular(5),
                                              ),
                                              child: Icon(
                                                LucideIcons.squareUser,
                                                size: 65,
                                              ),
                                            ),
                                            SizedBox(width: 10),
                                            Expanded(
                                              child: Column(
                                                crossAxisAlignment: CrossAxisAlignment.start,
                                                children: [
                                                  Text(
                                                    dobrovoljciProfili[index].data()['userName'],
                                                    style: Theme.of(context).textTheme.headlineMedium,
                                                  ),
                                                  SizedBox(height: 10),
                                                  if (objava!.data()!['kategorija'] != 'Poklanjam')
                                                    if (widget.ownerId == FirebaseAuth.instance.currentUser!.uid)
                                                      if (dobrovoljciProfili[index].data()['ratings'].keys.toString().contains('${widget.objavaId}${widget.ownerId}'))
                                                        Row(
                                                          children: [
                                                            GestureDetector(
                                                              onTap: () {
                                                                dobrovoljciProfili[index].data()['ratings']['${widget.objavaId}${widget.ownerId}'] >= 1
                                                                    ? Provider.of<MojProvider>(context, listen: false).removeRateDobrovoljac(context, widget.objavaId, widget.ownerId, dobrovoljciProfili[index].data()['userId'])
                                                                    : Provider.of<MojProvider>(context, listen: false).rateDobrovoljac(context, 1, widget.ownerId, dobrovoljciProfili[index].data()['userId'], widget.objavaId);
                                                              },
                                                              child: SvgPicture.asset(
                                                                dobrovoljciProfili[index].data()['ratings']['${widget.objavaId}${widget.ownerId}'] >= 1 ? 'assets/icons/StarFilled.svg' : 'assets/icons/Star.svg',
                                                                height: 30,
                                                                width: 30,
                                                              ),
                                                            ),
                                                            SizedBox(width: 10),
                                                            GestureDetector(
                                                              onTap: () {
                                                                dobrovoljciProfili[index].data()['ratings']['${widget.objavaId}${widget.ownerId}'] >= 2
                                                                    ? Provider.of<MojProvider>(context, listen: false).removeRateDobrovoljac(context, widget.objavaId, widget.ownerId, dobrovoljciProfili[index].data()['userId'])
                                                                    : Provider.of<MojProvider>(context, listen: false).rateDobrovoljac(context, 2, widget.ownerId, dobrovoljciProfili[index].data()['userId'], widget.objavaId);
                                                              },
                                                              child: SvgPicture.asset(
                                                                dobrovoljciProfili[index].data()['ratings']['${widget.objavaId}${widget.ownerId}'] >= 2 ? 'assets/icons/StarFilled.svg' : 'assets/icons/Star.svg',
                                                                height: 30,
                                                                width: 30,
                                                              ),
                                                            ),
                                                            SizedBox(width: 10),
                                                            GestureDetector(
                                                              onTap: () {
                                                                dobrovoljciProfili[index].data()['ratings']['${widget.objavaId}${widget.ownerId}'] >= 3
                                                                    ? Provider.of<MojProvider>(context, listen: false).removeRateDobrovoljac(context, widget.objavaId, widget.ownerId, dobrovoljciProfili[index].data()['userId'])
                                                                    : Provider.of<MojProvider>(context, listen: false).rateDobrovoljac(context, 3, widget.ownerId, dobrovoljciProfili[index].data()['userId'], widget.objavaId);
                                                              },
                                                              child: SvgPicture.asset(
                                                                dobrovoljciProfili[index].data()['ratings']['${widget.objavaId}${widget.ownerId}'] >= 3 ? 'assets/icons/StarFilled.svg' : 'assets/icons/Star.svg',
                                                                height: 30,
                                                                width: 30,
                                                              ),
                                                            ),
                                                            SizedBox(width: 10),
                                                            GestureDetector(
                                                              onTap: () {
                                                                dobrovoljciProfili[index].data()['ratings']['${widget.objavaId}${widget.ownerId}'] >= 4
                                                                    ? Provider.of<MojProvider>(context, listen: false).removeRateDobrovoljac(context, widget.objavaId, widget.ownerId, dobrovoljciProfili[index].data()['userId'])
                                                                    : Provider.of<MojProvider>(context, listen: false).rateDobrovoljac(context, 4, widget.ownerId, dobrovoljciProfili[index].data()['userId'], widget.objavaId);
                                                              },
                                                              child: SvgPicture.asset(
                                                                dobrovoljciProfili[index].data()['ratings']['${widget.objavaId}${widget.ownerId}'] >= 4 ? 'assets/icons/StarFilled.svg' : 'assets/icons/Star.svg',
                                                                height: 30,
                                                                width: 30,
                                                              ),
                                                            ),
                                                            SizedBox(width: 10),
                                                            GestureDetector(
                                                              onTap: () {
                                                                dobrovoljciProfili[index].data()['ratings']['${widget.objavaId}${widget.ownerId}'] >= 5
                                                                    ? Provider.of<MojProvider>(context, listen: false).removeRateDobrovoljac(context, widget.objavaId, widget.ownerId, dobrovoljciProfili[index].data()['userId'])
                                                                    : Provider.of<MojProvider>(context, listen: false).rateDobrovoljac(context, 5, widget.ownerId, dobrovoljciProfili[index].data()['userId'], widget.objavaId);
                                                              },
                                                              child: SvgPicture.asset(
                                                                dobrovoljciProfili[index].data()['ratings']['${widget.objavaId}${widget.ownerId}'] >= 5 ? 'assets/icons/StarFilled.svg' : 'assets/icons/Star.svg',
                                                                height: 30,
                                                                width: 30,
                                                              ),
                                                            ),
                                                          ],
                                                        ),
                                                  if (objava!.data()!['kategorija'] != 'Poklanjam')
                                                    if (widget.ownerId == FirebaseAuth.instance.currentUser!.uid)
                                                      if (!dobrovoljciProfili[index].data()['ratings'].keys.toString().contains('${widget.objavaId}${widget.ownerId}'))
                                                        Row(
                                                          children: [
                                                            GestureDetector(
                                                              onTap: () {
                                                                Provider.of<MojProvider>(context, listen: false).rateDobrovoljac(context, 1, widget.ownerId, dobrovoljciProfili[index].data()['userId'], widget.objavaId);
                                                              },
                                                              child: SvgPicture.asset(
                                                                'assets/icons/Star.svg',
                                                                height: 30,
                                                                width: 30,
                                                              ),
                                                            ),
                                                            SizedBox(width: 10),
                                                            GestureDetector(
                                                              onTap: () {
                                                                Provider.of<MojProvider>(context, listen: false).rateDobrovoljac(context, 2, widget.ownerId, dobrovoljciProfili[index].data()['userId'], widget.objavaId);
                                                              },
                                                              child: SvgPicture.asset(
                                                                'assets/icons/Star.svg',
                                                                height: 30,
                                                                width: 30,
                                                              ),
                                                            ),
                                                            SizedBox(width: 10),
                                                            GestureDetector(
                                                              onTap: () {
                                                                Provider.of<MojProvider>(context, listen: false).rateDobrovoljac(context, 3, widget.ownerId, dobrovoljciProfili[index].data()['userId'], widget.objavaId);
                                                              },
                                                              child: SvgPicture.asset(
                                                                'assets/icons/Star.svg',
                                                                height: 30,
                                                                width: 30,
                                                              ),
                                                            ),
                                                            SizedBox(width: 10),
                                                            GestureDetector(
                                                              onTap: () {
                                                                Provider.of<MojProvider>(context, listen: false).rateDobrovoljac(context, 4, widget.ownerId, dobrovoljciProfili[index].data()['userId'], widget.objavaId);
                                                              },
                                                              child: SvgPicture.asset(
                                                                'assets/icons/Star.svg',
                                                                height: 30,
                                                                width: 30,
                                                              ),
                                                            ),
                                                            SizedBox(width: 10),
                                                            GestureDetector(
                                                              onTap: () {
                                                                Provider.of<MojProvider>(context, listen: false).rateDobrovoljac(context, 5, widget.ownerId, dobrovoljciProfili[index].data()['userId'], widget.objavaId);
                                                              },
                                                              child: SvgPicture.asset(
                                                                'assets/icons/Star.svg',
                                                                height: 30,
                                                                width: 30,
                                                              ),
                                                            ),
                                                          ],
                                                        ),
                                                ],
                                              ),
                                            ),
                                          ],
                                        ),
                                      ),
                                    );
                                  },
                                );
                              },
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
          ),
        ),
      ),
    );
  }
}
