import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:splash_onboarding_test/Registeration/auth_service.dart';
import 'package:splash_onboarding_test/Registeration/login.dart';
import 'package:splash_onboarding_test/Registeration/verification.dart';

Future<String?> getcookie() async {
  final String? cookie = await AuthService.getSessionCookie();
  if (cookie == null) {
    print('No cookie found');
  } else {
    print('Retrieved cookie: $cookie');
  }
  return cookie;
}

Future<void> resetPassword(String password, String confirmPassword) async {
  final cookie = await getcookie();

  var url = Uri.parse(
      'https://gpappapis.azurewebsites.net/api/resetPassword');

  var response = await http.post(
    url,
    headers: {
      'Content-Type': 'application/json',
      'Cookie': '$cookie',
    },
    body: jsonEncode({
      'password': password,
      'confirm_password': confirmPassword,
    }),
  );

  if (response.statusCode == 200) {
    var jsonResponse = jsonDecode(response.body);
    print(jsonResponse['message']);
  } else {
    print('Failed to reset password: ${response.body}');
  }
}

class Newpassword extends StatefulWidget {
  const Newpassword({super.key});

  @override
  _Newpassword createState() => _Newpassword();
}

class _Newpassword extends State<Newpassword> {
  final GlobalKey<FormState> formKey = GlobalKey<FormState>();

  final TextEditingController passwordController = TextEditingController();
  final TextEditingController confirmPasswordController =
      TextEditingController();

  @override
  void dispose() {
    passwordController.dispose();
    confirmPasswordController.dispose();
    super.dispose();
  }

  String? _validatePassword(String? value) {
    if (value == null || value.isEmpty) {
      return 'Please enter your password';
    }

    // Regular expression for strong password
    String pattern =
          r'^(?=.*[a-z])(?=.*[A-Z])(?=.*\d)(?=.*[@$!%*?&])[A-Za-z\d@$!%*?&#]{8,}$';
    RegExp regex = RegExp(pattern);

    if (!regex.hasMatch(value)) {
      return 'Password must be at least 8 characters long,\n include uppercase and lowercase letters,\n a number, and a special character';
    }

    return null;
  }

  String? _validateConfirmPassword(String? value) {
    if (value == null || value.isEmpty) {
      return 'Please confirm your password';
    }
    if (value != passwordController.text) {
      return 'Passwords do not match';
    }
    return null;
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
              MaterialPageRoute(
                  builder: (context) =>
                      const VerifyEmailScreen()), //this must be modified
            ); // Adjusted for a typical back operation
          },
          iconSize: 25.0,
          splashRadius: 25.0,
          tooltip: "Back",
        ),
        title: const Text(
          'Create new password',
          style: TextStyle(
              color: Color(0xff537F5C),
              fontSize: 24,
              fontWeight: FontWeight.w700,
              fontFamily: 'Inter'),
        ),
        titleSpacing: 30,
        centerTitle: true, // Ensure the title is centered
        backgroundColor: Colors.transparent,
        elevation: 0,
        scrolledUnderElevation: 0,
      ),
      body: SingleChildScrollView(
        child: Form(
          key: formKey,
          child: Column(
            children: [
              const SizedBox(height: 20),
              Image.asset(
                'assets/New-password.png', // Replace with your image path
                height: 270,
                width: 270,
              ),
              const SizedBox(height: 30),
              Text(
                'Please enter your new password below',
                style: TextStyle(
                  fontSize: 17,
                  color: Colors.white.withOpacity(.90),
                  fontFamily: 'Inter',
                ),
                textAlign: TextAlign.center,
              ),
              const SizedBox(
                height: 40,
              ),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 30),
                child: TextFormField(
                  controller: passwordController,
                  obscureText: true, // Hides password input
                  autovalidateMode: AutovalidateMode.onUserInteraction,
                  validator: _validatePassword,
                  cursorColor: const Color(0xff537F5C),
                   style: const TextStyle(color: Color(0xff537F5C),),
                  decoration: const InputDecoration(
                    hoverColor: Color(0xff537F5C),
                    prefix: SizedBox(width: 1),
                    hintText: 'Password',
                    hintStyle: TextStyle(
                      color: Color(0xff537F5C),
                      fontSize: 16,
                      fontFamily: 'InriaSans-Regular',
                    ),
                    enabledBorder: UnderlineInputBorder(
                      borderSide: BorderSide(
                          color: Color(0xff537F5C)), // Normal border color
                    ),
                    focusedBorder: UnderlineInputBorder(
                      borderSide: BorderSide(color: Color(0xff537F5C)),
                    ),
                  ),
                ),
              ),
              const SizedBox(
                height: 20,
              ),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 30),
                child: TextFormField(
                  controller: confirmPasswordController,
                  obscureText: true, // Hides password input
                  autovalidateMode: AutovalidateMode.onUserInteraction,
                  validator: _validateConfirmPassword,
                  cursorColor: const Color(0xff537F5C),
                   style: const TextStyle(color: Color(0xff537F5C),),
                  decoration: const InputDecoration(
                    hoverColor: Color(0xff537F5C),
                    prefix: SizedBox(width: 1),
                    hintText: 'Confirm Password',
                    hintStyle: TextStyle(
                      color: Color(0xff537F5C),
                      fontSize: 16,
                      fontFamily: 'InriaSans-Regular',
                    ),
                    enabledBorder: UnderlineInputBorder(
                      borderSide: BorderSide(
                          color: Color(0xff537F5C)), // Normal border color
                    ),
                    focusedBorder: UnderlineInputBorder(
                      borderSide: BorderSide(color: Color(0xff537F5C)),
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 60),
              Container(
                width: 270,
                height: 50,
                decoration: BoxDecoration(
                  border: Border.all(width: 1, color:const Color(0xffFFFAEF)),
                  borderRadius: BorderRadius.circular(20),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(.25),
                      spreadRadius: 0,
                      blurRadius: 4,
                      offset: const Offset(0, 4),
                    ),
                  ],
                ),
                child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xff537F5C),
                    shadowColor: const Color(0xff537F5C),
                    alignment: Alignment.center,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(20),
                    ),
                  ),
                  onPressed: () async {
                    if (formKey.currentState!.validate()) {
                      await resetPassword(passwordController.text,
                          confirmPasswordController.text);
                      Navigator.push(
                        context,
                        MaterialPageRoute(builder: (context) => const Login()),
                      );
                    }
                  },
                  child: const Text(
                    'Save',
                    style: TextStyle(
                      fontSize: 25,
                      color: Color(0xffFFFAEF),
                      fontFamily: 'InriaSans-Bold',
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
