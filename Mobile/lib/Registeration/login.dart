// ignore_for_file: use_build_context_synchronously

import 'dart:convert';


import 'package:awesome_snackbar_content/awesome_snackbar_content.dart';
import 'package:device_info_plus/device_info_plus.dart';
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:http/http.dart' as http;
import 'package:splash_onboarding_test/Registeration/forgetpassword.dart';
import 'package:splash_onboarding_test/Registeration/registeration.dart';
import 'package:splash_onboarding_test/views/firebase_notifications/firebase_notifications.dart';

import '../helpers/show_snackbar.dart';
import '../nav_layout.dart';
import 'auth_service.dart'; // Import your AuthService
// Import the FirebaseNotifications class

class Login extends StatefulWidget {
  const Login({super.key});

  @override
  State<Login> createState() => _LoginState();
}

class _LoginState extends State<Login> {
  String? email;
  String? password;
  GlobalKey<FormState> formstate = GlobalKey();
  final FirebaseNotifications _firebaseNotifications = FirebaseNotifications();
  bool isLoading = false; // Add isLoading variable

  String? _validateEmail(String? value) {
    if (value == null || value.isEmpty) {
      return 'Please enter your email';
    }
    String pattern = r"(?:[a-z0-9!#$%&'*+/=?^_{|}~-]+(?:\.[a-z0-9!#$%&'"
        r'*+/=?^_{|}~-]+)*|"(?:[\x01-\x08\x0b\x0c\x0e-\x1f\x21\x23-\x5b\x5d-'
        r'\x7f]|\\[\x01-\x09\x0b\x0c\x0e-\x7f])*")@(?:(?:[a-z0-9](?:[a-z0-9-]*'
        r'[a-z0-9])?\.)+[a-z0-9](?:[a-z0-9-]*[a-z0-9])?|\[(?:(?:(2(5[0-5]|[0-4]'
        r'[0-9])|1[0-9][0-9]|[1-9]?[0-9]))\.){3}(?:(2(5[0-5]|[0-4][0-9])|1[0-9]'
        r'[0-9]|[1-9]?[0-9])|[a-z0-9-]*[a-z0-9]:(?:[\x01-\x08\x0b\x0c\x0e-\x1f\'
        r'x21-\x5a\x53-\x7f]|\\[\x01-\x09\x0b\x0c\x0e-\x7f])+)\])';
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
    if (value.length < 6) {
      return 'Password must be at least 6 characters long';
    }
    return null;
  }

  Future<void> _login() async {
    setState(() {
      isLoading = true;
    });

    await FirebaseNotifications().logout();
    final url = Uri.parse('https://gpappapis.azurewebsites.net/api/login');

    DeviceInfoPlugin deviceInfo = DeviceInfoPlugin();
    String phoneType = '';
    if (Theme.of(context).platform == TargetPlatform.android) {
      AndroidDeviceInfo androidInfo = await deviceInfo.androidInfo;
      phoneType = androidInfo.model;
    } else if (Theme.of(context).platform == TargetPlatform.iOS) {
      IosDeviceInfo iosInfo = await deviceInfo.iosInfo;
      phoneType = iosInfo.utsname.machine;
    }

    String? fcmToken = await _firebaseNotifications.getTokenFromPreferences();
    if (fcmToken == null) {
      await FirebaseNotifications().initNotifications();
      fcmToken = await _firebaseNotifications.getTokenFromPreferences();
    }

    final Map<String, String> requestBody = {
      "email": email!,
      "password": password!,
      "phone": phoneType,
      "fcm_token": fcmToken!,
    };

    try {
      final response = await http.post(
        url,
        headers: {
          "Content-Type": "application/json",
        },
        body: jsonEncode(requestBody),
      );

      if (response.statusCode == 200) {
        final responseData = jsonDecode(response.body);

        print("====================================${response.body}");
        final token = responseData['token'];
        final user = responseData['user'];
        //log("======================${responseData}");

        if (token != null && token.isNotEmpty) {
          final userId = user['user_id']; // Extract user_id from API response
          await AuthService.saveLoginInfo(
              token, email!, user['username'], userId);

          showSnackbar(
            context,
            'Login Successful',
            'You have successfully logged in!',
            ContentType.success,
          );
          await Future.delayed(
            const Duration(seconds: 1),
          );
          Navigator.pushAndRemoveUntil(
            context,
            MaterialPageRoute(builder: (context) => const NavLayout()),
            (route) => false,
          );
        } else {
          showSnackbar(
            context,
            'Error',
            'Invalid token received from the server!',
            ContentType.failure,
          );
        }
      } else {
        showSnackbar(
          context,
          'Login Failed',
          'Invalid email or password!',
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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFFFFAEF),
      appBar: AppBar(
        backgroundColor: const Color.fromRGBO(0, 0, 0, 0),
        automaticallyImplyLeading: false,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios),
          color: const Color(0xFF3B5D44),
          onPressed: () {
            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => const Registeration()),
            ); // Adjusted for a typical back operation
          },
          iconSize: 25.0,
          splashRadius: 25.0,
          tooltip: "Back",
        ),
      ),
      body: SingleChildScrollView(
        child: Form(
          key: formstate,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              const SizedBox(height: 105),
              const Center(
                child: Text(
                  'Welcome back',
                  style: TextStyle(
                    color: Color(0xff537F5C),
                    fontSize: 35,
                    fontWeight: FontWeight.w800,
                    fontFamily: 'Martel-Black',
                  ),
                ),
              ),
              const SizedBox(height: 55),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 32),
                child: TextFormField(
                  autovalidateMode: AutovalidateMode.onUserInteraction,
                  onSaved: (val) {
                    email = val;
                  },
                  validator: _validateEmail,
                  cursorColor:const Color(0xff537F5C),
                  style: const TextStyle(
                      color:  Color(0xff537F5C),
                      fontFamily: 'InriaSans-Light',
                      fontSize: 16),
                  decoration: const InputDecoration(
                    hintText: 'Email',
                    hintStyle: TextStyle(
                      color:  Color(0xff537F5C),
                      fontSize: 16,
                      fontFamily: 'InriaSans-Regular',
                    ),
                    enabledBorder: UnderlineInputBorder(
                      borderSide: BorderSide(color: Color(0xff537F5C)),
                    ),
                    focusedBorder: UnderlineInputBorder(
                      borderSide: BorderSide(color: Color(0xff537F5C)),
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 30),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 32),
                child: TextFormField(
                  obscureText: true,
                  autovalidateMode: AutovalidateMode.onUserInteraction,
                  onSaved: (val) {
                    password = val;
                  },
                  validator: _validatePassword,
                  cursorColor:  const Color(0xff537F5C),
                  style: const TextStyle(
                    color: Color(0xff537F5C),
                  ),
                  decoration: const InputDecoration(
                    hintText: 'Password',
                    hintStyle: TextStyle(
                      color: Color(0xff537F5C),
                      fontSize: 16,
                      fontFamily: 'InriaSans-Regular',
                    ),
                    enabledBorder: UnderlineInputBorder(
                      borderSide: BorderSide(color: Color(0xff537F5C)),
                    ),
                    focusedBorder: UnderlineInputBorder(
                      borderSide: BorderSide(color: Color(0xff537F5C)),
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 15),
              GestureDetector(
                child: Container(
                  margin: const EdgeInsets.only(left: 172),
                  child: const Text(
                    'Forgot your password?',
                    style: TextStyle(
                      decoration: TextDecoration.underline,
                      decorationColor: Color(0xff537F5C),
                      color: Color(0xff537F5C),
                      fontSize: 14,
                      fontFamily: 'InriaSans-Regular',
                    ),
                  ),
                ),
                onTap: () {
                  Navigator.of(context).push(
                    MaterialPageRoute(
                      builder: (context) => const Forgetpassword(),
                    ),
                  );
                },
              ),
              const SizedBox(height: 65),
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
                    backgroundColor: const Color(0xff537F5C),
                    shadowColor: const Color(0xff537F5C),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(20),
                    ),
                  ),
                  onPressed: isLoading
                      ? null
                      : () async {
                          var formdata = formstate.currentState;
                          if (formdata!.validate()) {
                            formdata.save();
                            await AuthService.setIsGuest(false);
                            //set is login true
                            await AuthService.setIsLoggedIn(true);
                            await _login();
                          }
                        },
                  child: isLoading
                      ? const SpinKitDualRing(
                          color: Color(0xff537F5C),
                          size: 30,
                          lineWidth: 5,
                        )
                      : const Text(
                          'Login',
                          style: TextStyle(
                            color: Color(0xffFFFAEF),
                            fontSize: 20,
                            fontFamily: 'InriaSans-Regular',
                            fontWeight: FontWeight.w700,
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
