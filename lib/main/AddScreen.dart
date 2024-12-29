import 'package:flutter/material.dart';

class AddScreen extends StatefulWidget {
  static const String routeName = '/AddScreen';

  const AddScreen({super.key});

  @override
  State<AddScreen> createState() => _AddScreenState();
}

class _AddScreenState extends State<AddScreen> {
  @override
  Widget build(BuildContext context) {
    final medijakveri = MediaQuery.of(context);
    return Scaffold(
      body: SafeArea(
        child: Column(
          children: [
            Text('Addscreen'),
          ],
        ),
      ),
    );
  }
}
