import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:loading_animation_widget/loading_animation_widget.dart';
import 'package:splash_onboarding_test/Registeration/auth_service.dart';

import 'package:splash_onboarding_test/views/LoginActivityPage/component/PreviosLogInCard.dart';
import 'package:splash_onboarding_test/widgets/custom_app_bar.dart';

class Loginactivitypage extends StatefulWidget {
  const Loginactivitypage({super.key});

  @override
  State<Loginactivitypage> createState() => _LoginactivitypageState();
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

class _LoginactivitypageState extends State<Loginactivitypage> {
  // Update the type to allow dynamic values
  List<Map<String, dynamic>> loginActivity = [];

  // Function to fetch login activity data
  Future<void> fetchLoginActivity() async {
    const url = 'https://gpappapis.azurewebsites.net/api/loginActivity';
    final token = await getToken();

    try {
      final response = await http.get(
        Uri.parse(url),
        headers: {
          'Authorization': '$token',
        },
      );

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        setState(() {
          loginActivity =
              List<Map<String, dynamic>>.from(data['login_activities']
                  .map((activity) => {
                        "LoginClock": activity['time'],
                        "LoginDevice": activity['mobile'],
                        "LoginDate": activity['date'],
                      })
                  .toList());
        });
      } else {
        debugPrint('Failed to load login activities');
      }
    } catch (e) {
      debugPrint('Error fetching login activities: $e');
    }
  }

  @override
  void initState() {
    super.initState();
    fetchLoginActivity(); // Fetch data when the page loads
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFFFFAEF),
      appBar: const CustomAppBar(
        text: 'Login activity',
      ),
      body: Container(
        color: const Color(0xFFFFFAEF),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            // Login Activity List
            Expanded(
              child: Container(
                padding: const EdgeInsets.all(5),
                margin: const EdgeInsets.all(15),
                decoration: BoxDecoration(
                  color: const Color(0xffA8BFAD),
                  // boxShadow: [
                  //   BoxShadow(
                  //     color: Colors.black.withOpacity(.10),
                  //     spreadRadius: 0,
                  //     blurRadius: 4,
                  //     offset: const Offset(0, 4),
                  //   ),
                  // ],
                  borderRadius: BorderRadius.circular(10),
                  border: Border.all(
                    width: 1,
                    color: Colors.black,
                  ),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      "Previous login",
                      style: TextStyle(
                          fontSize: 18,
                          color: Colors.black,
                          fontFamily: 'InriaSans'),
                    ),
                    const SizedBox(height: 5),
                    Flexible(
                      child: loginActivity.isNotEmpty
                          ? ListView.builder(
                              primary: true,
                              padding: EdgeInsets.zero,
                              itemCount: loginActivity.length,
                              itemBuilder: (context, index) {
                                final login = loginActivity[index];
                                return Previoslogincard(
                                  loginDate: login["LoginDate"].toString(),
                                  loginDevice: login["LoginDevice"].toString(),
                                  loginClock: login["LoginClock"].toString(),
                                );
                              },
                            )
                          : Center(
                              child: LoadingAnimationWidget.discreteCircle(
                              color: const Color(0xff537F5C),
                              size: 50,
                            )),
                    ),
                  ],
                ),
              ),
            ),

            // Button Bar
            // const BackTohomeBtn(), const SizedBox(height: 10),
          ],
        ),
      ),
    );
  }
}
