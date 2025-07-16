import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:http/http.dart' as http;
import 'package:splash_onboarding_test/Registeration/auth_service.dart';
import 'package:splash_onboarding_test/components/Ellipses.dart';
import 'package:splash_onboarding_test/constant/Colors.dart';
import 'package:splash_onboarding_test/views/widgets/back_to_home_btn.dart';
import 'package:url_launcher/url_launcher.dart';

class Resultpage2 extends StatefulWidget {
  final String diseaseName; // Take the disease name from the previous page

  const Resultpage2({super.key, required this.diseaseName});

  @override
  _Resultpage2State createState() => _Resultpage2State();
}

class _Resultpage2State extends State<Resultpage2> {
  String? description; // For holding the fetched disease description
  String? link; // For holding the fetched link
  bool isLoading = true;
  String? errorMessage;
  String? token; // Store the fetched token

  @override
  void initState() {
    super.initState();
    fetchDiseaseDescription(); // Fetch the disease description when the page loads
  }

  // Function to fetch token from shared preferences
  Future<String?> getToken() async {
    final String? token = await AuthService.getToken();
    if (token == null) {
      print('No token found');
    } else {
      print('Retrieved Token: $token');
    }
    return token;
  }

  Future<void> fetchDiseaseDescription() async {
    String? token = await getToken();
    bool? isGuest = await AuthService.isGuest();

    if (token == null && !isGuest!) {
      setState(() {
        errorMessage = 'Token not found. Please login again.';
        isLoading = false;
      });
      return;
    }

    String url;
    if (isGuest!) {
      url =
          'https://gpappapis.azurewebsites.net/api/guest/test/GeneralTest/${widget.diseaseName}';
    } else {
      url =
          'https://gpappapis.azurewebsites.net/api/test/GeneralTest/${widget.diseaseName}';
    }

    print('Token used in request: $token');
    print('URL used in request: $url');

    final response = await http.get(
      Uri.parse(url),
      headers: {
        if (!isGuest) 'Authorization': token!,
      },
    );

    print('Status Code: ${response.statusCode}');
    print('Response Body: ${response.body}');

    if (response.statusCode == 200) {
      final data = jsonDecode(response.body);
      if (mounted) {
        setState(() {
          description = data['description'];
          link = data['link'];
          isLoading = false;
        });
      }
    } else if (response.statusCode == 401) {
      setState(() {
        errorMessage = 'Invalid token. Please login again.';
        isLoading = false;
      });
    } else {
      setState(() {
        errorMessage =
            'Failed to load description. Status code: ${response.statusCode}';
        isLoading = false;
      });
    }
  }

  // Function to launch URL
  Future<void> _launchUrl(String urlString) async {
    final Uri url = Uri.parse(urlString);
    if (!await launchUrl(url)) {
      throw Exception('Could not launch $url');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: <Widget>[
          // Background
          Container(
            decoration: BoxDecoration(
              color: primaryColor,
            ),
          ),
          Center(
            child: Image.asset(
              'assets/NewProject-2-svg-1.png',
              //color: Colors.white.withOpacity(.3),
              fit: BoxFit.cover,
            ),
          ),
          Column(
            children: [
              Expanded(
                child: SingleChildScrollView(
                  child: Column(
                    children: [
                      Container(
                        margin: const EdgeInsets.symmetric(
                          horizontal: 15,
                          vertical: 50,
                        ),
                        padding: const EdgeInsets.all(5),
                        decoration: BoxDecoration(
                          color: Colors.white.withOpacity(0.06),
                          borderRadius: BorderRadius.circular(15),
                          border: Border.all(
                            color: Colors.white,
                          ),
                        ),
                        child: Column(
                          children: [
                            Image.asset("assets/logo.png"),
                            const SizedBox(height: 10),
                            isLoading
                                ? const CircularProgressIndicator() // Show loading spinner while fetching data
                                : errorMessage != null
                                    ? Text(
                                        errorMessage!,
                                        style: const TextStyle(
                                            color: Colors.red, fontSize: 18),
                                      )
                                    : Text(
                                        description ??
                                            "No description available", // Show fetched description or fallback
                                        textAlign: TextAlign.center,
                                        style: const TextStyle(
                                          color: Colors.white,
                                          fontSize: 21,
                                          fontFamily: "Ledger",
                                        ),
                                      ),
                            const SizedBox(height: 30),
                            Container(
                              margin:
                                  const EdgeInsets.symmetric(horizontal: 10),
                              padding: const EdgeInsets.symmetric(
                                  horizontal: 5, vertical: 10),
                              decoration: BoxDecoration(
                                color: backgroundColor,
                                borderRadius: BorderRadius.circular(10),
                              ),
                              child: Column(
                                children: [
                                  Row(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      const Expanded(
                                        flex: 6,
                                        child: Text(
                                          "If you want to know more about this disorder",
                                          softWrap: true,
                                          overflow: TextOverflow.clip,
                                          style: TextStyle(
                                            fontSize: 18,
                                            fontFamily: "Inter",
                                            fontWeight: FontWeight.w500,
                                          ),
                                        ),
                                      ),
                                      IconButton(
                                        padding: EdgeInsetsDirectional.zero,
                                        onPressed: () {},
                                        icon: Icon(
                                          FontAwesomeIcons.caretDown,
                                          color: secondryColor,
                                        ),
                                      ),
                                    ],
                                  ),
                                  const SizedBox(height: 10),
                                  GestureDetector(
                                    onTap: () {
                                      if (link != null) {
                                        // Launch URL
                                        _launchUrl(link!);
                                      }
                                    },
                                    child: Text(
                                      link != null
                                          ? link!
                                          : "No additional information available",
                                      style: const TextStyle(
                                        fontFamily: "Inter",
                                        fontSize: 13,
                                        fontWeight: FontWeight.w500,
                                        color: Color(0xff1D17D1),
                                        decoration: TextDecoration.underline,
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            const SizedBox(height: 25),
                          ],
                        ),
                      ),
                      IntrinsicHeight(
                        child: Row(
                          crossAxisAlignment: CrossAxisAlignment.stretch,
                          children: [
                            const Expanded(
                              flex: 1,
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.end,
                                children: [EllipsesInResultpage()],
                              ),
                            ),
                            Expanded(
                              flex: 8,
                              child: Column(
                                children: [
                                  SizedBox(
                                    width:
                                        MediaQuery.of(context).size.width * 0.9,
                                    child: const Text(
                                      "But don’t worry. we’re here to join you through your healing journey, so we’ve designed comprehensive guidelines specifically tailored to support your mental well-being",
                                      softWrap: true,
                                      style: TextStyle(
                                        fontFamily: "Ledger",
                                        fontSize: 21,
                                        color: Colors.white,
                                      ),
                                      textAlign: TextAlign.center,
                                    ),
                                  )
                                ],
                              ),
                            ),
                            const Expanded(
                              flex: 1,
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.start,
                                children: [EllipsesInResultpage()],
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              // Button Bar
              const Column(
                children: [
                  SizedBox(height: 15),
                  // Guidelines Button
                  /* Container(
                    width: 200,
                    height: 44,
                    decoration: BoxDecoration(
                      border: Border.all(width: 1, color: Colors.white),
                      borderRadius: BorderRadius.circular(20),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withOpacity(.25),
                          spreadRadius: 0,
                          blurRadius: 4,
                          offset: const Offset(0, 4),
                        ),
                      ],
                    ),
                    child: ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: const Color(0xff618969),
                        shadowColor: const Color(0xff537F5C),
                        alignment: Alignment.center,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(20),
                        ),
                      ),
                      onPressed: () {
                        // Handle guidelines button press
                      },
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            'Guidelines', // Button text
                            style: TextStyle(
                              color: const Color(0xffD9D9D9), // Text color
                              fontSize: 23, // Text size
                              shadows: [
                                Shadow(
                                  color: Colors.black
                                      .withOpacity(0.5), // Shadow color
                                  offset: const Offset(2, 2), // Shadow offset
                                  blurRadius: 4, // Shadow blur radius
                                ),
                              ],
                            ),
                          ),
                          const Icon(
                            FontAwesomeIcons.arrowRight,
                            color: Colors.white,
                            size: 18,
                          ),
                        ],
                      ),
                    ),
                  ),*/
                  SizedBox(
                    height: 10,
                  ),
                  BackTohomeBtn(),
                  SizedBox(
                    height: 10,
                  ),
                ],
              ),
            ],
          ),
        ],
      ),
    );
  }
}
