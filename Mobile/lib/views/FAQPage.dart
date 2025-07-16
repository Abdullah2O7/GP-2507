import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:http/http.dart' as http;
import 'package:loading_animation_widget/loading_animation_widget.dart';
import 'package:splash_onboarding_test/Registeration/auth_service.dart';
import 'package:splash_onboarding_test/components/FAQCard.dart';
import 'package:splash_onboarding_test/constant/Colors.dart';

// Declare the FAQPage class
class FAQPage extends StatefulWidget {
  const FAQPage({super.key});

  @override
  _FAQPageState createState() => _FAQPageState();
}

class _FAQPageState extends State<FAQPage> {
  List<Map<String, String>> faqList = [];
  List<Map<String, String>> filteredFaqList =
      []; // This will hold filtered FAQs
  bool isLoading = true;
  String? errorMessage;
  TextEditingController searchController =
      TextEditingController(); // For handling search input

  Future<String?> getToken() async {
    final String? token = await AuthService.getToken();
    if (token == null) {
      print('No token found');
    } else {
      print('Retrieved Token: $token');
    }
    return token;
  }

  Future<void> fetchFAQs() async {
    final token = await getToken(); // Fetch the JWT token
    if (token == null) {
      setState(() {
        errorMessage = "No token found. Please log in again.";
        isLoading = false;
      });
      return;
    }

    try {
      final response = await http.get(
        Uri.parse('https://gpappapis.azurewebsites.net/api/faq'),
        headers: {
          'Authorization': token,
        },
      );

      if (response.statusCode == 200) {
        final Map<String, dynamic> responseData = json.decode(response.body);

        if (responseData.containsKey('faq') && responseData['faq'] is List) {
          final List<dynamic> faqData = responseData['faq'];

          setState(() {
            faqList = faqData.map<Map<String, String>>((faq) {
              return {
                "Q": faq["question"].toString(),
                "A": faq["answer"].toString(),
              };
            }).toList();
            filteredFaqList = faqList; // Initially, show all FAQs
            isLoading = false;
          });
        } else {
          setState(() {
            errorMessage = "FAQ data is not in the expected format.";
            isLoading = false;
          });
        }
      } else {
        setState(() {
          errorMessage =
              "Failed to load FAQs. Status code: ${response.statusCode}";
          isLoading = false;
        });
      }
    } catch (e) {
      if (mounted) {
        setState(() {
          errorMessage = "An error occurred: $e";
          isLoading = false;
        });
      }
    }
  }

  void filterFAQs(String query) {
    setState(() {
      filteredFaqList = faqList
          .where((faq) => faq["Q"]!.toLowerCase().contains(query.toLowerCase()))
          .toList();
    });
  }

  @override
  void initState() {
    super.initState();
    fetchFAQs(); // Fetch the FAQ data when the page loads

    // Add a listener to search controller to filter FAQs in real-time
    searchController.addListener(() {
      filterFAQs(searchController.text);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xffFFFAEF),
      resizeToAvoidBottomInset: false,
      body: Column(
        children: [
          Stack(clipBehavior: Clip.none, children: [
            SizedBox(
              height: 230.h,
              child: Column(
                children: [
                  Container(
                    height: 220.h,
                    width: MediaQuery.of(context).size.width,
                    decoration: BoxDecoration(
                      color: primaryColor,
                      borderRadius: BorderRadius.only(
                        bottomLeft: Radius.circular(23.r),
                        bottomRight: Radius.circular(23.r),
                      ),
                    ),
                    child: Stack(
                      clipBehavior: Clip.none,
                      alignment: Alignment.bottomCenter,
                      children: [
                        Positioned(
                          top: 40.h,
                          left: 25.w,
                          child: IconButton(
                            icon: const Icon(Icons.arrow_back_ios),
                            color: Colors.white,
                            onPressed: () {
                              Navigator.of(context).pop();
                            },
                            iconSize: 25.sp,
                            padding: EdgeInsets.symmetric(
                                vertical: 3.h, horizontal: 9.w),
                            splashRadius: 25.sp,
                          ),
                        ),
                        SizedBox(
                          width: MediaQuery.of(context).size.width,
                          child: Column(
                            children: [
                              Image.asset(
                                "assets/logo1.png",
                                height: 130.h,
                                width: 170.w,
                              ),
                              Expanded(
                                child: Text(
                                  "How can we Help you?",
                                  textAlign: TextAlign.center,
                                  softWrap: true,
                                  style: TextStyle(
                                      color: Colors.white,
                                      fontSize: 24.sp,
                                      fontFamily: "Ledger"),
                                ),
                              ),
                              SizedBox(
                                height: 50.h,
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
            Positioned(
              bottom: -10.h,
              left: 0,
              right: 0,
              child: Padding(
                padding: EdgeInsets.symmetric(horizontal: 23.w),
                child: SizedBox(
                  height: 40.h,
                  width: MediaQuery.of(context).size.width * 0.9,
                  child: TextFormField(
                    style: const TextStyle(
                      color: Color(0xff3B5D44),
                    ),
                    controller: searchController,
                    cursorColor: const Color(0xff3B5D44),
                    decoration: InputDecoration(
                      filled: true,
                      fillColor: const Color(0xffFFFAEF),
                      prefixIcon:
                          const Icon(Icons.search, color: Color(0xFF3B5D44)),
                      suffixIcon:
                          const Icon(Icons.mic_none, color: Color(0xFF3B5D44)),
                      hintText: 'Search for question',
                      hintStyle: TextStyle(
                          color: const Color(0xFF3B5D44),
                          fontFamily: 'Ledger',
                          fontSize: 18.sp),
                      contentPadding: EdgeInsets.symmetric(vertical: 2.h),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(25.r),
                        borderSide: BorderSide(
                          color: Colors.black,
                          width: 1.2.w,
                        ),
                      ),
                      enabledBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(25.r),
                        borderSide: BorderSide(
                          color: const Color(0xFF3B5D44),
                          width: 1.2.w,
                        ),
                      ),
                      focusedBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(25.r),
                        borderSide: BorderSide(
                          color: const Color(0xFF3B5D44),
                          width: 1.2.w,
                        ),
                      ),
                    ),
                  ),
                ),
              ),
            ),
          ]),
          SizedBox(height: 20.h),
          Expanded(
            child: Stack(
              children: [
                if (isLoading)
                  Center(
                      child: LoadingAnimationWidget.discreteCircle(
                    color: Colors.white,
                    size: 50.h,
                  ))
                else if (errorMessage != null)
                  Center(child: Text(errorMessage!))
                else
                  Padding(
                    padding: EdgeInsets.only(bottom: 20.h),
                    child: Theme(
                      data: ThemeData(
                        scrollbarTheme: ScrollbarThemeData(
                          thumbColor: WidgetStateProperty.all(
                            const Color(0xff537F5C),
                          ),
                        ),
                      ),
                      child: SizedBox(
                        child: Scrollbar(
                          interactive: true,
                          radius: Radius.circular(40.r),
                          thickness: 10.w,
                          thumbVisibility: true,
                          child: ListView.builder(
                            padding: EdgeInsets.zero,
                            itemCount: filteredFaqList.length,
                            itemBuilder: (context, index) {
                              return FAQCard(
                                  Q: filteredFaqList[index]["Q"]!,
                                  A: filteredFaqList[index]["A"]!);
                            },
                          ),
                        ),
                      ),
                    ),
                  ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
