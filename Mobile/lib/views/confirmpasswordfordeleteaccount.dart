import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:splash_onboarding_test/Registeration/auth_service.dart';
import 'package:splash_onboarding_test/Registeration/registeration.dart';

class Confirmpasswordfordeleteaccount extends StatefulWidget {
  const Confirmpasswordfordeleteaccount({super.key});

  @override
  _Confirmpasswordfordeleteaccount createState() =>
      _Confirmpasswordfordeleteaccount();
}

class _Confirmpasswordfordeleteaccount
    extends State<Confirmpasswordfordeleteaccount> {
  final GlobalKey<FormState> formKey = GlobalKey<FormState>();

  final TextEditingController passwordController = TextEditingController();

  @override
  void dispose() {
    passwordController.dispose();

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

  Future<String?> getToken() async {
    final String? token = await AuthService.getToken();
    if (token == null) {
      print('No token found');
    } else {
      print('Retrieved Token: $token');
    }
    return token;
  }

  Future<void> _deleteAccount() async {
    final token = await getToken();
    const String apiUrl =
        'https://gpappapis.azurewebsites.net/api/delete-account';

    try {
      final response = await http.delete(
        Uri.parse(apiUrl),
        headers: {
          'Authorization': '$token', // Ensure the token is correctly prefixed
          'Content-Type': 'application/json',
        },
        body: jsonEncode({
          'password': passwordController.text, // Use user's input
        }),
      );
      print(response.statusCode);

      if (response.statusCode == 200) {
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (context) => const Registeration()),
        );
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content:
                Text('Failed to delete account. Please check your password.'),
          ),
        );
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Error occurred: $e'),
        ),
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
            Navigator.pop(
              context,
            );
          },
          iconSize: 25.0,
          splashRadius: 25.0,
          tooltip: "Back",
        ),
        title: const Text(
          'Confirm password For deleting',
          style: TextStyle(
              color: Color(0xFF537F5C),
              fontSize: 17,
              fontWeight: FontWeight.w700,
              fontFamily: 'Inter'),
        ),
        titleSpacing: 30,
        centerTitle: true,
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
                'assets/New-password.png',
                height: 270,
                width: 270,
              ),
              const SizedBox(height: 30),
              const Text(
                'Please enter your password ',
                style: TextStyle(
                    fontSize: 17,
                    color: Color(0xFF537F5C),
                    fontFamily: 'Inter'),
              ),
              const SizedBox(
                height: 50,
              ),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 30),
                child: TextFormField(
                  controller: passwordController,
                  obscureText: true,
                  autovalidateMode: AutovalidateMode.onUserInteraction,
                  validator: _validatePassword,
                  cursorColor: const Color(0xff537F5C),
                  style: const TextStyle(color: Color(0xff537F5C)),
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
              const SizedBox(height: 60),
              Container(
                width: 270,
                height: 44,
                decoration: BoxDecoration(
                  border: Border.all(width: 1, color: const Color(0xffFFFAEF)),
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
                      await _deleteAccount();
                    }
                  },
                  child: const Text(
                    'Confirm',
                    style: TextStyle(
                      fontSize: 28,
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
