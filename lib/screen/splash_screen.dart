import 'package:flutter/material.dart';
import 'package:flutter_store_pick_app/widget/buttons.dart';
import 'package:flutter_store_pick_app/widget/texts.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    // TODO: implement initState
    super.initState();

    Future.delayed(Duration(milliseconds: 1500), () {
      Navigator.popAndPushNamed(context, '/login');
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          // crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Image.asset('assets/app_logo.png', width: 120, height: 120),
            SizedBox(height: 46),
            Text(
              'Store Pick',
              style: TextStyle(fontSize: 40, fontWeight: FontWeight.w800),
            )
          ],
        ),
      ),
    );
  }
}
