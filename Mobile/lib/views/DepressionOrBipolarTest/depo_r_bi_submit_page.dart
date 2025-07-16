import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:http/http.dart' as http;
import 'package:splash_onboarding_test/views/DepressionOrBipolarTest/ResultDepOrBi.dart';

class DepoRBiSubmitPage extends StatefulWidget {
  final List<String?> answers;

  const DepoRBiSubmitPage({super.key, required this.answers});

  @override
  State<DepoRBiSubmitPage> createState() => _DepoRBiSubmitPageState();
}

class _DepoRBiSubmitPageState extends State<DepoRBiSubmitPage> {
  Future<void> _submitAnswers(BuildContext context) async {
    final url = Uri.parse(
        'https://model1-production.up.railway.app/depressionPredict');

    final payload = jsonEncode({
      'data': List.generate(
        widget.answers.length,
        (index) => {
          'question': 'Question ${index + 1}',
          'answer': widget.answers[index] ?? 'Unknown',
        },
      ),
    });

    print('Payload: $payload'); // Debugging output

    try {
      final response = await http.post(
        url,
        headers: {'Content-Type': 'application/json'},
        body: payload,
      );

      print('Response Status Code: ${response.statusCode}'); // Debugging output
      print('Response Body: ${response.body}'); // Debugging output

      if (response.statusCode == 200) {
        final responseData = jsonDecode(response.body);

        if (responseData is Map<String, dynamic>) {
          final result = responseData.values.first ?? 'Unknown';

          Navigator.pushReplacement(
            context,
            MaterialPageRoute(
              builder: (context) => Result1DepORBi(result: result),
            ),
          );
        } else {
          throw Exception('Unexpected response format');
        }
      } else {
        throw Exception('Failed to submit answers');
      }
    } catch (e) {
      print('Error: $e'); // Debugging output
     if (mounted) {
  ScaffoldMessenger.of(context).showSnackBar(
    SnackBar(content: Text('Error: ${e.toString()}')),
  );
}

    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xff537F5C),
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(12.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Center(
                child: Text(
                  "You've answered all the questions! Are you sure you want to submit your answers?",
                  style: TextStyle(
                    color: Colors.white.withOpacity(.80),
                    fontSize: 20.sp,
                    fontFamily: 'InriaSans-Bold',
                    fontWeight: FontWeight.bold,
                  ),
                  textAlign: TextAlign.center,
                ),
              ),
              Image.asset(
                'assets/submitpage.png',
                height: 300.h,
                width: 320.w,
              ),
              SizedBox(height: 20.h),
              _buildButton(
                context,
                'Submit',
                () => _submitAnswers(context),
              ),
              SizedBox(height: 15.h),
              _buildButton(
                context,
                'Go Back',
                () => Navigator.of(context).pop(),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildButton(
      BuildContext context, String label, VoidCallback onPressed) {
    return SizedBox(
      width: 180.w,
      height: 40.h,
      child: ElevatedButton(
        style: ElevatedButton.styleFrom(
          backgroundColor: const Color(0xff618969),
          shadowColor: const Color(0xff537F5C),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(20.r),
          ),
        ),
        onPressed: onPressed,
        child: Text(
          label,
          style: TextStyle(
            color: const Color(0xffD9D9D9),
            fontSize: 20.sp,
            fontFamily: 'Ledger',
            fontWeight: FontWeight.w700,
          ),
        ),
      ),
    );
  }
}
