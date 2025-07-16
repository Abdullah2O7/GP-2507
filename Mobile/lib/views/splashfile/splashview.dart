import 'package:flutter/material.dart';
import 'package:splash_onboarding_test/views/splashfile/splashbody.dart';

class SplashView extends StatelessWidget {
  const SplashView({super.key});

  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      backgroundColor: Color(0xff537F5C),
      body: SplashViewbody(),
    );
  }
}
