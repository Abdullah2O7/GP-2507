import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:http/http.dart' as http;
import 'package:loading_animation_widget/loading_animation_widget.dart';
import 'package:splash_onboarding_test/Registeration/auth_service.dart';
import 'package:splash_onboarding_test/constant/Colors.dart';

import '../../widgets/custom_app_bar.dart';

class Contact {
  final String contactType;
  final String way;

  Contact({required this.contactType, required this.way});

  factory Contact.fromJson(Map<String, dynamic> json) {
    return Contact(
      contactType: json['contact'],
      way: json['way'],
    );
  }
}

Future<List<Contact>> fetchContacts() async {
  final String? token = await getToken();
  final response = await http.get(
    Uri.parse('https://gpappapis.azurewebsites.net/api/contact_support'),
    headers: {
      'Authorization': token ?? '',
    },
  );

  if (response.statusCode == 200) {
    final jsonData = json.decode(response.body);
    final List<Contact> contacts = (jsonData['Contacts'] as List)
        .map((contact) => Contact.fromJson(contact))
        .toList();
    return contacts;
  } else {
    throw Exception('Failed to load contacts');
  }
}

class ContactUsPage extends StatelessWidget {
  const ContactUsPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF537F5C),
      appBar: const CustomAppBar(
        text: 'Contact Us',
      ),
      body: Container(
        color: const Color(0xffFFFAEF),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Expanded(
              child: Padding(
                padding: EdgeInsets.symmetric(horizontal: 20.w),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      "We’re here to help!",
                      style: TextStyle(
                          fontFamily: "InriaSans",
                          color: const Color(0xff537F5C),
                          fontSize: 24.sp,
                          fontWeight: FontWeight.w500),
                    ),
                    SizedBox(height: 10.h),
                    Text(
                      "If you have any questions, feedback, or need support, feel free to reach out to us. Our team is always ready to assist you.",
                      style: TextStyle(
                          fontFamily: "InriaSans-Light",
                          fontSize: 18.sp,
                          color: const Color(0xff537F5C),
                          height: 1.1.h),
                    ),
                    SizedBox(height: 40.h),
                    Text(
                      "Contact us through these channels:",
                      style: TextStyle(
                        color: const Color(0xff537F5C),
                        fontSize: 18.sp,
                        fontFamily: 'InriaSans-Bold',
                      ),
                    ),
                    SizedBox(height: 10.h),
                    Expanded(
                      child: FutureBuilder<List<Contact>>(
                        future: fetchContacts(),
                        builder: (context, snapshot) {
                          if (snapshot.connectionState ==
                              ConnectionState.waiting) {
                            return Center(
                                child: LoadingAnimationWidget.discreteCircle(
                              color: Colors.white,
                              size: 50.h,
                            ));
                          } else if (snapshot.hasError) {
                            return Center(
                                child: Text(
                              'Error: ${snapshot.error}',
                              style: TextStyle(fontSize: 14.sp),
                            ));
                          } else if (!snapshot.hasData ||
                              snapshot.data!.isEmpty) {
                            return Center(
                                child: Text(
                              'No contact information available',
                              style: TextStyle(fontSize: 14.sp),
                            ));
                          }

                          final contacts = snapshot.data!;
                          return ListView.separated(
                            itemCount: contacts.length,
                            separatorBuilder: (context, index) => Divider(
                              color: primaryColor,
                              thickness: 1.w,
                            ),
                            itemBuilder: (context, index) {
                              final contact = contacts[index];
                              return Container(
                                decoration: BoxDecoration(
                                  color: const Color(0xffA8BFAD),
                                  borderRadius: BorderRadius.circular(10.r),
                                ),
                                margin: EdgeInsets.symmetric(vertical: 5.h),
                                child: ListTile(
                                  leading: _getIcon(contact.contactType),
                                  title: Text(
                                    contact.way,
                                    style: TextStyle(
                                      color: Colors.black,
                                      fontFamily: "Inter",
                                      fontSize: 14.sp,
                                      fontWeight: FontWeight.w400,
                                    ),
                                  ),
                                ),
                              );
                            },
                          );
                        },
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Icon _getIcon(String contactType) {
    switch (contactType) {
      case 'email':
        return Icon(FontAwesomeIcons.solidEnvelope,
            color: Colors.black, size: 20.sp);
      case 'phone':
        return Icon(FontAwesomeIcons.phone, color: Colors.black, size: 20.sp);
      case 'linkedin':
        return Icon(FontAwesomeIcons.linkedin,
            color: Colors.black, size: 20.sp);
      case 'facebook':
        return Icon(FontAwesomeIcons.facebook,
            color: Colors.black, size: 20.sp);
      case 'twitter':
        return Icon(FontAwesomeIcons.twitter, color: Colors.black, size: 20.sp);
      default:
        return Icon(Icons.help, color: Colors.black, size: 20.sp);
    }
  }
}

Future<String?> getToken() async {
  final String? token = await AuthService.getToken();
  if (token == null) {
    print('No token found');
  } else {
    print('Retrieved Token: $token');
  }
  return token;
}
