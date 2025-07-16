import 'package:flutter/material.dart';
import 'package:splash_onboarding_test/Registeration/auth_service.dart';
import 'package:splash_onboarding_test/nav_layout.dart';
import 'package:splash_onboarding_test/views/InstructionScreen.dart';
import 'package:splash_onboarding_test/views/splashfile/slidingtext.dart';

class SplashViewbody extends StatefulWidget {
  const SplashViewbody({super.key});

  @override
  State<SplashViewbody> createState() => _SplashViewbodyState();
}

class _SplashViewbodyState extends State<SplashViewbody>
    with SingleTickerProviderStateMixin {
  late AnimationController animationController;
  late Animation<Offset> slidingAnimation;

  @override
  void initState() {
    super.initState();
    initSlidingAnimation();

    navigateToHome();
  }

  @override
  void dispose() {
    super.dispose();

    animationController.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Image.asset('assets/finallogo.png'),
        //SizedBox(height: 0,),
        SlidingText(slidingAnimation: slidingAnimation),
      ],
    );
  }

  void initSlidingAnimation() {
    animationController = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 1),
    );

    slidingAnimation =
        Tween<Offset>(begin: const Offset(0, 2), end: const Offset(0, -1))
            .animate(animationController);

    animationController.forward();
  }

  void navigateToHome() async {
    bool isLoggined = await AuthService.getIsLoggedIn() ?? false;
    Future.delayed(
      const Duration(seconds: 3),
      () async {
        if (isLoggined) {
          Navigator.pushReplacement(
            context,
            MaterialPageRoute(
              builder: (context) => const NavLayout(),
            ),
          );
        } else {
          Navigator.pushReplacement(
            context,
            MaterialPageRoute(builder: (context) => IntroScreen()),
          );
        }
      },
    );
  }
}
