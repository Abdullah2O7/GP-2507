import 'dart:convert';
import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import 'package:splash_onboarding_test/views/ConatctUspage/contactUsPage.dart';

class Updateandaskgemini extends StatefulWidget {
  final String title;
  final String content;
  final String date;
  final String id;

  const Updateandaskgemini({
    super.key,
    required this.title,
    required this.content,
    required this.date,
    required this.id,
  });

  @override
  _Updateandaskgemini createState() => _Updateandaskgemini();
}

class _Updateandaskgemini extends State<Updateandaskgemini> {
  late TextEditingController _titleController;
  late TextEditingController _contentController;

  @override
  void initState() {
    super.initState();
    _titleController = TextEditingController(text: widget.title);
    _contentController = TextEditingController(text: widget.content);
  }

  @override
  void dispose() {
    _titleController.dispose();
    _contentController.dispose();
    super.dispose();
  }

  // Enhanced updateJournal function with logging and detailed error handling
  Future<void> _updateJournal() async {
    final String? token = await getToken();

    const String url = 'https://gpappapis.azurewebsites.net/api/edit_journal';

    // Log for debugging
    print('Token: $token');
    print('Journal ID: ${widget.id}');
    print('Request Body: ${{
      'id': widget.id,
      'new_title': _titleController.text,
      'new_content': _contentController.text,
    }}');

    try {
      final response = await http.put(
        Uri.parse(url),
        headers: {
          'Authorization': token ?? '',
          'Content-Type': 'application/json',
        },
        body: jsonEncode({
          'id': widget.id, // Journal ID
          'new_title': _titleController.text,
          'new_content': _contentController.text,
        }),
      );

      // Check the response status and body for debugging
      print('Response status: ${response.statusCode}');
      print('Response body: ${response.body}');

      if (response.statusCode == 200) {
        final Map<String, dynamic> responseData = jsonDecode(response.body);
        print('Response status: ${response.body}');
        String message =
            responseData['message'] ?? 'Journal updated successfully!';

        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(message)),
        );
        Navigator.pop(context);
      } else {
        // Improved error handling
        final Map<String, dynamic> errorResponse = jsonDecode(response.body);
        String errorMessage = errorResponse['error'] ?? 'An error occurred';

        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
              content: Text('Failed to update the journal: $errorMessage')),
        );
      }
    } catch (e) {
      print('Error: $e');
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('An error occurred. Please try again.')),
      );
    }
  }

  // Dialog for confirming the journal update
  void _confirmUpdate() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          backgroundColor: const Color(0xff537F5C),
          title: const Text(
            'Confirm Update',
            style: TextStyle(color: Colors.white),
          ),
          content: const Text(
            'Are you sure you want to update this journal entry?',
            style: TextStyle(color: Colors.white),
          ),
          actions: <Widget>[
            TextButton(
              child: const Text(
                'Cancel',
                style: TextStyle(color: Colors.white),
              ),
              onPressed: () {
                Navigator.of(context).pop(); // Close the dialog
              },
            ),
            TextButton(
              child: const Text(
                'OK',
                style: TextStyle(color: Colors.white),
              ),
              onPressed: () {
                Navigator.of(context).pop(); // Close the dialog
                _updateJournal(); // Proceed with the update
              },
            ),
          ],
        );
      },
    );
  }

  Future<void> askGemini() async {
    final String? token = await getToken(); // Assuming token is retrieved here

    const String url = 'https://gpappapis.azurewebsites.net/api/ask-gemini';

    final response = await http.post(
      Uri.parse(url),
      headers: {
        'Authorization': token ?? '',
        'Content-Type': 'application/json',
      },
      body: jsonEncode({
        'prompt': _contentController.text,
      }),
    );

    if (response.statusCode == 200) {
      final Map<String, dynamic> responseData = jsonDecode(response.body);
      String responseText = responseData['response'] ?? '';
      responseText = responseText.replaceAll('*', ''); // Remove all asterisks
      showResponseBottomSheet(responseText);
    } else {
      showResponseBottomSheet('Failed to get a response. Please try again.');
    }
  }

  Future<void> analyzeJournalMood(
      BuildContext context, String journalId, String journalContent) async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    final String? userId = prefs.getString('user_id'); // Retrieve user_id

    if (userId == null) {
      showResponseDialog(context, "Error: User ID not found");
      return;
    }

    const String url = 'https://model3-production-4e4d.up.railway.app/predict';

    final response = await http.post(
      Uri.parse(url),
      headers: {
        'Content-Type': 'application/json',
      },
      body: jsonEncode({
        'user_id': userId,
        'journal_id': journalId, // Journal ID
        'journal': journalContent, // Journal Content
      }),
    );

    if (response.statusCode == 200) {
      final Map<String, dynamic> responseData = jsonDecode(response.body);
      log("===================$responseData");
      String prediction =
          responseData['prediction'] ?? 'No prediction available';

      showResponseDialog(context, prediction);
    } else {
      showResponseDialog(
          context, 'Failed to get a response. Please try again.');
    }
  }

// Function to show the response in a centered dialog
  void showResponseDialog(BuildContext context, String response) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          contentPadding: const EdgeInsets.all(5),
          backgroundColor: Colors.white.withOpacity( 0.73),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(40.0),
            side: const BorderSide(color: Color(0xff3B5D44), width: 2),
          ),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Image.asset('assets/sentiment_green.png'),
              const SizedBox(height: 10),
              SizedBox(
                width: 264,
                child: Column(
                  children: [
                    Text(
                      'Based on your journal entries, it appears you’ve been',
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.w600,
                        color: Colors.black.withOpacity( 0.73),
                        fontFamily: 'Inter',
                      ),
                    ),
                    const SizedBox(height: 10),
                    Text(
                      response,
                      textAlign: TextAlign.center,
                      style: const TextStyle(
                        fontSize: 20,
                        color: Color(0xff3B5D44),
                        fontFamily: 'Inter',
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
                ),
              ),
              if (response.toLowerCase() == 'depressed') ...[
                const SizedBox(height: 10),
                SizedBox(
                  width: 264,
                  child: Text(
                    '“it’s okay you’re not alone Malaz got some tips to help you out through this journey”',
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontSize: 14,
                      fontFamily: 'InriaSans-Light',
                      color: Colors.black.withOpacity( 0.73),
                    ),
                  ),
                ),
                const SizedBox(
                  height: 10,
                ),
                const Text(
                  'wanna check it out?',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontSize: 14,
                    color: Color(0xff3B5D44),
                    fontFamily: 'Inter',
                    fontWeight: FontWeight.w600,
                  ),
                )
              ],
            ],
          ),
          actionsAlignment: MainAxisAlignment.center,
          actions: <Widget>[
            if (response.toLowerCase() == 'depressed') ...[
              CustomOutlineButton(
                text: "No",
                onPressed: () {
                  Navigator.of(context).pop();
                },
              ),
              CustomOutlineButton(
                text: "Yes",
                onPressed: () {
                  Navigator.of(context).pop();
                  askGemini(); // Call the API for tips
                },
              ),
            ] else ...[
              CustomOutlineButton(
                text: 'OK',
                onPressed: () {
                  Navigator.of(context).pop();
                },
              ),
            ],
          ],
        );
      },
    );
  }

  // Bottom sheet for showing Gemini's response
  void showResponseBottomSheet(String response) {
    showModalBottomSheet(
      context: context,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(25.0)),
      ),
      isScrollControlled: true,
      builder: (BuildContext context) {
        return DraggableScrollableSheet(
          expand: false,
          initialChildSize: 0.4,
          minChildSize: 0.2,
          maxChildSize: 0.8,
          builder: (BuildContext context, ScrollController scrollController) {
            return Container(
              padding: const EdgeInsets.all(16.0),
              decoration: const BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.vertical(top: Radius.circular(25.0)),
              ),
              child: SingleChildScrollView(
                controller: scrollController,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Center(
                      child: Image.asset(
                        'assets/geminilogo.png', // Ensure this path is correct for your image
                      ),
                    ),
                    const SizedBox(height: 20),
                    Text(
                      response,
                      style: const TextStyle(
                        fontSize: 16,
                        color: Colors.black87,
                      ),
                    ),
                  ],
                ),
              ),
            );
          },
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF537F5C),
      appBar: AppBar(
        backgroundColor: const Color(0xFF537F5C),
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios, color: Color(0xffD9D9D9)),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
        actions: [
          Padding(
            padding: const EdgeInsets.only(),
            child: IconButton(
              icon: Image.asset(
                'assets/fluent-mdl2_sentiment-analysis.png',
                width: 25,
                height: 25,
              ),
              onPressed: () {
                analyzeJournalMood(
                  context,
                  widget.id, // Pass the journal ID
                  _contentController.text, // Pass the journal content
                );
              },
            ),
          ),
          Padding(
            padding: const EdgeInsets.only(),
            child: IconButton(
              icon: Image.asset(
                'assets/gemini.png',
                width: 25,
                height: 25,
              ),
              onPressed: () {
                askGemini();
              },
            ),
          ),
          IconButton(
            icon: const Icon(Icons.check, color: Color(0xffD9D9D9)),
            onPressed: () {
              _confirmUpdate(); // Trigger the confirmation dialog
            },
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              widget.date,
              style: const TextStyle(
                color: Colors.white60,
                fontSize: 16,
                fontFamily: 'Inter',
              ),
            ),
            const SizedBox(height: 10),
            TextField(
              controller: _titleController,
              style: const TextStyle(
                fontSize: 28,
                color: Colors.white,
                fontFamily: 'Ledger',
              ),
              decoration: const InputDecoration(
                hintText: 'Title...',
                hintStyle: TextStyle(
                  color: Color(0xFFD9D9D9),
                  fontSize: 26,
                  fontFamily: 'Ledger',
                ),
                border: InputBorder.none,
              ),
            ),
            const SizedBox(height: 20),
            Expanded(
              child: Container(
                padding:
                    const EdgeInsets.symmetric(horizontal: 20, vertical: 15),
                decoration: BoxDecoration(
                  color: const Color(0xFFB7B597).withOpacity(.80),
                  borderRadius: BorderRadius.circular(30.0),
                ),
                child: TextField(
                  controller: _contentController,
                  maxLines: null,
                  expands: true,
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 18,
                    fontFamily: 'Ledger',
                  ),
                  decoration: const InputDecoration(
                    hintText: 'Start writing...',
                    hintStyle: TextStyle(
                      color: Color(0xFFD9D9D9),
                      fontSize: 20,
                      fontFamily: 'Ledger',
                    ),
                    border: InputBorder.none,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class CustomOutlineButton extends StatelessWidget {
  const CustomOutlineButton({
    super.key,
    required this.onPressed,
    required this.text,
  });
  final void Function() onPressed;
  final String text;
  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 27,
      width: 75,
      child: OutlinedButton(
        onPressed: onPressed,
        style: OutlinedButton.styleFrom(
          side: const BorderSide(color: Color(0xff3B5D44)),
        ),
        child: Text(
          text,
          style: TextStyle(
            color: Colors.black.withOpacity( 0.73),
          ),
        ),
      ),
    );
  }
}

// Dummy getToken function; implement your actual token retrieval logic
