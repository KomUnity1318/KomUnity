import 'dart:io';

import 'package:flutter/material.dart';
import 'package:komunity/main/AccountScreen.dart';
import 'package:komunity/main/AddScreen.dart';
import 'package:komunity/main/HomeScreen.dart';
import 'package:lucide_icons_flutter/lucide_icons.dart';
import 'package:slide_indexed_stack/slide_indexed_stack.dart';
import 'package:provider/provider.dart';

class BottomNavigationBarScreen extends StatefulWidget {
  static const String routeName = '/BottomNavigationBarScreen';

  const BottomNavigationBarScreen({super.key});

  @override
  State<BottomNavigationBarScreen> createState() => _BottomNavigationBarScreenState();
}

class _BottomNavigationBarScreenState extends State<BottomNavigationBarScreen> {
  final List<Widget> _screens = [
    HomeScreen(),
    AddScreen(),
    AccountScreen(),
  ];

  int _selectedIndex = 0;

  void _selectPage(int index) async {
    if (index == _selectedIndex) {
      return;
    }
    setState(() {
      FocusManager.instance.primaryFocus?.unfocus();

      _selectedIndex = index;
    });
    // try {
    //   await InternetAddress.lookup('google.com').then((value) {
    //     Provider.of<MealProvider>(context, listen: false).setIsInternet(true);
    //   });
    // } catch (error) {
    //   Provider.of<MealProvider>(context, listen: false).setIsInternet(false);
    // }
  }

  @override
  Widget build(BuildContext context) {
    final medijakveri = MediaQuery.of(context);

    return GestureDetector(
      onTap: () => FocusManager.instance.primaryFocus!.unfocus(),
      child: Scaffold(
        resizeToAvoidBottomInset: false,
        body: Container(
          margin: EdgeInsets.symmetric(horizontal: medijakveri.size.width * 0.039),
          child: SlideIndexedStack(
            axis: Axis.horizontal,
            slideOffset: 0.5,
            duration: const Duration(milliseconds: 500),
            index: _selectedIndex,
            children: _screens,
          ),
        ),
        bottomNavigationBar: Container(
          decoration: const BoxDecoration(
            color: Colors.white,
            border: Border(
              top: BorderSide(
                width: 0.5,
                color: Color(0xFFB0B0B0),
              ),
            ),
          ),
          height: (medijakveri.size.height - medijakveri.padding.top) * 0.1,
          child: BottomNavigationBar(
            onTap: _selectPage,
            type: BottomNavigationBarType.fixed,
            currentIndex: _selectedIndex,
            iconSize: 35,
            selectedLabelStyle: Theme.of(context).textTheme.titleLarge,
            unselectedLabelStyle: Theme.of(context).textTheme.titleLarge,
            selectedItemColor: Theme.of(context).colorScheme.tertiary,
            unselectedItemColor: Theme.of(context).primaryColor,
            showUnselectedLabels: true,
            items: const [
              BottomNavigationBarItem(
                icon: Icon(LucideIcons.house),
                label: 'Početna',
              ),
              BottomNavigationBarItem(
                icon: Icon(LucideIcons.circlePlus),
                label: 'Dodaj',
              ),
              BottomNavigationBarItem(
                icon: Icon(LucideIcons.squareUser),
                label: 'Nalog',
              ),
            ],
          ),
        ),
      ),
    );
  }
}
