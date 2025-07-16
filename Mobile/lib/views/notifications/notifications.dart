import 'dart:convert'; // For JSON encoding and decoding

import 'package:firebase_messaging/firebase_messaging.dart'; // Import Firebase Messaging
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart'; // For responsive design
import 'package:http/http.dart' as http; // For making HTTP requests
import 'package:shared_preferences/shared_preferences.dart'; // For accessing shared preferences
import 'package:splash_onboarding_test/views/ConatctUspage/contactUsPage.dart';
import 'package:splash_onboarding_test/views/firebase_notifications/firebase_notifications.dart';
import 'package:splash_onboarding_test/widgets/custom_app_bar.dart';

class NotificationSettingsScreen extends StatefulWidget {
  const NotificationSettingsScreen({super.key});

  @override
  _NotificationSettingsScreenState createState() =>
      _NotificationSettingsScreenState();
}

class _NotificationSettingsScreenState
    extends State<NotificationSettingsScreen> {
  final FirebaseNotifications _firebaseNotifications = FirebaseNotifications();
  bool testReminder = false;
  bool progressUpdate = true;
  bool newsAndUpdates = false;
  bool reminderNotification = false;

  @override
  void initState() {
    super.initState();
    _loadInitialSettings();
  }

  Future<void> _loadInitialSettings() async {
    reminderNotification =
        await _firebaseNotifications.getTokenFromPreferences() != null;
    setState(() {});
  }

  Future<void> _handleNotificationToggle(bool value) async {
    setState(() {
      reminderNotification = value;
    });
    if (reminderNotification) {
      await _firebaseNotifications.initNotifications();
      String? fcmToken =
          await FirebaseMessaging.instance.getToken(); // Get the new FCM token
      if (fcmToken != null) {
        await _updateFCMToken(fcmToken);
      }
    } else {
      await _firebaseNotifications
          .logout(); // Remove token from shared preferences
      await FirebaseMessaging.instance.deleteToken();
    }
  }

  Future<void> _updateFCMToken(String fcmToken) async {
    final String? token = await getToken();
    const url = 'https://gpappapis.azurewebsites.net/api/update_fcm_token';

    final response = await http.put(
      Uri.parse(url),
      headers: {
        'Content-Type': 'application/json',
        'Authorization': token ?? '',
      },
      body: jsonEncode({'fcm_token': fcmToken}),
    );

    if (response.statusCode == 200) {
      print('FCM token updated successfully');
    } else {
      print('Failed to update FCM token: ${response.body}');
    }
  }

  Future<void> _toggleTestReminder(bool value) async {
    final prefs = await SharedPreferences.getInstance();
    final email = prefs.getString('email') ?? '';
    const url = 'https://gpappapis.azurewebsites.net/api/toggle_reminder';

    final response = await http.post(
      Uri.parse(url),
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode({
        'email': email,
        'reminder_enabled': value,
      }),
    );

    if (response.statusCode == 200) {
      final responseData = jsonDecode(response.body);
      _showResponseDialog(responseData['message']);
    } else {
      _showResponseDialog('Failed to update reminder');
    }
  }

  void _showResponseDialog(String message) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          backgroundColor: const Color(0xff537F5C),
          content: Text(
            message,
            style: TextStyle(color: Colors.white, fontSize: 14.sp),
          ),
          actions: <Widget>[
            TextButton(
              child: Text(
                "OK",
                style: TextStyle(color: Colors.white, fontSize: 14.sp),
              ),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFFFFAEF),
      appBar: const CustomAppBar(
        text: 'Notifications & Emails',
      ),
      body: Padding(
        padding: EdgeInsets.symmetric(horizontal: 27.w),
        child: ListView(
          children: [
            SizedBox(height: 5.h),
            Text(
              'Select the kind of notification you get about your activities and recommendations',
              style: TextStyle(
                  color: const Color(0xff3B5D44),
                  fontSize: 15.sp,
                  fontFamily: 'InriaSans-Light'),
            ),
            Divider(
              color: Colors.white.withOpacity(.18),
              thickness: 1.h,
              height: 20.h,
            ),
            buildSectionHeader('Email'),
            buildRoundedContainer([
              buildToggleSwitch('Test reminder', testReminder, (value) {
                setState(() {
                  testReminder = value;
                });
                _toggleTestReminder(value);
              }),
              buildToggleSwitch('Progress update', progressUpdate, (value) {
                setState(() {
                  progressUpdate = value;
                });
              }),
              buildToggleSwitch('News and updates', newsAndUpdates, (value) {
                setState(() {
                  newsAndUpdates = value;
                });
              }),
            ]),
            SizedBox(height: 30.h),
            buildSectionHeader('Push Notification'),
            buildRoundedContainer([
              buildToggleSwitch(
                'Reminder',
                reminderNotification,
                _handleNotificationToggle,
              ),
            ]),
            SizedBox(height: 20.h),
          ],
        ),
      ),
    );
  }

  Widget buildSectionHeader(String title) {
    return Padding(
      padding: EdgeInsets.symmetric(vertical: 10.h),
      child: Text(
        title,
        style: TextStyle(
          color: const Color(0xff3B5D44),
          fontSize: 20.sp,
          fontFamily: 'InriaSans-Bold',
        ),
      ),
    );
  }

  Widget buildToggleSwitch(
      String title, bool currentValue, ValueChanged<bool> onChanged) {
    return SwitchListTile(
      title: Text(title,
          style: TextStyle(
              color: const Color(0xff537F5C),
              fontFamily: 'InriaSans-Bold',
              fontSize: 18.sp)),
      value: currentValue,
      onChanged: onChanged,
      activeColor: const Color(0xffFFFAEF),
      inactiveThumbColor: Colors.white,
      activeTrackColor: const Color(0xff3B5D44).withOpacity(0.64),
      inactiveTrackColor: const Color(0xff6B7280).withOpacity(.16),
      
    );
  }


  Widget buildRoundedContainer(List<Widget> children) {
    return Container(
      decoration: BoxDecoration(
        border: Border.all(color: const Color(0xff537F5C)),
        color: const Color(0xFFFFFAEF),
        borderRadius: BorderRadius.circular(20.r),
      ),
      child: Column(
        children: children,
      ),
    );
  }
}
