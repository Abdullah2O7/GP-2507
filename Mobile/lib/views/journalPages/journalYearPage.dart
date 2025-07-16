import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:loading_animation_widget/loading_animation_widget.dart';
//import 'package:splash_onboarding_test/components/ButtonBar.dart';
import 'package:splash_onboarding_test/constant/Colors.dart';
import 'package:splash_onboarding_test/views/ConatctUspage/contactUsPage.dart';

import 'package:splash_onboarding_test/views/journalPages/widgets/JournalYearData.dart';

class Journalyearpage extends StatefulWidget {
  final int selectYear;

  const Journalyearpage({super.key, required this.selectYear});

  @override
  _JournalyearpageState createState() => _JournalyearpageState();
}

class _JournalyearpageState extends State<Journalyearpage> {
  final Map<int, bool> _isOpen = {};
  Map<int, List<Map<String, dynamic>>> _journalsByMonth = {};
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _loadJournals();
  }

  Future<Map<String, dynamic>> fetchJournalsByYear(int year) async {
    final String? token = await getToken();

    final response = await http.post(
      Uri.parse(
          'https://gpappapis.azurewebsites.net/api/get-journals'),
      headers: {
        'Authorization': token ?? '', // Token should not be null here
        'Content-Type': 'application/json',
      },
      body: jsonEncode({
        'year': year.toString(),
      }),
    );

    if (response.statusCode == 200) {
      final decodedResponse = jsonDecode(response.body);
      print('Response: $decodedResponse'); 

      // Log the full response
      return decodedResponse;
    } else {
      print(
          'Failed to load journals: ${response.statusCode} - ${response.body}');
      throw Exception('Failed to load journals');
    }
  }

  void _loadJournals() async {
    try {
      final data = await fetchJournalsByYear(widget.selectYear);

      if (data.containsKey('months') && data['months'] is Map) {
        _groupJournalsByMonth(data['months']);
      } else {
        print("No journals found or invalid format.");
      }

      setState(() {
        _isLoading = false;
      });
    } catch (e) {
      print('Error loading journals: $e');
    }
  }

  void _groupJournalsByMonth(Map<String, dynamic> months) {
    _journalsByMonth = {};
    months.forEach((month, entries) {
      _journalsByMonth[int.parse(month)] =
          List<Map<String, dynamic>>.from(entries);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: _isLoading
          ? Center(
              child: LoadingAnimationWidget.discreteCircle(
                color: const Color(0xff537F5C),
                size: 50,
              ),
            )
          : Container(
              padding: const EdgeInsets.symmetric(horizontal: 15),
              color: primaryColor,
              child: Column(
                children: [
                  const SizedBox(height: 40),
                  _buildHeader(context),
                  // const SizedBox(height: 15),
                  // _buildSearchBar(),
                //  const SizedBox(height: 30),
                  _buildJournalList(),
                ],
              ),
            ),
    );
  }

  Widget _buildJournalList() {
    return Flexible(
      child: ListView(
        padding: const EdgeInsets.only(bottom: 80),
        children: List.generate(12, (index) {
          String month = _getMonthName(index + 1);
          return _customExpansionTile(
            title: month,
            index: index,
            children: _buildJournalEntriesForMonth(index + 1),
          );
        }),
      ),
    );
  }

  List<Widget> _buildJournalEntriesForMonth(int month) {
    List<Map<String, dynamic>>? journals = _journalsByMonth[month];

    if (journals == null || journals.isEmpty) {
      return [
        const Text("No journals available",
            style: TextStyle(color: Colors.white))
      ];
    }

    List<Widget> journalWidgets = [];
    for (var journal in journals) {
      // Assuming journal contains 'entries' as well
      if (journal.containsKey('entries') && journal['entries'] is List) {
        for (var entry in journal['entries']) {
          // Accessing each entry's title and content
          String id = entry['_id'] ?? '';
          String title = entry['title'] ?? 'Untitled';
          String date = journal['date'] ??
              'Unknown date'; // Assuming the date is from the parent journal
          String content = entry['content'] ?? 'No content available';
          
          // Add to the list of journal widgets
          journalWidgets.add(JournalYearData(
            id: id,
            title: title,
            date: date,
            content: content,
          ));
        }
      } else {
        print("Invalid journal entry structure: $journal");
      }
    }

    return journalWidgets;
  }

  Widget _buildHeader(BuildContext context) {
    return Row(
      children: [
        Expanded(
          child: Column(
            children: [
              Container(
                margin: const EdgeInsets.only(right: 320, top: 5),
                width: 35.0,
                height: 35.0,
                decoration: const BoxDecoration(shape: BoxShape.circle),
                child: IconButton(
                  icon: const Icon(Icons.arrow_back_ios),
                  color: Colors.white,
                  onPressed: () {
                    Navigator.pop(
                      context,
                    );
                  },
                  iconSize: 25.0,
                  padding:
                      const EdgeInsets.symmetric(vertical: 3, horizontal: 9),
                  splashRadius: 25.0,
                  tooltip: "Back",
                ),
              ),
              Center(
                child: Text(
                  "${widget.selectYear}",
                  style: const TextStyle(
                    fontSize: 30,
                    fontFamily: "LEDGER",
                    color: Colors.white,
                  ),
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  // Widget _buildSearchBar() {
  //   return SizedBox(
  //     height: 40,
  //     width: MediaQuery.of(context).size.width * 1,
  //     child: TextFormField(
  //       cursorColor: Colors.white,
  //       decoration: InputDecoration(
  //         fillColor: const Color(0xff537F5C),
  //         filled: true,
  //         prefixIcon: const Icon(Icons.search, color: Colors.white),
  //         suffixIcon: const Icon(Icons.mic_none, color: Colors.white),
  //         hintText: 'Search for journal',
  //         hintStyle: const TextStyle(
  //           color: Color(0xffD9D9D9),
  //           fontFamily: 'Ledger',
  //           fontSize: 18,
  //         ),
  //         contentPadding: const EdgeInsets.symmetric(vertical: 2.0),
  //         border: OutlineInputBorder(
  //           borderRadius: BorderRadius.circular(25.0),
  //           borderSide: const BorderSide(
  //             color: Color(0xffD9D9D9),
  //             width: 1.2,
  //           ),
  //         ),
  //         enabledBorder: OutlineInputBorder(
  //           borderRadius: BorderRadius.circular(25.0),
  //           borderSide: const BorderSide(
  //             color: Color(0xffD9D9D9),
  //             width: 1.2,
  //           ),
  //         ),
  //         focusedBorder: OutlineInputBorder(
  //           borderRadius: BorderRadius.circular(25.0),
  //           borderSide: const BorderSide(
  //             color: Color(0xffD9D9D9),
  //             width: 1.2,
  //           ),
  //         ),
  //       ),
  //     ),
  //   );
  // }

  Widget _customExpansionTile({
    required String title,
    required int index,
    required List<Widget> children,
  }) {
    return ExpansionTile(
      collapsedIconColor: Colors.white,
      iconColor: Colors.white,
      title: Text(
        title,
        style: const TextStyle(
          fontFamily: "Ledger",
          color: Colors.white,
          fontSize: 30,
        ),
      ),
      trailing: Icon(
        _isOpen[index] ?? false ? Icons.expand_more : Icons.chevron_right,
        color: Colors.white,
      ),
      onExpansionChanged: (bool expanded) {
        setState(() {
          _isOpen[index] = expanded;
        });
      },
      children: children,
    );
  }

  String _getMonthName(int monthNumber) {
    List<String> months = [
      "January",
      "February",
      "March",
      "April",
      "May",
      "June",
      "July",
      "August",
      "September",
      "October",
      "November",
      "December",
    ];
    return months[monthNumber - 1];
  }
}
