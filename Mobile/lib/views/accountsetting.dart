import 'dart:convert';
import 'dart:typed_data';

import 'package:awesome_snackbar_content/awesome_snackbar_content.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:http/http.dart' as http;
import 'package:image/image.dart' as img;
import 'package:splash_onboarding_test/Registeration/registeration.dart';
import 'package:splash_onboarding_test/helpers/show_snackbar.dart';
import 'package:splash_onboarding_test/views/ConatctUspage/contactUsPage.dart';
import 'package:splash_onboarding_test/views/changepassword.dart';
import 'package:splash_onboarding_test/views/edituserprofile.dart';
import 'package:splash_onboarding_test/views/firebase_notifications/firebase_notifications.dart';
import 'package:splash_onboarding_test/views/reasonfordeleteaccount.dart';
import 'package:splash_onboarding_test/widgets/custom_app_bar.dart';

import '../Registeration/auth_service.dart';

class Accountsetting extends StatefulWidget {
  const Accountsetting({super.key});

  @override
  State<Accountsetting> createState() => _AccountsettingState();
}

class _AccountsettingState extends State<Accountsetting> {
  final FirebaseNotifications _firebaseNotifications = FirebaseNotifications();
  // Variables to store image and name
  String? userImage;
  String? userName = '';
  String? userEmail;
  String? userBio;
  String? userGender;
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    _fetchUserProfile();
  }

  Future<Uint8List> _resizeImage(String base64String) async {
    // Decode base64 string to bytes
    final bytes = base64Decode(base64String.replaceFirst(
        RegExp(r'data:image\/[a-zA-Z]+;base64,'), ''));

    // Decode image using the image package
    img.Image? image = img.decodeImage(Uint8List.fromList(bytes));

    // Check if the image is valid
    if (image == null) {
      throw Exception("Could not decode image");
    }

    // Resize the image (you can adjust width and height as needed)
    img.Image resizedImage =
        img.copyResize(image, width: 100); // Change width and height as needed

    // Convert the resized image back to bytes
    return Uint8List.fromList(
        img.encodeJpg(resizedImage)); // Use encodePng if you want a PNG format
  }

  Future<void> _fetchUserProfile() async {
    final token = await getToken();
    if (token == null) return;

    // Retrieve username from shared preferences
    /* userName = await AuthService.getUsername();
    if (userName == null) {
      print("No username found");
      return;
    }*/

    // Use the username in the API URL
    final url =
        Uri.parse('https://gpappapis.azurewebsites.net/api/user/profile');

    final response = await http.get(
      url,
      headers: {
        'Authorization': token,
        'Content-Type': 'application/json',
      },
    );

    if (response.statusCode == 200) {
      final data = jsonDecode(response.body);

      if (mounted) {
        setState(() {
          userName = data['name'];
          userImage = data['picture'];
          userEmail = data['email'];
          userBio = data['bio'];
          userGender = data['gender'];
          isLoading = false;
        });
      }
      print("Fetched Name: $userName");
      print("Fetched Image (base64): $userImage");
    } else {
      print("Failed to fetch profile, status code: ${response.body}");
      setState(() {
        isLoading = false; // Ensure loading state is cleared even on failure
      });
    }
  }

  void _deleteaccount(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(20),
          ),
          backgroundColor: const Color(0xff537F5C).withOpacity(.88),
          elevation: 20, // Add elevation for the shadow
          shadowColor: Colors.black.withOpacity(0.25), // Customize shadow color
          content: SizedBox(
            height: 420.h,
            width: 320.w,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                SizedBox(
                  height: 20.h,
                ),
                // SizedBox(height: 60),
                Image.asset('assets/deleteimage.png'),
                SizedBox(
                  height: 20.h,
                ),
                Text(
                  "Are you sure you want to delete your account?",
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 22.sp,
                    fontFamily: 'InriaSans-Regular',
                  ),
                  textAlign: TextAlign.center,
                ),
                SizedBox(height: 20.h),
                Container(
                  width: 240.w,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(15),
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
                    onPressed: () {
                      Navigator.pushReplacement(
                        context,
                        MaterialPageRoute(
                            builder: (context) => const DeleteAccountScreen()),
                      );
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color(0xffA71C1C).withOpacity(.88),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(15),
                      ),
                      padding: const EdgeInsets.symmetric(vertical: 12),
                    ),
                    child: Text(
                      "Confirm",
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 22.sp,
                        fontFamily: 'InriaSans-Bold',
                      ),
                    ),
                  ),
                ),
                SizedBox(height: 20.h),
                Container(
                  width: 240.w,
                  decoration: const BoxDecoration(
                      /* boxShadow: [
                      BoxShadow(
                        color: Colors.black
                            .withOpacity(0.25), // Shadow color with opacity
                        spreadRadius: 2, // How much the shadow spreads
                        blurRadius: 4, // How blurry the shadow is
                        offset: Offset(2, 4), // Offset the shadow
                      ),
                    ],*/
                      ),
                  child: OutlinedButton(
                    onPressed: () {
                      Navigator.of(context).pop();
                    },
                    style: OutlinedButton.styleFrom(
                      //elevation: 1,
                      side: const BorderSide(color: Colors.white, width: 1),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10),
                      ),
                      padding: const EdgeInsets.symmetric(vertical: 12),
                    ),
                    child: Text(
                      "Cancel",
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 22.sp,
                        fontFamily: 'InriaSans-Regular',
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  void _logout(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(20),
          ),
          backgroundColor: const Color(0xff537F5C).withOpacity(.88),
          elevation: 20,
          shadowColor: Colors.black.withOpacity(0.25),
          content: SizedBox(
            height: 320.h,
            width: 320.w,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                SizedBox(height: 60.h),
                Text(
                  "Are you sure you want to logout?",
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 22.sp,
                    fontFamily: 'InriaSans-Regular',
                  ),
                  textAlign: TextAlign.center,
                ),
                SizedBox(height: 20.h),
                Container(
                  width: 240.w,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(15),
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
                    onPressed: () async {
                      // Call logout method from FirebaseNotifications class
                      await _firebaseNotifications.logout(); // Remove FCM token

                      // Send logout API request
                      final response = await _sendLogoutRequest();

                      if (response.statusCode == 200) {
                        await FirebaseMessaging.instance.deleteToken();
                        // Logout successful, navigate to login screen
                        showSnackbar(
                          context,
                          'Logged Out',
                          'You have successfully logged out.',
                          ContentType.success,
                        );
                        // Clear all data
                        await AuthService.clearAllData();
                        Navigator.pushReplacement(
                          context,
                          MaterialPageRoute(
                            builder: (context) => const Registeration(),
                          ),
                        );
                      } else {
                        // Failed to logout, show error
                        showSnackbar(
                          context,
                          'LogOut',
                          'Failed to Logout',
                          ContentType.failure,
                        );
                      }
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color(0xffA71C1C).withOpacity(.88),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(15),
                      ),
                      padding: const EdgeInsets.symmetric(vertical: 12),
                    ),
                    child: Text(
                      "Confirm",
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 22.sp,
                        fontFamily: 'InriaSans-Bold',
                      ),
                    ),
                  ),
                ),
                SizedBox(height: 20.h),
                SizedBox(
                  width: 240.w,
                  child: OutlinedButton(
                    onPressed: () {
                      Navigator.of(context).pop();
                    },
                    style: OutlinedButton.styleFrom(
                      side: const BorderSide(color: Colors.white, width: 1),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10),
                      ),
                      padding: const EdgeInsets.symmetric(vertical: 12),
                    ),
                    child: Text(
                      "Cancel",
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 22.sp,
                        fontFamily: 'InriaSans-Regular',
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  Future<http.Response> _sendLogoutRequest() async {
    final token = await getToken();
    final url = Uri.parse('https://gpappapis.azurewebsites.net/api/logout');
    final headers = {'Authorization': '$token'};

    final response = await http.post(url, headers: headers);
    return response;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFFFFAEF),
      appBar: const CustomAppBar(
        text: 'Profile Settings',
      ),
      body: isLoading
          ? const Center(
              child: SpinKitFadingCube(
                color: Color(0xff537F5C),
                size: 50.0,
              ),
            )
          : SingleChildScrollView(
              child: Column(
                children: [
                  Padding(
                    padding: EdgeInsets.only(top: 30.h),
                    child: Center(
                        child: Center(
                            child: Center(
                                child: Stack(
                      alignment: Alignment.center,
                      children: [
                        SizedBox(
                          width: 160.w, // Adjust the width as needed
                          height: 160.h, // Adjust the height as needed
                          child: ClipOval(
                            child: userImage != null
                                ? FutureBuilder<Uint8List>(
                                    future: _resizeImage(
                                        userImage!), // Call the resizing function
                                    builder: (context, snapshot) {
                                      if (snapshot.connectionState ==
                                          ConnectionState.waiting) {
                                        return const CircularProgressIndicator(); // Show a loading indicator while resizing
                                      } else if (snapshot.hasError) {
                                        return Container(); // Optionally, show nothing or a placeholder if there's an error
                                      } else {
                                        return Image.memory(
                                          snapshot.data!,
                                          fit: BoxFit.cover,
                                        );
                                      }
                                    },
                                  )
                                : Container(), // Show nothing if userImage is null
                          ),
                        ),
                        // Positioned(
                        //   bottom: 5
                        //       .h, // Adjust this value to position the icon higher or lower
                        //   right: 8
                        //       .w, // Adjust this value to position the icon more to the right or left
                        //   child: Container(
                        //     width: 35.w, // Adjust the size of the circle
                        //     height: 35.h,
                        //     decoration: BoxDecoration(
                        //       color: Colors.black.withOpacity(
                        //           0.6), // Background color for the circle
                        //       shape: BoxShape.circle,
                        //     ),
                        //     child: IconButton(
                        //       icon: Icon(Icons.edit,
                        //           color: const Color(0xffCCCCCC),
                        //           size: 20.sp), // Edit icon
                        //       onPressed: () {
                        //         // Define the action for the edit button here
                        //       },
                        //     ),
                        //   ),
                        // ),
                      ],
                    )))),
                  ),
                  SizedBox(
                    height: 20.h,
                  ),
                  Text(
                    userName!,
                    style: TextStyle(
                        color: const Color(0xff3B5D44),
                        fontSize: 24.sp,
                        fontFamily: 'InriaSerif'),
                  ),
                  SizedBox(
                    height: 30.h,
                  ),
                  Container(
                    decoration: BoxDecoration(
                        border: Border.all(color: const Color(0xff537F5C)),
                        borderRadius: BorderRadius.circular(20)),
                    height: 270.h,
                    width: 320.w,
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        ListTile(
                          leading:
                              const Icon(Icons.edit, color: Color(0xff537F5C)),
                          title: const Text('Edit profile',
                              style: TextStyle(
                                  color: Color(0xff537F5C),
                                  fontFamily: 'InriaSans')),
                          trailing: const Icon(Icons.arrow_forward,
                              color: Color(0xff537F5C)),
                          onTap: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => EditUserProfile(
                                  userData: {
                                    "name": userName,
                                    "picture": userImage,
                                    "email": userEmail,
                                    "bio": userBio,
                                    "gender": userGender,
                                  },
                                ),
                              ),
                            );
                          },
                        ),
                        ListTile(
                          leading: const Icon(
                            Icons.lock,
                            color: Color(0xff537F5C),
                          ),
                          title: const Text('Change Password',
                              style: TextStyle(
                                  color: Color(0xff537F5C),
                                  fontFamily: 'InriaSans')),
                          trailing: const Icon(Icons.arrow_forward,
                              color: Color(0xff537F5C)),
                          onTap: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) => const ChangePassword()),
                            );
                          },
                        ),
                        ListTile(
                          leading: const Icon(Icons.logout,
                              color: Color(0xff537F5C)),
                          title: const Text('Logout',
                              style: TextStyle(
                                  color: Color(0xff537F5C),
                                  fontFamily: 'InriaSans')),
                          trailing: const Icon(Icons.arrow_forward,
                              color: Color(0xff537F5C)),
                          onTap: () {
                            _logout(context);
                          },
                        ),
                        ListTile(
                          leading: Icon(Icons.delete,
                              color: const Color(0xffC31313).withOpacity(.74)),
                          title: Text('Delete Account',
                              style: TextStyle(
                                  color:
                                      const Color(0xffC31313).withOpacity(.74),
                                  // fontSize: 20,
                                  fontFamily: 'InriaSans-Bold')),
                          trailing: Icon(Icons.arrow_forward,
                              color: const Color(0xffC31313).withOpacity(.74)),
                          onTap: () {
                            _deleteaccount(context);
                          },
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(
                    height: 20,
                  ),
                  //  BarButton()
                ],
              ),
            ),
    );
  }
}
