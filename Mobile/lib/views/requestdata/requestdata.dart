import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:http/http.dart' as http;
import 'package:splash_onboarding_test/Registeration/auth_service.dart';

import '../../widgets/custom_app_bar.dart';

class RequestdataPage extends StatelessWidget {
  const RequestdataPage({super.key});

  Future<void> _startRequest(BuildContext context) async {
    final String? token = await getToken();
    if (token != null) {
      final response = await http.post(
        Uri.parse('https://gpappapis.azurewebsites.net/api/request-data'),
        headers: {
          'Authorization': token,
          'Content-Type': 'application/json',
        },
      );

      if (response.statusCode == 200) {
        final Map<String, dynamic> responseData = json.decode(response.body);
        _showAnswerAlert(context, responseData['message']);
      } else {
        debugPrint('Error: ${response.statusCode} - ${response.body}');
        _showAnswerAlert(context, 'Failed to send request. Please try again.');
      }
    } else {
      // Handle no token case
      _showAnswerAlert(context, 'No token found. Please log in again.');
    }
  }

  void _showAnswerAlert(BuildContext context, String message) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(20),
          ),
          backgroundColor: const Color(0xff537F5C).withOpacity(.88),
          content: SizedBox(
            width: 280, // Keep the width
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                const SizedBox(height: 12),
                const Text(
                  "Request Status",
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 14,
                    fontFamily: 'InriaSans-Bold',
                    fontWeight: FontWeight.bold,
                  ),
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 6),
                Image.asset(
                  'assets/mail-sent-successfully-with-checklist-cartoon-icon-illustration-business-object-icon-concept-isolated-premium-vector-removebg-preview.png', // Replace with your image path
                  width: 100,
                  height: 100,
                ),
                const SizedBox(height: 8),
                Text(
                  message,
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 16,
                    fontFamily: 'InriaSans-bold',
                  ),
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 14), // Adjusted spacing before button
                SizedBox(
                  height: 50,
                  width: 80,
                  child: OutlinedButton(
                    onPressed: () {
                      Navigator.of(context).pop(); // Close the dialog
                    },
                    style: OutlinedButton.styleFrom(
                      side: const BorderSide(color: Colors.white, width: 1),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10),
                      ),
                      padding: const EdgeInsets.symmetric(vertical: 12),
                    ),
                    child: const Text(
                      "OK",
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 14,
                        fontFamily: 'InriaSans-bold',
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  Future<String?> getToken() async {
    final String? token = await AuthService.getToken();
    if (token == null) {
      debugPrint('No token found');
    } else {
      debugPrint('Retrieved Token: $token');
    }
    return token;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFFFFAEF),
      appBar: const CustomAppBar(
        text: 'Request Data',
      ),
      body: Container(
        color: const Color(0xFFFFFAEF),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            Expanded(
              child: Padding(
                padding: EdgeInsets.symmetric(horizontal: 25.w),
                child: Column(
                  // mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Padding(
                      padding: EdgeInsets.only(top: 59.h, bottom: 59.h),
                      child: Text(
                        "You will receive an email from our mail to complete your request",
                        style: TextStyle(
                          color: const Color(0xff537F5C),
                          fontSize: 20.sp,
                          fontFamily: 'InriaSans-regular',
                        ),
                        textAlign: TextAlign.center,
                      ),
                    ),
                    Container(
                      width: 270,
                      height: 44,
                      decoration: BoxDecoration(
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black.withOpacity(.10),
                            spreadRadius: 0,
                            blurRadius: 4,
                            offset: const Offset(0, 4),
                          ),
                        ],
                        borderRadius: BorderRadius.circular(20),
                      ),
                      child: ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          minimumSize: const Size(100, 44),
                          backgroundColor: const Color(0xff537F5C),
                          shadowColor: const Color(0xff537F5C),
                          alignment: Alignment.center,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(20),
                            side: const BorderSide(color: Color(0xFFFFFAEF)),
                          ),
                        ),
                        onPressed: () =>
                            _startRequest(context), // Call the request function
                        child: const Text(
                          'Start request',
                          style: TextStyle(
                            fontSize: 20,
                            color: Color(0xFFFFFAEF),
                            fontFamily: 'InriaSans-Bold',
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
            // const BackTohomeBtn(),
            // const SizedBox(height: 10)
          ],
        ),
      ),
    );
  }
}
