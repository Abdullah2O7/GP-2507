import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:http/http.dart' as http;
import 'package:intl/intl.dart';
import 'package:loading_animation_widget/loading_animation_widget.dart';

import 'package:splash_onboarding_test/Registeration/auth_service.dart';
import 'package:splash_onboarding_test/views/ConatctUspage/contactUsPage.dart';
import 'package:splash_onboarding_test/views/journalPages/journal1.dart';
import 'package:splash_onboarding_test/views/journalPages/journalYearPage.dart';
import 'package:table_calendar/table_calendar.dart';

import 'widgets/JournalData.dart';

class JournalPage extends StatefulWidget {
  const JournalPage({super.key});

  @override
  _JournalPageState createState() => _JournalPageState();
}

class _JournalPageState extends State<JournalPage> {
  CalendarFormat calendarFormat = CalendarFormat.month;
  DateTime selectedDay = DateTime.now();
  DateTime focusedDay = DateTime.now();
  DateTime selectedYear = DateTime.now();
  bool isLoading = false;
  List<dynamic> journals = [];

  List<dynamic> filteredJournals =[]; 
      // Filtered journals for search// List to store fetched journals
  String errorMessage = ''; // Variable to store error messages
  String searchQuery = '';

  @override
  void initState() {
    super.initState();
    // Get the current date
    final now = DateTime.now();

    // Fetch journals for the current day, month, and year
    _fetchJournals(
      year: now.year.toString(),
      month: now.month.toString().padLeft(2, '0'),
      day: now.day.toString().padLeft(2, '0'),
    );

    update();
  }

  String? userName = '';

  update() async {
    userName = await AuthService.getUsername();
    if (mounted) {
      setState(() {});
    }
  }

  Future<void> _fetchJournals(
      {String? year, String? month, String? day}) async {
    final String? token = await getToken();

    if (!mounted) return;

    setState(() {
      isLoading = true; // Start loading
      errorMessage = ''; // Reset error message
    });

    try {
      final response = await http.post(
        Uri.parse(
          'https://gpappapis.azurewebsites.net/api/get-journals',
        ),
        headers: {
          'Authorization': token ?? '',
          'Content-Type': 'application/json',
        },
        body: jsonEncode({'year': year, 'month': month, 'day': day}),
      );

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        if (mounted) {
          setState(() {
            if (day != null) {
              journals = data['journals'] ?? [];
              filteredJournals = List.from(journals); 
              errorMessage = journals.isEmpty
                  ? 'No journals found for the selected date.'
                  : '';
            } else {
              final days = data['days'] ?? {};
              journals = [];
              days.forEach((key, value) {
                journals.addAll(value);
              });
              filteredJournals = List.from(journals);
              errorMessage = journals.isEmpty
                  ? 'No journals found for the selected month.'
                  : '';
            }
          });
        }
      } else {
        if (mounted) {
          setState(() {
            errorMessage = 'No journals available.';
          });
        }
      }
    } catch (e) {
      if (mounted) {
        setState(() {
          errorMessage = 'Error: $e';
        });
      }
    } finally {
      if (mounted) {
        setState(() {
          isLoading = false; // End loading
        });
      }
    }
  }

  void _filterJournals(String query) {
    setState(() {
      searchQuery = query;
      if (query.isEmpty) {
        filteredJournals = List.from(journals);
      } else {
        filteredJournals = journals.map((journal) {
          final filteredEntries = (journal['entries'] as List<dynamic>)
              .where((entry) => entry['title'] != null &&
                  entry['title'].toString().toLowerCase().contains(query.toLowerCase()))
              .toList();
          return filteredEntries.isNotEmpty
              ? {
                  ...journal,
                  'entries': filteredEntries,
                }
              : null;
        }).where((journal) => journal != null).toList();
      }
    });
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xff537F5C),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 8),
        child: CustomScrollView(
          slivers: [
            const SliverToBoxAdapter(
              child: SizedBox(height: 50),
            ),
            SliverToBoxAdapter(
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 10),
                child: SizedBox(
                  height: 40,
                  width: MediaQuery.of(context).size.width * 0.9,
                  child: TextFormField(
                    style: const TextStyle(color: Colors.white),
                    cursorColor: Colors.white,
                    onChanged: _filterJournals,
                    decoration: InputDecoration(
                    
                      fillColor: const Color(0xff537F5C),
                      filled: true,
                      prefixIcon: const Icon(Icons.search, color: Colors.white),
                      suffixIcon:
                          const Icon(Icons.mic_none, color: Colors.white),
                      hintText: 'Search for journal',
                      hintStyle: const TextStyle(
                        color: Color(0xffD9D9D9),
                        fontFamily: 'Ledger',
                        fontSize: 18,
                      ),
                      contentPadding: const EdgeInsets.symmetric(vertical: 2.0),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(25.0),
                        borderSide: const BorderSide(
                          color: Color(0xffD9D9D9),
                          width: 1.2,
                        ),
                      ),
                      enabledBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(30.0),
                        borderSide: const BorderSide(
                          color: Color(0xffD9D9D9),
                          width: 1.2,
                        ),
                      ),
                      focusedBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(30.0),
                        borderSide: const BorderSide(
                          color: Color(0xffD9D9D9),
                          width: 1.2,
                        ),
                      ),
                    ),
                  ),
                ),
              ),
            ),
            const SliverToBoxAdapter(
              child: SizedBox(height: 20),
            ),
            SliverToBoxAdapter(
              child: Column(
                children: [
                  Padding(
                    padding:
                        const EdgeInsets.symmetric(vertical: 5, horizontal: 16),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Container(
                          constraints: BoxConstraints(
                            maxWidth: 300.w,
                          ),
                          child: Text(
                            "Welcome $userName!",
                            style: const TextStyle(
                              color: Color(0xffAFAC7F),
                              fontSize: 20,
                              fontFamily: 'Ledger',
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                        GestureDetector(
                          onTap: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => NewJournalEntryPage(
                                    currentDate: selectedDay),
                              ),
                            );
                          },
                          child: const Icon(
                            FontAwesomeIcons.penToSquare,
                            size: 25,
                            color: Color(0xffAFAC7F),
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 3),
                  const Padding(
                    padding: EdgeInsets.symmetric(horizontal: 16),
                    child: Text(
                      "Malaz thinks you are about to make something great",
                      softWrap: true,
                      style: TextStyle(
                        fontFamily: 'Ledger',
                        color: Color.fromARGB(216, 255, 255, 255),
                        fontSize: 16,
                      ),
                    ),
                  )
                ],
              ),
            ),
            const SliverToBoxAdapter(
              child: SizedBox(height: 10),
            ),
            SliverToBoxAdapter(
              child: TableCalendar(
                daysOfWeekStyle: DaysOfWeekStyle(
                  dowTextFormatter: (date, locale) {
                    return DateFormat('E', locale).format(date)[0];
                  },
                  weekdayStyle: const TextStyle(
                      color: Colors.white, fontFamily: 'Ledger'),
                  weekendStyle: const TextStyle(
                      color: Colors.white, fontFamily: 'Ledger'),
                ),
                calendarStyle: CalendarStyle(
                  todayDecoration: BoxDecoration(
                    color: const Color.fromARGB(68, 217, 217, 217),
                    border: Border.all(color: Colors.white),
                    shape: BoxShape.circle, // Fixed to use circle shape
                  ),
                  selectedDecoration: BoxDecoration(
                    color: const Color.fromARGB(68, 217, 217, 217),
                    border: Border.all(color: Colors.white),
                    shape: BoxShape
                        .circle, // Circle shape does not need borderRadius
                  ),
                  defaultTextStyle: const TextStyle(color: Colors.white),
                ),
                headerStyle: HeaderStyle(
                  titleTextFormatter: (date, locale) =>
                      DateFormat('MMM : yyyy', locale).format(date),
                  leftChevronIcon:
                      const Icon(Icons.chevron_left, color: Colors.white),
                  rightChevronIcon:
                      const Icon(Icons.chevron_right, color: Colors.white),
                  titleTextStyle: const TextStyle(
                    fontSize: 23,
                    color: Colors.white,
                    fontFamily: 'Ledger',
                  ),
                  titleCentered: true,
                  formatButtonVisible: false,
                ),
                firstDay: DateTime.utc(2020, 1, 1),
                lastDay: DateTime.utc(2050, 12, 31),
                focusedDay: focusedDay,
                calendarFormat: calendarFormat,
                selectedDayPredicate: (day) => isSameDay(day, selectedDay),
                onDaySelected: (selectedDay, focusedDay) {
                  if (mounted) {
                    setState(() {
                      this.selectedDay = selectedDay;
                      this.focusedDay = focusedDay;
                    });
                  }
                  _fetchJournals(
                    year: selectedDay.year.toString(),
                    month: selectedDay.month.toString().padLeft(2, '0'),
                    day: selectedDay.day.toString().padLeft(2, '0'),
                  );
                },
                onHeaderTapped: (date) async {
                  int? result = await showYearMonthDialog(context);
                  if (result != null) {
                    if (result == 1) {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) =>
                              Journalyearpage(selectYear: selectedYear.year),
                        ),
                      );
                    } else {
                      if (mounted) {
                        setState(() {
                          selectedYear = date;
                        });
                      }
                      await _fetchJournals(
                        year: selectedYear.year.toString(),
                        month: selectedYear.month.toString().padLeft(2, '0'),
                      );
                    }
                  }
                },
                onPageChanged: (focusedDay) {
                  this.focusedDay = focusedDay;
                },
              ),
            ),
            const SliverToBoxAdapter(
              child: Padding(
                padding: EdgeInsets.symmetric(vertical: 0, horizontal: 16),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      "Month Journals",
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 24,
                        fontFamily: 'Ledger',
                      ),
                    ),
                  ],
                ),
              ),
            ),
            isLoading
                ? SliverToBoxAdapter(
                    child: Center(
                      child: LoadingAnimationWidget.discreteCircle(
                        color: Colors.white,
                        size: 50,
                      ),
                    ),
                  )
                : errorMessage.isNotEmpty
                    ? SliverToBoxAdapter(
                        child: Center(
                          child: Text(
                            errorMessage,
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 18.sp,
                            ),
                          ),
                        ),
                      )
                    : SliverList(
                        delegate: SliverChildBuilderDelegate(
                          (context, index) {
                            final journal = filteredJournals[index];
                            if (journal['entries'] != null &&
                                journal['entries'].isNotEmpty) {
                              return Column(
                                children: List.generate(
                                  journal['entries'].length,
                                  (entryIndex) {
                                    final entry =
                                        journal['entries'][entryIndex];
                                    return JournalData(
                                      id: entry['_id'] ?? 'No Id',
                                      title: entry['title'] ?? 'No Title',
                                      date: journal['date'] ?? 'No Date',
                                      content: entry['content'] ?? 'No Content',
                                    );
                                  },
                                ),
                              );
                            } else {
                              return const Center(
                                child: Text(
                                  'No Entries Found',
                                  style: TextStyle(color: Colors.white),
                                ),
                              );
                            }
                          },
                          childCount: filteredJournals.length,
                        ),
                      ),
            const SliverToBoxAdapter(
              child: SizedBox(height: 5),
            ),
            const SliverToBoxAdapter(
              child: SizedBox(height: 5),
            ),
          ],
        ),
      ),
    );
  }

  Future<int?> showYearMonthDialog(BuildContext context) async {
    return showDialog<int>(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          backgroundColor: const Color(0xff537F5C),
          title: const Text('Select Year or Month',
              style: TextStyle(color: Colors.white)),
          actions: <Widget>[
            TextButton(
              onPressed: () {
                Navigator.of(context).pop(1); // Return 1 when Year is tapped
              },
              child: const Text('Year', style: TextStyle(color: Colors.white)),
            ),
            TextButton(
              onPressed: () {
                Navigator.of(context).pop(0); // Return 0 when Month is tapped
              },
              child: const Text(
                'Month',
                style: TextStyle(color: Colors.white),
              ),
            ),
          ],
        );
      },
    );
  }
}
