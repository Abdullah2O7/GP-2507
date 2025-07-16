//import 'dart:io';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:pin_code_fields/pin_code_fields.dart';
import 'package:splash_onboarding_test/Registeration/forgetpassword.dart';
import 'package:splash_onboarding_test/Registeration/newPassword.dart';
import 'package:splash_onboarding_test/Registeration/auth_service.dart';

class VerifyEmailScreen extends StatefulWidget {
  const VerifyEmailScreen({super.key});

  @override
  _VerifyEmailScreenState createState() => _VerifyEmailScreenState();
}

Future<String?> getcookie() async {
  final String? cookie = await AuthService.getSessionCookie();
  if (cookie == null) {
    print('No cookie found');
  } else {
    print('Retrieved cookie: $cookie');
  }
  return cookie;
}

class _VerifyEmailScreenState extends State<VerifyEmailScreen> {
  String verificationCode = "";

  void verifyCode() async {
    final cookie = await getcookie();
    try {
      var response = await http.post(
        Uri.parse(
            'https://gpappapis.azurewebsites.net/api/resetPasswordInternal'),
        headers: {
          'Content-Type': 'application/json',
          'Cookie': '$cookie',
        },
        body: jsonEncode({
          'verification_code': verificationCode, // Send the entered code
        }),
      );
      print(verificationCode);
      print(verificationCode.runtimeType == String);
      var responseBody = jsonDecode(response.body);
      print(responseBody);

      // Add this to see the full response from the backend
      if (response.statusCode == 200 &&
          responseBody['message'] ==
              'Verification successful, proceed to reset password.') {
        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => const Newpassword()),
        );
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
              content: Text('Invalid verification code. Please try again.')),
        );
      }
    } catch (e) {
      // Handle errors (like network issues)
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('An error occurred: $e')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFFFFAEF),
      appBar: AppBar(
        automaticallyImplyLeading: false,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios),
          color: const Color(0xFF537F5C),
          onPressed: () {
            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => const Forgetpassword()),
            );
          },
          iconSize: 25.0,
          splashRadius: 25.0,
          tooltip: "Back",
        ),
        title: const Text(
          'Verify your email',
          style: TextStyle(
              color: Color(0xff537F5C),
              fontSize: 24,
              fontWeight: FontWeight.w700,
              fontFamily: 'Inter'),
        ),
        centerTitle: true,
        backgroundColor: Colors.transparent,
        elevation: 0,
        scrolledUnderElevation: 0,
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 24.0),
        child: SingleChildScrollView(
          child: Column(
            children: [
              const SizedBox(height: 20),
              Image.asset(
                'assets/verification.png',
                height: 250,
                width: 250,
              ),
              const SizedBox(height: 40),
              const Text(
                'Please enter the 4-digit code we sent to your email',
                style: TextStyle(
                  color: Color(0xff537F5C),
                  fontSize: 16,
                  fontFamily: 'Inter',
                ),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 40),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 25),
                child: PinCodeTextField(
                  appContext: context,
                  length: 4,
                  obscureText: false,
                  animationType: AnimationType.fade,
                  textStyle: const TextStyle(color: Color(0xff537F5C)),
                  pinTheme: PinTheme(
                    shape: PinCodeFieldShape.box,
                    borderRadius: BorderRadius.circular(20),
                    fieldHeight: 60,
                    fieldWidth: 60,
                    activeFillColor: Colors.transparent,
                    inactiveFillColor: Colors.white30,
                    selectedFillColor: Colors.white,
                    activeColor: const Color(0xff537F5C),
                    inactiveColor: const Color(0xff537F5C),
                    selectedColor: const Color(0xff537F5C),
                  ),
                  animationDuration: const Duration(milliseconds: 300),
                  //backgroundColor: const Color(0xFF537F5C),
                  enableActiveFill: true,
                  onCompleted: (v) {
                    setState(() {
                      verificationCode = v;
                    });

                    print(
                        "Entered Verification Code: $verificationCode"); // Debugging step

                    // Check if entered code matches your hardcoded code
                  },
                  onChanged: (value) {
                    // Handle changes if necessary
                  },
                  beforeTextPaste: (text) {
                    return true;
                  },
                ),
              ),
              const SizedBox(height: 10),
              TextButton(
                onPressed: () {
                  // Add resend code logic here
                },
                child: const Text(
                  'Resend code',
                  style: TextStyle(
                    color: Color(0xff537F5C),
                    fontSize: 16,
                    fontFamily: 'Inter',
                    decoration: TextDecoration.underline,
                    decorationColor: Color(0xff537F5C),
                  ),
                ),
              ),
              const SizedBox(height: 40),
              Container(
                width: 270,
                height: 44,
                decoration: BoxDecoration(
                    border:
                        Border.all(width: 1, color: const Color(0xffFFFAEF)),
                    borderRadius: BorderRadius.circular(20),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withOpacity(.25),
                        spreadRadius: 0,
                        blurRadius: 4,
                        offset: const Offset(0, 4),
                      )
                    ]),
                child: ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      alignment: Alignment.center,
                      backgroundColor: const Color(0xff537F5C),
                    ),
                    onPressed: () {
                      verifyCode(); // Call the verification function
                    },
                    child: const Text(
                      'Verify',
                      style: TextStyle(
                          fontSize: 25,
                          color: Color(0xffFFFAEF),
                          fontFamily: 'InriaSans-Bold'),
                    )),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
