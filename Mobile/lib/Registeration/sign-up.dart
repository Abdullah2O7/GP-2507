import 'dart:convert';

import 'package:awesome_snackbar_content/awesome_snackbar_content.dart';
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:http/http.dart' as http;
import 'package:splash_onboarding_test/views/firebase_notifications/firebase_notifications.dart';

import '../helpers/show_snackbar.dart';
import '../nav_layout.dart';

import 'auth_service.dart';

class Signup extends StatefulWidget {
  const Signup({super.key});

  @override
  _SignupState createState() => _SignupState();
}

class _SignupState extends State<Signup> {
  final GlobalKey<FormState> formKey = GlobalKey<FormState>();

  final TextEditingController nameController = TextEditingController();
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  final TextEditingController confirmPasswordController =
      TextEditingController();
  final FirebaseNotifications _firebaseNotifications = FirebaseNotifications();
  bool isLoading = false;

  @override
  void dispose() {
    nameController.dispose();
    emailController.dispose();
    passwordController.dispose();
    confirmPasswordController.dispose();
    super.dispose();
  }

  String? _validateName(String? value) {
    if (value == null || value.isEmpty) {
      return 'Please enter your name';
    }
    return null;
  }

  String? _validateEmail(String? value) {
    if (value == null || value.isEmpty) {
      return 'Please enter your email';
    }
    String pattern = r"(?:[a-z0-9!#$%&'*+/=?^_`{|}~-]+(?:\.[a-z0-9!#$%&'"
        r'*+/=?^_`{|}~-]+)*|"(?:[\x01-\x08\x0b\x0c\x0e-\x1f\x21\x23-\x5b\x5d-'
        r'\x7f]|\\[\x01-\x09\x0b\x0c\x0e-\x7f])*")@(?:(?:[a-z0-9](?:[a-z0-9-]*'
        r'[a-z0-9])?\.)+[a-z0-9](?:[a-z0-9-]*[a-z0-9])?|\[(?:(?:(2(5[0-5]|[0-4]'
        r'[0-9])|1[0-9][0-9]|[1-9]?[0-9]))\.){3}(?:(2(5[0-5]|[0-4][0-9])|1[0-9]'
        r'[0-9]|[1-9]?[0-9])|[a-z0-9-]*[a-z0-9]:(?:[\x01-\x08\x0b\x0c\x0e-\x1f'
        r'\x21-\x5a\x53-\x7f]|\\[\x01-\x09\x0b\x0c\x0e-\x7f])+)\])';
    RegExp regex = RegExp(pattern);
    if (!regex.hasMatch(value)) {
      return 'Enter a valid email address';
    }
    return null;
  }

  String? _validatePassword(String? value) {
    if (value == null || value.isEmpty) {
      return 'Please enter your password';
    }
    String pattern =
        r'^(?=.*[a-z])(?=.*[A-Z])(?=.*\d)(?=.*[@$!%*?&])[A-Za-z\d@$!%*?&#]{8,}$';
    RegExp regex = RegExp(pattern);
    if (!regex.hasMatch(value)) {
      return 'Password must include at least one uppercase letter,\nlowercase letter, a number, and one special character.';
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

  Future<void> _registerUser() async {
    if (formKey.currentState!.validate()) {
      setState(() {
        isLoading = true;
      });

      String? fcmToken = await _firebaseNotifications.getTokenFromPreferences();
      if (fcmToken == null) {
        await _firebaseNotifications.initNotifications();
        fcmToken = await _firebaseNotifications.getTokenFromPreferences();
      }

      final String username = nameController.text.trim();
      final String email = emailController.text.trim();
      final String password = passwordController.text.trim();
      final String confirmPassword = confirmPasswordController.text.trim();

      Map<String, String> requestBody = {
        "username": username,
        "email": email,
        "password": password,
        "confirm_password": confirmPassword,
        "fcm_token": fcmToken!,
      };

      final url = Uri.parse('https://gpappapis.azurewebsites.net/api/register');

      try {
        final response = await http.post(
          url,
          headers: {"Content-Type": "application/json"},
          body: jsonEncode(requestBody),
        );
        print("Raw Response: ${response.body}"); // Print full response
        if (response.statusCode == 201) {
          final responseData = jsonDecode(response.body);
          print("Parsed Response: $responseData");

          final token = responseData['token'];
          final user = responseData['user'];
          final userId = user['user_id'];
          // Extract user_id from API response
          await AuthService.saveLoginInfo(
              token, email, user['username'], userId);

          showSnackbar(
            context,
            'Register Successful',
            'You have successfully sign up!',
            ContentType.success,
          );
          await Future.delayed(
            const Duration(seconds: 1),
          );
          Navigator.pushAndRemoveUntil(
            context,
            MaterialPageRoute(
              builder: (context) => const NavLayout(),
            ),
            (route) => false,
          );
        } else {
          showSnackbar(
            context,
            'Registration Failed',
            'Registration failed: ${response.body}',
            ContentType.failure,
          );
        }
      } catch (e) {
        showSnackbar(
          context,
          'Error',
          'An error occurred: $e',
          ContentType.failure,
        );
      } finally {
        setState(() {
          isLoading = false;
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFFFFAEF),
      appBar: AppBar(
        elevation: 0,
        //backgroundColor: Colors.transparent,
        backgroundColor: const Color.fromRGBO(0, 0, 0, 0),
        automaticallyImplyLeading: false,
        iconTheme: const IconThemeData(color: Colors.white),
        leading:  
         IconButton(
          icon: const Icon(Icons.arrow_back_ios),
          color: const Color(0xFF3B5D44),
          onPressed: () {
            Navigator.of(context).pop();//
            // Adjusted for a typical back operation
          },
          iconSize: 25.0,
          splashRadius: 25.0,
          tooltip: "Back",
        ),
        
      ),
      body: SingleChildScrollView(
        child: Form(
          key: formKey,
          child: Column(
            children: [
              const SizedBox(height: 80),
              const Center(
                child: Text(
                  'Welcome',
                  style: TextStyle(
                    color: Color(0xff537F5C),
                    fontSize: 40,
                    fontWeight: FontWeight.w800,
                    fontFamily: 'Martel-Black',
                  ),
                ),
              ),
              const SizedBox(height: 40),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 32),
                child: TextFormField(
                  controller: nameController,
                  autovalidateMode: AutovalidateMode.onUserInteraction,
                  validator: _validateName,
                  cursorColor:const Color(0xff537F5C),
                  style: const TextStyle(
                      color: Color(0xff537F5C), fontFamily: 'InriaSans-Light'),
                  decoration: const InputDecoration(
                    hoverColor: Color(0xff537F5C),
                    prefix: SizedBox(width: 1),
                    // labelText: 'Email',
                    hintText: 'Name',
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
                      borderSide: BorderSide(color: Colors.white),
                    ),
                  ),
                ),
              ),
              const SizedBox(
                height: 20,
              ),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 32),
                child: TextFormField(
                  controller: emailController,
                  autovalidateMode: AutovalidateMode.onUserInteraction,
                  validator: _validateEmail,
                  cursorColor:const Color(0xff537F5C),
                  style: const TextStyle(
                      color: Color(0xff537F5C), fontFamily: 'InriaSans-Light'),
                  decoration: const InputDecoration(
                    hoverColor: Color(0xff537F5C),
                    prefix: SizedBox(width: 1),
                    // labelText: 'Email',
                    hintText: 'Email',
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
                padding: const EdgeInsets.symmetric(horizontal: 32),
                child: TextFormField(
                  controller: passwordController,
                  obscureText: true, // Hides password input
                  autovalidateMode: AutovalidateMode.onUserInteraction,
                  validator: _validatePassword,
                  cursorColor:const Color(0xff537F5C),
                  style: const TextStyle(color: Color(0xff537F5C)),
                  decoration: const InputDecoration(
                    hoverColor: Color(0xff537F5C),
                    prefix: SizedBox(width: 1),
                    // labelText: 'Email',
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
                padding: const EdgeInsets.symmetric(horizontal: 32),
                child: TextFormField(
                  controller: confirmPasswordController,
                  obscureText: true, // Hides password input
                  autovalidateMode: AutovalidateMode.onUserInteraction,
                  validator: _validateConfirmPassword,
                  cursorColor:const Color(0xff537F5C),
                  style: const TextStyle(
                    color: Color(0xff537F5C),
                  ),
                  decoration: const InputDecoration(
                    hoverColor: Color(0xff537F5C),
                    prefix: SizedBox(width: 1),
                    // labelText: 'Email',
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
                  border: Border.all(width: 2, color:const Color(0xffFFFAEF)),
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
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(20),
                    ),
                    backgroundColor: const Color(0xff537F5C),
                  ),
                  
                  onPressed: isLoading ? null : _registerUser,
                  child: isLoading
                      ? const SpinKitDualRing(
                        
                          color: Color(0xff537F5C),
                          size: 30,
                          lineWidth: 5,
                        )
                      : const Text(
                          'Sign-up',
                          style: TextStyle(
                            fontSize: 20,
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
