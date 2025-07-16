import 'package:flutter/material.dart';
import 'package:splash_onboarding_test/Registeration/login.dart';
import 'package:splash_onboarding_test/Registeration/sign-up.dart';
import 'package:splash_onboarding_test/nav_layout.dart';

import 'auth_service.dart'; // Import the AuthService

class Registeration extends StatelessWidget {
  const Registeration({super.key});

  void _continueAsGuest(BuildContext context) async {
    await AuthService.saveLoginInfo("", "", "","", isGuest: true);
    //set
    await AuthService.setIsGuest(true);
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(builder: (context) => const NavLayout()),
    );
  }

  @override
  Widget build(BuildContext context) {
    // Get screen width and height
    final screenWidth = MediaQuery.of(context).size.width;
    final screenHeight = MediaQuery.of(context).size.height;

    return Scaffold(
      backgroundColor: const Color(0xFFFFFAEF),
      body: SingleChildScrollView(
        child: Column(
          children: [
            Stack(
              children: [
                Image.asset(
                  'assets/Rectangle 32.png',
                  width: screenWidth,
                  height: screenHeight * 0.6, // 40% of screen height
                  fit: BoxFit.cover,
                ),
                Padding(
                  padding: EdgeInsets.all(screenWidth * 0.15), // 15% padding
                  child: Image.asset(
                    'assets/registeration.png',
                    height: screenHeight * 0.35, // 35% of screen height
                    width: screenWidth * 0.8, // 80% of screen width
                  ),
                ),
                Positioned(
                  top: screenHeight * 0.36, // 33% of screen height
                  left: 0,
                  right: 0,
                  child: Center(
                    child: Text(
                      'MALAZ',
                      style: TextStyle(
                        fontFamily: 'Ledger',
                        fontSize: screenWidth * 0.08, // 8% of screen width
                        fontWeight: FontWeight.w500,
                        color: Colors.white.withOpacity(0.8),
                        letterSpacing: screenWidth * 0.01, // 1% of screen width
                      ),
                    ),
                  ),
                ),
              ],
            ),
            SizedBox(height: screenHeight * 0.03), // 2% of screen height
            Container(
              width: screenWidth * 0.716, // 70% of screen width
              height: screenHeight * 0.054, // 7% of screen height
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(20),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.25),
                    spreadRadius: 0,
                    blurRadius: 4,
                    offset: const Offset(0, 4),
                  ),
                ],
              ),
              child: ElevatedButton(
                style: ElevatedButton.styleFrom(
                  alignment: Alignment.center,
                  backgroundColor: const Color(0xff537F5C),
                ),
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => const Login(),
                    ),
                  );
                },
                child: const Text(
                  'Log in',
                  style: TextStyle(
                    fontSize: 18, // 6% of screen width
                    color: Colors.white,
                    fontFamily: 'InriaSans-Bold',
                  ),
                ),
              ),
            ),
            SizedBox(height: screenHeight * 0.03), // 3% of screen height
            Container(
              width: screenWidth * 0.716, // 70% of screen width
              height: 44, // 7% of screen height
              decoration: BoxDecoration(
                border: Border.all(width: 2, color: const Color(0xff537F5C)),
                borderRadius: BorderRadius.circular(20),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.25),
                    spreadRadius: 0,
                    blurRadius: 4,
                    offset: const Offset(0, 4),
                  ),
                ],
              ),
              child: ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor:const Color(0xffFFFAEF),
                  alignment: Alignment.center,
                  shadowColor: const Color(0xff537F5C),
                ),
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => const Signup()),
                  );
                },
                child: const Text(
                  'Sign-up',
                  style: TextStyle(
                    fontSize: 18, // 6% of screen width
                    color: Color(0xff537F5C),
                    fontFamily: 'InriaSans-Bold',
                  ),
                ),
              ),
            ),
            SizedBox(height: screenHeight * 0.03), // 3% of screen height
            const Row(
              children: [
                Expanded(
                  child: Divider(
                    color: Colors.black,
                    thickness: 1,
                    indent: 30,
                    endIndent: 10,
                  ),
                ),
                Padding(
                  padding: EdgeInsets.symmetric(horizontal: 10.0),
                  child: Text(
                    'OR',
                    style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                  ),
                ),
                Expanded(
                  child: Divider(
                    color: Colors.black,
                    thickness: 1,
                    indent: 10,
                    endIndent: 30,
                  ),
                ),
              ],
            ),
            SizedBox(height: screenHeight * 0.03), // 3% of screen height
            Container(
              width: screenWidth * 0.716, // 70% of screen width
              height: 44, // 7% of screen height
              decoration: BoxDecoration(
                border: Border.all(width: 2, color: const Color(0xff537F5C)),
                borderRadius: BorderRadius.circular(20),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.25),
                    spreadRadius: 0,
                    blurRadius: 4,
                    offset: const Offset(0, 4),
                  ),
                ],
              ),
              child: ElevatedButton(
                style: ElevatedButton.styleFrom(
                  alignment: Alignment.center,
                  backgroundColor:const Color(0xffFFFAEF),
                  shadowColor: const Color(0xff537F5C),
                ),
                onPressed: () {
                  _continueAsGuest(context);
                },
                child: const Text(
                  'Continue as a guest',
                  style: TextStyle(
                    fontSize: 18, // 6% of screen width
                    color: Color(0xff537F5C),
                    fontFamily: 'InriaSans-Bold',
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
