import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:loading_animation_widget/loading_animation_widget.dart';
import 'package:splash_onboarding_test/Registeration/auth_service.dart';

import 'package:splash_onboarding_test/views/PreviosTestPage/component/ResultCard.dart';
import 'package:splash_onboarding_test/widgets/custom_app_bar.dart';

// Model class for Test
class Test {
  final String date;
  final String diseaseName;
  final String testName;

  Test({required this.date, required this.diseaseName, required this.testName});

  factory Test.fromJson(Map<String, dynamic> json) {
    return Test(
      date: json['date'],
      diseaseName: json['disease_name'],
      testName: json['testname'],
    );
  }
}

// Function to fetch tests from the API
Future<List<Test>> getTests() async {
  final String? token = await getToken(); // Your method to get the token
  final response = await http.get(
    Uri.parse('https://gpappapis.azurewebsites.net/api/previous_tests'),
    headers: {
      'Authorization': token ?? '',
    },
  );

  if (response.statusCode == 200) {
    final jsonData = json.decode(response.body);

    // Check if the message indicates no tests found
    if (jsonData['message'] == "No tests found") {
      return Future.error(jsonData['message']);
    }

    final List<Test> tests =
        (jsonData['tests'] as List).map((test) => Test.fromJson(test)).toList();

    return tests;
  } else {
    throw Exception('No tests yet');
  }
}

// Main widget for Previous Test Page
class Previoustestpage extends StatelessWidget {
  const Previoustestpage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      //backgroundColor: const Color(0xFFFFFAEF),
      appBar: const CustomAppBar(text: 'Tests history'),
      body: Container(
        color: const Color(0xFFFFFAEF),
        child: SafeArea(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              // Appbar

              // Result content
              Expanded(
                child: Container(
                  padding: const EdgeInsets.all(5),
                  margin: const EdgeInsets.all(15),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(10),
                    border: Border.all(width: 1, color: Colors.black),
                    // boxShadow: [
                    //   BoxShadow(
                    //     color: Colors.black.withOpacity(.10),
                    //     spreadRadius: 0,
                    //     blurRadius: 4,
                    //     offset: const Offset(0, 4),
                    //   ),
                    // ],
                  ),
                  child: FutureBuilder<List<Test>>(
                    future: getTests(),
                    builder: (context, snapshot) {
                      if (snapshot.connectionState == ConnectionState.waiting) {
                        return Center(
                          child: LoadingAnimationWidget.discreteCircle(
                            color: Colors.white,
                            size: 50,
                          ),
                        );
                      } else if (snapshot.hasError) {
                        return Center(child: Text('Error: ${snapshot.error}'));
                      } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
                        return const Center(child: Text('No tests available'));
                      }

                      final tests = snapshot.data!;
                      return Scrollbar(
                        thumbVisibility: true,
                        interactive: true,
                        thickness: 6,
                        radius: const Radius.circular(40),
                        child: ListView.builder(
                          itemCount: tests.length,
                          itemBuilder: (context, index) {
                            final test = tests[index];
                            return ResultCard(
                              testName: test.testName,
                              testResult:
                                  test.diseaseName, // or any relevant field
                              testDate: test.date,
                            );
                          },
                        ),
                      );
                    },
                  ),
                ),
              ),
              // ButtonBar
              // const BarButton(),
              const SizedBox(height: 10),
            ],
          ),
        ),
      ),
    );
  }
}

// Method to retrieve the token (stub)
Future<String?> getToken() async {
  final String? token = await AuthService.getToken();
  if (token == null) {
    print('No token found');
  } else {
    print('Retrieved Token: $token');
  }
  return token;
}
