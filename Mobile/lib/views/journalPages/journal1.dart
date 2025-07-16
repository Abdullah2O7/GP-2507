import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:intl/intl.dart';
import 'package:splash_onboarding_test/views/ConatctUspage/contactUsPage.dart';

class NewJournalEntryPage extends StatefulWidget {
  final DateTime currentDate;

  const NewJournalEntryPage({super.key, required this.currentDate});

  @override
  _NewJournalEntryPageState createState() => _NewJournalEntryPageState();
}

class _NewJournalEntryPageState extends State<NewJournalEntryPage> {
  final TextEditingController _titleController = TextEditingController();
  final TextEditingController _contentController = TextEditingController();

  Future<void> _saveJournalEntry() async {
    final String? token = await getToken();
    final String title = _titleController.text;
    final String content = _contentController.text;

    if (title.isEmpty || content.isEmpty) {
      // Show an error if the fields are empty
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Please enter both title and content')),
      );
      return;
    }

    const String apiUrl =
        'https://gpappapis.azurewebsites.net/api/create_journal';

    try {
      // Check if journal entry for the current date already exists
      final checkResponse = await http.get(
        Uri.parse(
            '$apiUrl/check_entry?date=${widget.currentDate.toIso8601String()}'),
        headers: {
          'Authorization': token ?? '',
        },
      );

      if (checkResponse.statusCode == 201) {
        final checkData = jsonDecode(checkResponse.body);
        if (checkData['exists']) {
          // Show a message that journal entry already exists
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
                content: Text(
                    'You have already created a journal entry for today.')),
          );
          return;
        }
      }

      // Create journal entry
      final response = await http.post(
        Uri.parse(apiUrl),
        headers: {
          'Authorization': token ?? '',
          'Content-Type': 'application/json',
        },
        body: jsonEncode({
          'title': title,
          'content': content,
        }),
      );

      if (response.statusCode == 201) {
        // If the server returns a 201 Created response, show success message
        showDialog(
          context: context,
          builder: (BuildContext context) {
            return AlertDialog(
              backgroundColor: const Color(0xff537F5C),
              title: const Text(
                'Success',
                style: TextStyle(color: Colors.white),
              ),
              content: const Text('Journal entry created successfully!',
                  style: TextStyle(color: Colors.white)),
              actions: [
                TextButton(
                  onPressed: () {
                    Navigator.pop(context); // Close the dialog
                    Navigator.pop(context); // Return to previous page
                  },
                  child:
                      const Text('OK', style: TextStyle(color: Colors.white)),
                ),
              ],
            );
          },
        );
      } else {
        // If the server does not return a 201 Created response, show an error
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Failed to create journal entry')),
        );
      }
    } catch (e) {
      // If there's an error (like network issues), show an error message
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Error: $e')),
        );
      }
    }
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
          IconButton(
            icon: const Icon(Icons.check, color: Color(0xffD9D9D9)),
            onPressed: _saveJournalEntry, // Trigger save action here
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              '${DateFormat.EEEE().format(widget.currentDate)}  ${DateFormat('d/MM/yyyy').format(widget.currentDate)}',
              style: const TextStyle(
                color: Colors.white60,
                fontSize: 16,
                fontFamily: 'Inter',
              ),
            ),
            const SizedBox(height: 10),
            // Title input field
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
                focusedBorder: InputBorder.none,
                enabledBorder: InputBorder.none,
              ),
            ),
            const SizedBox(height: 20),
            // Journal entry input field (multiline)
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
                    hintText: 'start writing...',
                    hintStyle: TextStyle(
                      color: Color(0xFFD9D9D9),
                      fontSize: 20,
                      fontFamily: 'Ledger',
                    ),
                    border: InputBorder.none,
                    focusedBorder: InputBorder.none,
                    enabledBorder: InputBorder.none,
                    disabledBorder: InputBorder.none,
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
