import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
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
      print(_selectedIndex);
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
            // iconSize: medijakveri.size.height * 0.0415,
            iconSize: 35,
            selectedLabelStyle: Theme.of(context).textTheme.titleLarge,
            unselectedLabelStyle: Theme.of(context).textTheme.titleLarge,
            selectedItemColor: Theme.of(context).colorScheme.tertiary,
            unselectedItemColor: Theme.of(context).primaryColor,
            backgroundColor: Colors.white,
            showUnselectedLabels: true,
            items: [
              BottomNavigationBarItem(
                icon: _selectedIndex == 0 ? SvgPicture.asset('assets/icons/HouseSelected.svg') : SvgPicture.asset('assets/icons/House.svg'),
                label: 'Početna',
              ),
              BottomNavigationBarItem(
                icon: _selectedIndex == 1 ? SvgPicture.asset('assets/icons/CirclePlusSelected.svg') : SvgPicture.asset('assets/icons/CirclePlus.svg'),
                label: 'Dodaj',
              ),
              BottomNavigationBarItem(
                icon: _selectedIndex == 2 ? SvgPicture.asset('assets/icons/SquareUserSelected.svg') : SvgPicture.asset('assets/icons/SquareUser.svg'),
                label: 'Nalog',
              ),
            ],
          ),
        ),
      ),
    );
  }
}
