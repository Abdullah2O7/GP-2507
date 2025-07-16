import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:splash_onboarding_test/views/Generaltestresult1.dart';
// Replace with your actual import path

class SubmitPage extends StatelessWidget {
  final List<String?> answers;

  const SubmitPage({super.key, required this.answers});

  Future<void> _submitAnswers(BuildContext context) async {
    final url =
        Uri.parse('https://model1-production.up.railway.app/generalPredict');

    // Convert answers to a list of maps
    final payload = jsonEncode({
      'data': List.generate(
        answers.length,
        (index) => {
          'question': 'Question ${index + 1}',
          'answer': answers[index] ?? 'Unknown',
        },
      )
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

        // Ensure that the response is a Map and contains valid data
        if (responseData is Map<String, dynamic> && responseData.isNotEmpty) {
          // Extract the first value from the response map
          final result = responseData.values.first ?? 'Unknown';

          // Navigate to the Result1 screen with the fetched result
          Navigator.pushReplacement(
            context,
            MaterialPageRoute(
                builder: (context) => GenralResult1(
                      result: result,
                    )),
          );

          // Show notification after successful submission
          /* FirebaseNotifications notifications = FirebaseNotifications();
          await notifications.showNotificationOnButtonPress(
            'Submission Successful',
            'Your answers have been submitted successfully!',
          );*/
        } else {
          throw Exception('Unexpected response format or empty response');
        }
      } else {
        throw Exception(
            'Failed to submit answers. Server error with status code: ${response.statusCode}');
      }
    } catch (e) {
      // Catch and display any errors that occur
      print('Error: $e');
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error: ${e.toString()}')),
      );
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
                    fontSize: 20,
                    fontFamily: 'InriaSans-Bold',
                    fontWeight: FontWeight.bold,
                  ),
                  textAlign: TextAlign.center,
                ),
              ),
              Image.asset(
                'assets/submitpage.png',
                height: 300,
                width: 320,
              ),
              const SizedBox(height: 20),
              _buildButton(
                context,
                'Submit',
                () => _submitAnswers(context), // Call the submit function
              ),
              const SizedBox(height: 15),
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
      width: 180,
      height: 40,
      child: ElevatedButton(
        style: ElevatedButton.styleFrom(
          backgroundColor: const Color(0xff618969),
          shadowColor: const Color(0xff537F5C),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(20),
          ),
        ),
        onPressed: onPressed,
        child: Text(
          label,
          style: const TextStyle(
            color: Color(0xffD9D9D9),
            fontSize: 20,
            fontFamily: 'Ledger',
            fontWeight: FontWeight.w700,
          ),
        ),
      ),
    );
  }
}
