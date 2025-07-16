// auth_service.dart
import 'package:shared_preferences/shared_preferences.dart';

class AuthService {
  // Save token, email, and username
  static Future<void> saveLoginInfo(String token, String email, String username,String userId, 
      {bool isGuest = false}) async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setString('authToken', token);
    await prefs.setString('email', email);
    await prefs.setString('username', username);
     await prefs.setString('user_id', userId); 
    await prefs.setBool('isGuest', isGuest);
    print('Token, email, username,user_id:$userId,IsGuest: $isGuest');
  }


  static Future<String?> getUserId() async {
  final SharedPreferences prefs = await SharedPreferences.getInstance();
  return prefs.getString('user_id');
}

  static Future<void> saveSessionCookie(String sessionCookie) async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setString('sessionCookie', sessionCookie);
    print('Session Cookie Saved: $sessionCookie');
  }

  // Get session cookie
  static Future<String?> getSessionCookie() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    return prefs.getString('sessionCookie');
  }

  // set  update token
  static Future<void> setToken(String token) async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setString('authToken', token);
  }

  // Get token
  static Future<String?> getToken() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    return prefs.getString('authToken');
  }

  // Get email
  static Future<String?> getEmail() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    return prefs.getString('email');
  }

  // Get username
  static Future<String?> getUsername() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    return prefs.getString('username') ?? '';
  }

  static setIsGuest(bool isGuest) async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setBool('isGuest', isGuest);
  }

  // Check if user is a guest
  static Future<bool?> isGuest() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    return prefs.getBool('isGuest');
  }

// Update email and username in SharedPreferences
  static Future<void> updateLoginInfo({String? email, String? username}) async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();

    if (email != null) {
      await prefs.setString('email', email);
      print('Updated email: $email');
    }

    if (username != null) {
      await prefs.setString('username', username);
      print('Updated username: $username');
    }
  }

  // Clear all data
  static Future<void> clearAllData() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.clear();
  }

 // set is logged in
  static Future<void> setIsLoggedIn(bool isLoggedIn) async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setBool('isLoggedIn', isLoggedIn);
  }

  static Future<bool?> getIsLoggedIn() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    return  false;
  }
}
