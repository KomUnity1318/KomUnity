import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:komunity/components/Button.dart';

class DobrodosliScreen extends StatefulWidget {
  static const String routeName = '/DobrodosliScreen';

  const DobrodosliScreen({super.key});

  @override
  State<DobrodosliScreen> createState() => _DobrodosliscreenState();
}

class _DobrodosliscreenState extends State<DobrodosliScreen> {
  @override
  Widget build(BuildContext context) {
    final medijakveri = MediaQuery.of(context);
    return Scaffold(
      body: SafeArea(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Column(
              children: [
                SizedBox(height: (medijakveri.size.height - medijakveri.padding.top) * 0.03),
                Container(
                  margin: EdgeInsets.symmetric(horizontal: 35),
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(10),
                    child: Image.asset("assets/icons/Logo.png"),
                  ),
                ),
              ],
            ),
            // SizedBox(height: (medijakveri.size.height - medijakveri.padding.top) * 0.06),

            Column(
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      'Kom',
                      style: Theme.of(context).textTheme.displayLarge,
                    ),
                    Text(
                      'Unity',
                      style: Theme.of(context).textTheme.displayLarge!.copyWith(
                            color: Theme.of(context).colorScheme.tertiary,
                          ),
                    ),
                  ],
                ),
                SizedBox(height: 10),
                Text(
                  'Vaša zajednica na dohvat ruke.',
                  style: Theme.of(context).textTheme.headlineLarge,
                ),
              ],
            ),
            Container(
              margin: EdgeInsets.symmetric(horizontal: medijakveri.size.width * 0.05),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Button(
                    buttonText: "Registrujte se",
                    borderRadius: 10,
                    visina: 16,
                    backgroundColor: Theme.of(context).colorScheme.primary,
                    isBorder: false,
                    funkcija: () {},
                    isFullWidth: true,
                  ),
                  SizedBox(height: 25),
                  Button(
                    buttonText: "Prijavite se",
                    borderRadius: 10,
                    visina: 16,
                    backgroundColor: Theme.of(context).colorScheme.secondary,
                    isBorder: true,
                    textColor: Colors.black,
                    funkcija: () {},
                    isFullWidth: true,
                  ),
                  SizedBox(height: (medijakveri.size.height - medijakveri.padding.top) * 0.09),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        'By ',
                        style: Theme.of(context).textTheme.labelLarge,
                      ),
                      Text(
                        'Intelecto',
                        style: Theme.of(context).textTheme.labelLarge!.copyWith(
                              color: Theme.of(context).colorScheme.tertiary,
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
  }
}
