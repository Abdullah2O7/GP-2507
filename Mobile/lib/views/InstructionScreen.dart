import 'package:flutter/material.dart';
import 'package:introduction_screen/introduction_screen.dart';
import 'package:splash_onboarding_test/Registeration/registeration.dart';

class IntroScreen extends StatelessWidget {
  IntroScreen({super.key});

  final List<PageViewModel> pages = [];

  @override
  Widget build(BuildContext context) {
    // Get screen height and width for responsive sizing
    double screenHeight = MediaQuery.of(context).size.height;
    double screenWidth = MediaQuery.of(context).size.width;

    // Initialize pages with responsive sizing
    final List<PageViewModel> pages = [
      PageViewModel(
        titleWidget: Padding(
          padding: EdgeInsets.only(top: screenHeight * 0.2),
          child: Text(
            'Welcome to MALAZ',
            style: TextStyle(
              fontSize: 24,
              fontWeight: FontWeight.w500,
              color: Colors.white.withOpacity(.85),
              fontFamily: 'Ledger',
            ),
            textAlign: TextAlign.center,
          ),
        ),
        bodyWidget: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            SizedBox(
              height: screenHeight * 0.05,
            ),
            Padding(
              padding: EdgeInsets.only(left: screenWidth * 0.05),
              child: Image.asset(
                'assets/onBoarding.png',
                width: screenWidth * 0.8,
              ),
            ),
            SizedBox(
              height: screenHeight * 0.1,
            ),
            const Text(
              'your personal mental\nwellness companion',
              style: TextStyle(
                color: Colors.white,
                fontSize: 18,
                fontFamily: 'Ledger',
              ),
              textAlign: TextAlign.center,
            ),
          ],
        ),
        decoration: const PageDecoration(
          pageColor: Color(0xFF537F5C),
          titlePadding: EdgeInsets.all(0),
          contentMargin: EdgeInsets.all(16),
          bodyPadding: EdgeInsets.only(top: 0),
        ),
      ),
      PageViewModel(
        title: '',
        bodyWidget: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Stack(
              alignment: Alignment.center,
              children: [
                Image.asset(
                  'assets/updateintro.png',
                  fit: BoxFit.contain,
                ),
                Text(
                  'Our app is designed\nto help you \nunderstand and\n manage your mental health\nthrough a variety of \ndiagnostic tests',
                  style: TextStyle(
                    fontFamily: 'Ledger',
                    fontSize: screenWidth * 0.06,
                    color: Colors.white,
                  ),
                  textAlign: TextAlign.center,
                ),
              ],
            ),
          ],
        ),
        decoration: const PageDecoration(
          pageColor: Color(0xFF537F5C),
        ),
      ),
      PageViewModel(
        title: '',
        bodyWidget: Padding(
          padding: EdgeInsets.symmetric(horizontal: screenWidth * 0.04),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Row(children: [
                Image.asset(
                  'assets/introonboarding1.png',
                  height: screenHeight * 0.14,
                ),
                SizedBox(
                  width: screenWidth * 0.2,
                ),
                Text(
                  'Take\n   a\n test',
                  style: TextStyle(
                    fontSize: 25,
                    fontWeight: FontWeight.w400,
                    color: Colors.white.withOpacity(.85),
                    fontFamily: 'Ledger',
                  ),
                ),
              ]),
              // SizedBox(height: screenHeight * 0.0001),
              Image.asset(
                'assets/Line27.png',
              ),
              Row(
                children: [
                  Text(
                    '   Look at \n       the\n Guidelines',
                    style: TextStyle(
                      fontSize: 23,
                      fontWeight: FontWeight.w400,
                      color: Colors.white.withOpacity(.85),
                      fontFamily: 'Ledger',
                    ),
                  ),
                  const Spacer(),
                  Image.asset('assets/introonboarding2.png',
                      height: screenHeight * 0.14),
                ],
              ),
              SizedBox(height: screenHeight * 0.01),
              Image.asset(
                'assets/Line 28.png',
              
              ),
              Row(
                children: [
                  Image.asset('assets/introonboarding3.png',
                      height: screenHeight *  0.14),
                  const Spacer(),
                  Text(
                    'Write what\n you think',
                    style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.w400,
                      color: Colors.white.withOpacity(.85),
                      fontFamily: 'Ledger',
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
        decoration: const PageDecoration(
          pageColor: Color(0xFF537F5C),
        ),
      ),
      PageViewModel(
        title: '',
        bodyWidget: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            SizedBox(height: screenHeight * 0.05),
            Stack(
              alignment: Alignment.center,
              children: [
                Image.asset(
                  'assets/intro4.png',
                  fit: BoxFit.contain,
                ),
                Text(
                  ' Your\n Journey\n Starts\n  Now',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: screenWidth * 0.08,
                    fontWeight: FontWeight.w500,
                    fontFamily: 'Ledger',
                  ),
                  textAlign: TextAlign.center,
                ),
              ],
            ),
          ],
        ),
        decoration: const PageDecoration(
          pageColor: Color(0xFF537F5C),
        ),
      ),
    ];

    return Scaffold(
      body: IntroductionScreen(
        globalBackgroundColor: const Color(0xFF537F5C),
        pages: pages,
        dotsDecorator: DotsDecorator(
          size: Size(screenWidth * 0.03, screenWidth * 0.03),
          color: Colors.white,
          activeSize: Size.square(screenWidth * 0.04),
          activeColor: Colors.grey,
        ),
        showDoneButton: true,
        done: Text(
          'Done',
          style: TextStyle(fontSize: screenWidth * 0.05, color: Colors.white),
        ),
        showSkipButton: true,
        skip: Text(
          'Skip',
          style: TextStyle(fontSize: screenWidth * 0.05, color: Colors.white),
        ),
        showNextButton: false,
        onDone: () => onDone(context),
        onSkip: () => onSkip(context),
      ),
    );
  }

  void onDone(context) {
    Navigator.pushReplacement(context,
        MaterialPageRoute(builder: (context) => const Registeration()));
  }

  void onSkip(context) {
    Navigator.pushReplacement(context,
        MaterialPageRoute(builder: (context) => const Registeration()));
  }
}
