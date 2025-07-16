import 'dart:convert';

import 'package:awesome_snackbar_content/awesome_snackbar_content.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:http/http.dart' as http;
import 'package:splash_onboarding_test/Registeration/login.dart';
import 'package:splash_onboarding_test/views/ConatctUspage/contactUsPage.dart';
import 'package:splash_onboarding_test/widgets/custom_app_bar.dart';

import '../helpers/show_snackbar.dart';

class ChangePassword extends StatefulWidget {
  const ChangePassword({super.key});

  @override
  _ChangePasswordState createState() => _ChangePasswordState();
}

class _ChangePasswordState extends State<ChangePassword> {
  final GlobalKey<FormState> formKey = GlobalKey<FormState>();

  final TextEditingController oldPasswordController = TextEditingController();
  final TextEditingController newPasswordController = TextEditingController();
  final TextEditingController confirmPasswordController =
      TextEditingController();

  @override
  void dispose() {
    oldPasswordController.dispose();
    newPasswordController.dispose();
    confirmPasswordController.dispose();
    super.dispose();
  }

  Future<void> _changePassword() async {
    final String? token = await getToken();
    // API endpoint
    const url = 'https://gpappapis.azurewebsites.net/api/changePassword';

    // Prepare the request data
    final body = {
      'current_password': oldPasswordController.text,
      'new_password': newPasswordController.text,
      'confirm_password': confirmPasswordController.text,
    };

    // Make the PUT request with authorization header
    final response = await http.put(
      Uri.parse(url),
      headers: {
        'Content-Type': 'application/json',
        'Authorization': token ?? '',
      },
      body: jsonEncode(body),
    );

    // Handle the response
    if (response.statusCode == 200) {
      // Success response
      final responseData = jsonDecode(response.body);
      if (responseData['message'] == 'Password updated successfully!') {
        showSnackbar(
          context,
          'Success',
          'Password updated successfully!',
          ContentType.success,
        );
        Navigator.pushAndRemoveUntil(
          context,
          MaterialPageRoute(builder: (context) => const Login()),
          (route) => false,
        );
      }
    } else {
      // Error handling
      final responseData = jsonDecode(response.body);
      if (response.statusCode == 400 &&
          responseData['error'] == 'Current password is incorrect.') {
        showSnackbar(
          context,
          'Error',
          'Current password is incorrect.',
          ContentType.failure,
        );
      } else if (responseData['error'] == 'Current password is required.') {
        showSnackbar(
          context,
          'Error',
          'Current password is required.',
          ContentType.failure,
        );
      } else if (responseData['error'] == 'Passwords do not match') {
        showSnackbar(
          context,
          'Error',
          'Passwords do not match.',
          ContentType.failure,
        );
      }
    }
  }

  // Success dialog
  // void _showSuccessDialog() {
  //   showDialog(
  //     context: context,
  //     builder: (BuildContext context) {
  //       return AlertDialog(
  //         backgroundColor: const Color(0xff537F5C),
  //         content: const Text(
  //           'Password updated successfully!',
  //           style: TextStyle(color: Colors.white),
  //         ),
  //         actions: <Widget>[
  //           TextButton(
  //             child: const Text(
  //               'OK',
  //               style: TextStyle(color: Colors.white),
  //             ),
  //             onPressed: () {
  //               Navigator.of(context).pop(); // Close the dialog
  //               // Navigate to Login after the dialog is closed
  //               Navigator.pushReplacement(
  //                 context,
  //                 MaterialPageRoute(builder: (context) => const Login()),
  //               );
  //             },
  //           ),
  //         ],
  //       );
  //     },
  //   );
  // }

  // Error dialog
  // void _showErrorDialog(String message) {
  //   showDialog(
  //     context: context,
  //     builder: (BuildContext context) {
  //       return AlertDialog(
  //         backgroundColor: const Color(0xff537F5C),
  //         content: Text(
  //           message,
  //           style: const TextStyle(color: Colors.white),
  //         ),
  //         actions: <Widget>[
  //           TextButton(
  //             child: const Text(
  //               'OK',
  //               style: TextStyle(color: Colors.white),
  //             ),
  //             onPressed: () {
  //               Navigator.of(context).pop();
  //             },
  //           ),
  //         ],
  //       );
  //     },
  //   );
  // }

  String? _validateOldPassword(String? value) {
    if (value == null || value.isEmpty) {
      return 'Please enter your old password';
    }
    return null;
  }

  String? _validateNewPassword(String? value) {
    if (value == null || value.isEmpty) {
      return 'Please enter a new password';
    }
    String pattern =
        r'^(?=.*[a-z])(?=.*[A-Z])(?=.*\d)(?=.*[@$!%*?&])[A-Za-z\d@$!%*?&#]{8,}$';
    RegExp regex = RegExp(pattern);
    if (!regex.hasMatch(value)) {
      return 'Password must be at least 8 characters long, include uppercase, lowercase letters, a number, and a special character';
    }
    return null;
  }

  String? _validateConfirmPassword(String? value) {
    if (value == null || value.isEmpty) {
      return 'Please confirm your new password';
    }
    if (value != newPasswordController.text) {
      return 'Passwords do not match';
    }
    return null;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFFFFAEF),
      appBar: const CustomAppBar(text: 'Change Password'),
      body: Form(
        key: formKey,
        child: Column(
          children: [
            SizedBox(height: 20.h),
            _buildPasswordField(
                'Old Password', oldPasswordController, _validateOldPassword),
            SizedBox(height: 20.h),
            _buildPasswordField(
                'New Password', newPasswordController, _validateNewPassword),
            SizedBox(
              height: 20.h,
            ),
            _buildPasswordField('Confirm Password', confirmPasswordController,
                _validateConfirmPassword),
            SizedBox(height: 60.h),
            _buildSaveButton(),
            const Spacer(),
            // const BackTohomeBtn(),
            // SizedBox(height: 20.h),
          ],
        ),
      ),
    );
  }

  // Helper method to build password fields
  Padding _buildPasswordField(String hint, TextEditingController controller,
      String? Function(String?) validator) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 30),
      child: TextFormField(
        controller: controller,
        obscureText: true,
        autovalidateMode: AutovalidateMode.onUserInteraction,
        validator: validator,
        cursorColor: const Color(0xff537F5C),
        style: const TextStyle(color: Color(0xff537F5C)),
        decoration: InputDecoration(
          hintText: hint,
          hintStyle: const TextStyle(color: Color(0xff537F5C), fontSize: 16),
          enabledBorder: const UnderlineInputBorder(
              borderSide: BorderSide(color: Color(0xff537F5C))),
          focusedBorder: const UnderlineInputBorder(
              borderSide: BorderSide(color: Color(0xff537F5C))),
        ),
      ),
    );
  }

  // Save button
  Container _buildSaveButton() {
    return Container(
      width: 270.w,
      height: 44.h,
      decoration: BoxDecoration(
        border: Border.all(width: 1, color: const Color(0xffFFFAEF)),
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(.25),
            spreadRadius: 0,
            blurRadius: 4,
            offset: const Offset(0, 4),
          )
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
            await _changePassword();
          }
        },
        child: Text(
          'Save',
          style: TextStyle(
            fontSize: 24.sp,
            color: const Color(0xffFFFAEF),
            fontFamily: 'InriaSans-Bold',
          ),
        ),
      ),
    );
  }
}
