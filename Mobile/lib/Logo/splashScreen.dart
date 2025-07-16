import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
//import 'package:splash_onboarding_test/home.dart';
import 'package:splash_onboarding_test/views/InstructionScreen.dart';

class Splashscreen extends StatefulWidget {
  const Splashscreen({super.key});

  @override
  State<Splashscreen> createState() => _SplashscreenState();
}

class _SplashscreenState extends State<Splashscreen>
    with SingleTickerProviderStateMixin
//make me determine duration and animation and everything
{
  @override
  void initState() {
    super.initState();
    SystemChrome.setEnabledSystemUIMode(SystemUiMode.immersive);
    //to hide BottomBar
    Future.delayed(const Duration(seconds: 3
    ), () {
      Navigator.of(context).pushReplacement(
        MaterialPageRoute(
          builder: (context) => IntroScreen(),
        ),
      );
    });
  }

  @override
  void dispose() {
    SystemChrome.setEnabledSystemUIMode(SystemUiMode.manual,
        overlays: SystemUiOverlay.values);
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF537F5C),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            
            Image.asset('assets/New Project-2-svg 1.png',height: 200,width: 250,),
            const Text(
              'MALAZ',
              style: TextStyle(
                  color: Colors.white, fontSize: 37, fontFamily: 'Ledger'),
            ),
          ],
        ),
      ),
    );
  }
}
