import 'package:flutter/material.dart';
import 'package:splash_onboarding_test/Registeration/login.dart';
import 'package:splash_onboarding_test/Registeration/verification.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:splash_onboarding_test/Registeration/auth_service.dart';

class Forgetpassword extends StatefulWidget {
  const Forgetpassword({super.key});

  @override
  State<Forgetpassword> createState() => _ForgetpasswordState();
}

class _ForgetpasswordState extends State<Forgetpassword> {
  String? email;

  GlobalKey<FormState> formstate = GlobalKey();

  // Function to validate email
  String? _validateEmail(String? value) {
    if (value == null || value.isEmpty) {
      return 'Please enter your email';
    }

    String pattern = r"(?:[a-z0-9!#$%&'*+/=?^_`{|}~-]+(?:\.[a-z0-9!#$%&'"
        r'*+/=?^_`{|}~-]+)*|"(?:[\x01-\x08\x0b\x0c\x0e-\x1f\x21\x23-\x5b\x5d-'
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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFFFFAEF),
      appBar: AppBar(
        automaticallyImplyLeading: false,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios),
          color: const Color(0xFF3B5D44),
          onPressed: () {
            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => const Login()),
            ); // Adjusted for a typical back operation
          },
          iconSize: 25.0,
          splashRadius: 25.0,
          tooltip: "Back",
        ),
        title: const Text(
          'Forget password',
          style: TextStyle(
              color: Color(0xff537F5C),
              fontSize: 24,
              fontWeight: FontWeight.w700,
              fontFamily: 'Inter'),
        ),
        centerTitle: true, // Ensure the title is centered
        backgroundColor: Colors.transparent,
        elevation: 0,
        scrolledUnderElevation: 0,
      ),
      body: SingleChildScrollView(
        child: Form(
          key: formstate,
          child: Column(
            //crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              const SizedBox(height: 20),
              Image.asset(
                'assets/Forget Password.png',
                height: 270,
                width: 270,
              ),
              const SizedBox(height: 30),
              const Text(
                'No worries! Just enter your email\naddress below, and we’ll send you\na Verification code to reset your\n                 password.',
                style: TextStyle(
                    color: Color(0xff537F5C),
                    fontSize: 17,
                    fontFamily: 'Inter'),
              ),
              const SizedBox(height: 30),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 32),
                child: TextFormField(
                  autovalidateMode: AutovalidateMode.onUserInteraction,
                  onSaved: (val) {
                    email = val;
                  },
                  validator: _validateEmail,
                  cursorColor: const Color(0xff537F5C),
                  style: const TextStyle(
                      color: Color(0xff537F5C), fontFamily: 'InriaSans-Light'),
                  decoration: const InputDecoration(
                    hoverColor: Color(0xff537F5C),
                    prefix: SizedBox(width: 1),
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
              const SizedBox(height: 70),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20.0),
                child: Container(
                  width: 270,
                  height: 44,
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
                      if (formstate.currentState!.validate()) {
                        formstate.currentState!.save();
                        try {
                          var response = await http.post(
                            Uri.parse(
                                'https://gpappapis.azurewebsites.net/api/verify'),
                            headers: {
                              'Content-Type': 'application/json',
                            },
                            body: jsonEncode({'email': email}),
                          );

                          // Parse the response
                          var responseBody = jsonDecode(response.body);

                          // Check if verification code was sent
                          if (response.statusCode == 200 &&
                              responseBody['message'] ==
                                  'Verification code sent to your email') {
                            String? setCookie = response.headers['set-cookie'];
                            print(setCookie);

                            if (setCookie != null) {
                              List<String> cookies = setCookie.split(',');

                              String? sessionValue;
                              String? emailValue =
                                  email; // Use the saved email value
                              for (var cookie in cookies) {
                                cookie = cookie.trim();
                                if (cookie.contains('session=')) {
                                  sessionValue =
                                      cookie.split('session=')[1].split(';')[0];
                                  break;
                                }
                              }

                              if (sessionValue != null) {
                                // Create the combined string
                                String combinedString =
                                    'email=$emailValue; session=$sessionValue';
                                print('Combined String: $combinedString');

                                await AuthService.saveSessionCookie(
                                    combinedString);
                              } else {
                                print('Session cookie not found');
                              }
                            }

                            // Show success message
                            ScaffoldMessenger.of(context).showSnackBar(
                              const SnackBar(
                                  content: Text(
                                      'Verification code sent to your email')),
                            );

                            // Navigate to the VerifyEmailScreen
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) =>
                                      const VerifyEmailScreen()),
                            );
                          } else {
                            // Handle other responses
                            ScaffoldMessenger.of(context).showSnackBar(
                              const SnackBar(
                                  content:
                                      Text('Failed to send verification code')),
                            );
                          }
                        } catch (e) {
                          // Handle exceptions (like network errors)
                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(content: Text('An error occurred: $e')),
                          );
                        }
                      }
                    },
                    child: const Text(
                      'Send',
                      style: TextStyle(
                        fontSize: 25,
                        color: Color(0xffFFFAEF),
                        fontFamily: 'InriaSans-Bold',
                      ),
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
