import 'dart:convert';

import 'package:awesome_snackbar_content/awesome_snackbar_content.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:http/http.dart' as http;

import 'package:splash_onboarding_test/widgets/custom_app_bar.dart';

import '../helpers/show_snackbar.dart';
import 'ConatctUspage/contactUsPage.dart';

class Getintouch extends StatefulWidget {
  const Getintouch({super.key});

  @override
  _Getintouch createState() => _Getintouch();
}

class _Getintouch extends State<Getintouch> {
  final GlobalKey<FormState> formKey = GlobalKey<FormState>();

  final TextEditingController firstNameController = TextEditingController();
  final TextEditingController lastNameController = TextEditingController();
  final TextEditingController emailController = TextEditingController();
  final TextEditingController messageController = TextEditingController();

  @override
  void dispose() {
    firstNameController.dispose();
    lastNameController.dispose();
    emailController.dispose();
    messageController.dispose();
    super.dispose();
  }

  String? _validateFirstName(String? value) {
    if (value == null || value.isEmpty) {
      return 'Please enter your first name';
    }
    return null;
  }

  String? _validateLastName(String? value) {
    if (value == null || value.isEmpty) {
      return 'Please enter your last name';
    }
    return null;
  }

  String? _validateEmail(String? value) {
    if (value == null || value.isEmpty) {
      return 'Please enter your email';
    }
    String pattern =
        r"(?:[a-z0-9!#$%&'*+/=?^_{|}~-]+(?:\.[a-z0-9!#$%&'*+/=?^_{|}~-]+)*|"
        r'"(?:[\x01-\x08\x0b\x0c\x0e-\x1f\x21\x23-\x5b\x5d-\x7f]|'
        r'\\[\x01-\x09\x0b\x0c\x0e-\x7f])*")@(?:(?:[a-z0-9]'
        r'(?:[a-z0-9-]*[a-z0-9])?\.)+[a-z0-9]'
        r'(?:[a-z0-9-]*[a-z0-9])?|\[(?:(?:(2(5[0-5]|[0-4][0-9])|1[0-9][0-9]|[1-9]?[0-9]))\.){3}'
        r'(?:(2(5[0-5]|[0-4][0-9])|1[0-9][0-9]|[1-9]?[0-9])|'
        r'[a-z0-9-]*[a-z0-9]:'
        r'(?:[\x01-\x08\x0b\x0c\x0e-\x1f\x21-\x5a\x53-\x7f]|'
        r'\\[\x01-\x09\x0b\x0c\x0e-\x7f])+)\])';
    if (!RegExp(pattern).hasMatch(value)) {
      return 'Enter a valid email address';
    }
    return null;
  }

  String? _validateMessage(String? value) {
    if (value == null || value.isEmpty) {
      return 'Please enter your message';
    }
    return null;
  }

  Future<void> _sendContactForm() async {
    final String? token = await getToken();
    const url = 'https://gpappapis.azurewebsites.net/api/contactUS';
    try {
      final response = await http.post(
        Uri.parse(url),
        headers: {
          'Content-Type': 'application/json',
          'Authorization': token ?? '',
        },
        body: jsonEncode({
          'firstname': firstNameController.text,
          'lastname': lastNameController.text,
          'email': emailController.text,
          'message': messageController.text,
        }),
      );

      final Map<String, dynamic> responseBody = jsonDecode(response.body);
      if (responseBody['success'] == true) {
        showSnackbar(
          context,
          'Success',
          responseBody['message'] ?? 'Your message has been sent successfully.',
          ContentType.success,
        );
      } else {
        showSnackbar(
          context,
          'Success',
          responseBody['message'] ?? 'Your message has been sent successfully.',
          ContentType.success,
          height: 120,
        );
        Navigator.pop(
          context,
        );
      }
    } catch (e) {
      if (mounted) {
        showSnackbar(
          context,
          'Error',
          'Failed to send message. Please try again.',
          ContentType.failure,
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFFFFAEF),
      appBar: const CustomAppBar(text: 'Get in touch'),
      body: SingleChildScrollView(
        child: Form(
          key: formKey,
          child: Column(
            children: [
              SizedBox(height: 50.h),
              Padding(
                padding: EdgeInsets.symmetric(horizontal: 32.w),
                child: TextFormField(
                  controller: firstNameController,
                  validator: _validateFirstName,
                  cursorColor: const Color(0xff537F5C),
                  style: const TextStyle(
                      color: Color(0xff537F5C), fontFamily: 'InriaSans-Light'),
                  decoration: InputDecoration(
                    hintText: 'First Name',
                    hintStyle: TextStyle(
                        color: const Color(0xff537F5C), fontSize: 16.sp),
                    enabledBorder: const UnderlineInputBorder(
                      borderSide: BorderSide(color: Color(0xff537F5C)),
                    ),
                    focusedBorder: const UnderlineInputBorder(
                      borderSide: BorderSide(color: Color(0xff537F5C)),
                    ),
                  ),
                ),
              ),
              SizedBox(height: 20.h),
              Padding(
                padding: EdgeInsets.symmetric(horizontal: 32.w),
                child: TextFormField(
                  controller: lastNameController,
                  validator: _validateLastName,
                  cursorColor: const Color(0xff537F5C),
                  style: const TextStyle(
                      color: Color(0xff537F5C), fontFamily: 'InriaSans-Light'),
                  decoration: InputDecoration(
                    hintText: 'Last Name',
                    hintStyle: TextStyle(
                        color: const Color(0xff537F5C), fontSize: 16.sp),
                    enabledBorder: const UnderlineInputBorder(
                      borderSide: BorderSide(color: Color(0xff537F5C)),
                    ),
                    focusedBorder: const UnderlineInputBorder(
                      borderSide: BorderSide(color: Color(0xff537F5C)),
                    ),
                  ),
                ),
              ),
              SizedBox(height: 20.h),
              Padding(
                padding: EdgeInsets.symmetric(horizontal: 32.w),
                child: TextFormField(
                  controller: emailController,
                  validator: _validateEmail,
                  cursorColor: const Color(0xff537F5C),
                  style: const TextStyle(
                      color: Color(0xff537F5C), fontFamily: 'InriaSans-Light'),
                  decoration: InputDecoration(
                    hintText: 'Email',
                    hintStyle: TextStyle(
                        color: const Color(0xff537F5C), fontSize: 16.sp),
                    enabledBorder: const UnderlineInputBorder(
                      borderSide: BorderSide(color: Color(0xff537F5C)),
                    ),
                    focusedBorder: const UnderlineInputBorder(
                      borderSide: BorderSide(color: Color(0xff537F5C)),
                    ),
                  ),
                ),
              ),
              SizedBox(height: 30.h),
              Padding(
                padding: EdgeInsets.symmetric(horizontal: 32.w),
                child: Column(
                  crossAxisAlignment:
                      CrossAxisAlignment.start, // Align the text to the start
                  children: [
                    Text(
                      'Message', // Add your label here
                      style: TextStyle(
                        color: const Color(0xff537F5C),
                        fontFamily: 'InriaSans-Light',
                        fontSize: 16.sp, // Adjust the size as needed
                      ),
                    ),
                    SizedBox(
                        height: 15
                            .h), // Add some spacing between the label and TextFormField
                    TextFormField(
                      controller: messageController,
                      validator: _validateMessage,
                      maxLines: 6,
                      style: const TextStyle(
                        color: Color(0xff537F5C),
                        fontFamily: 'InriaSans-Light',
                      ),
                      decoration: const InputDecoration(
                        enabledBorder: OutlineInputBorder(
                          borderSide: BorderSide(color: Color(0xff537F5C)),
                          borderRadius: BorderRadius.all(Radius.circular(8)),
                        ),
                        focusedBorder: OutlineInputBorder(
                          borderSide: BorderSide(color: Color(0xff537F5C)),
                          borderRadius: BorderRadius.all(Radius.circular(8)),
                        ),
                      ),
                      cursorColor: const Color(0xff537F5C),
                    ),
                  ],
                ),
              ),
              SizedBox(height: 40.h),
              Container(
                width: 200.w,
                height: 50.h,
                decoration: BoxDecoration(
                  border:
                      Border.all(width: 1.w, color: const Color(0xffFFFAEF)),
                  borderRadius: BorderRadius.circular(20.w),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(.25),
                      blurRadius: 4.w,
                    ),
                  ],
                ),
                child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xff537F5C),
                    shadowColor: const Color(0xff537F5C),
                    alignment: Alignment.center,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(20.w),
                    ),
                  ),
                  onPressed: () async {
                    if (formKey.currentState!.validate()) {
                      await _sendContactForm();
                    }
                  },
                  child: Text(
                    'Send',
                    style: TextStyle(
                        fontSize: 20.sp, color: const Color(0xffFFFAEF)),
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
