import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:shared_preferences/shared_preferences.dart';

class FirebaseNotifications {
  final FirebaseMessaging _firebaseMessaging = FirebaseMessaging.instance;
  late FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin;

  FirebaseNotifications() {
    // Initialize flutter local notifications
    flutterLocalNotificationsPlugin = FlutterLocalNotificationsPlugin();
    _initializeLocalNotifications();
  }

  Future<void> initNotifications() async {
    // Request permission for notifications
    await _firebaseMessaging.requestPermission();

    // Get the Firebase token
    String? fcmToken = await _firebaseMessaging.getToken();
    print("fcmToken============================$fcmToken");
    // Save the token locally using SharedPreferences
    if (fcmToken != null) {
      await _saveToken(fcmToken);
    }

    // Listen for foreground notifications
    FirebaseMessaging.onMessage.listen((RemoteMessage message) {
      _showForegroundNotification(message.notification);
    });
  }

  // Initialize local notifications
  Future<void> _initializeLocalNotifications() async {
    const AndroidInitializationSettings initializationSettingsAndroid =
        AndroidInitializationSettings('@mipmap/ic_launcher');

    const InitializationSettings initializationSettings = 
    InitializationSettings(android: initializationSettingsAndroid);

    // Updated to use the new `onDidReceiveNotificationResponse` callback
    await flutterLocalNotificationsPlugin.initialize(
      initializationSettings,
      onDidReceiveNotificationResponse: (NotificationResponse response) {
        _onSelectNotification(response.payload);
      },
    );
  }

  // Handle notification tap
  Future<void> _onSelectNotification(String? payload) async {
    if (payload != null) {
      // Handle what happens when the user taps the notification
      print('Notification payload: $payload');
    }
  }

  // Show notification when the app is in the foreground
  Future<void> _showForegroundNotification(
      RemoteNotification? notification) async {
    if (notification != null &&
        notification.title != null &&
        notification.body != null) {
      const AndroidNotificationDetails androidPlatformChannelSpecifics =
          AndroidNotificationDetails(
        'your_channel_id',
        'your_channel_name',
        importance: Importance.max,
        priority: Priority.high,
        showWhen: true, // Set to true to show timestamp
      );

      const NotificationDetails platformChannelSpecifics =
          NotificationDetails(android: androidPlatformChannelSpecifics);

      await flutterLocalNotificationsPlugin.show(
        notification.hashCode,
        notification.title,
        notification.body,
        platformChannelSpecifics,
      );
    }
  }

  // Show notification when button is pressed
  Future<void> showNotificationOnButtonPress(String title, String body) async {
    const AndroidNotificationDetails androidPlatformChannelSpecifics =
        AndroidNotificationDetails(
      'your_channel_id',
      'your_channel_name',
      importance: Importance.max,
      priority: Priority.high,
      showWhen: true,
    );

    const NotificationDetails platformChannelSpecifics =
        NotificationDetails(android: androidPlatformChannelSpecifics);

    await flutterLocalNotificationsPlugin.show(
      0,
      title,
      body,
      platformChannelSpecifics,
      payload: 'Notification Payload', // Add payload if needed
    );
  }

  // Function to save token in SharedPreferences
  Future<void> _saveToken(String fcmToken) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setString('fcm_token', fcmToken);
  }

  // Function to get token from SharedPreferences
  Future<String?> getTokenFromPreferences() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();

    return prefs.getString('fcm_token');
  }

  // Function to log out and remove the token
  Future<void> logout() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.remove('fcm_token');
    print('Token removed from SharedPreferences');
  }
}
