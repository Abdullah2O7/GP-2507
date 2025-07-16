import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:loading_animation_widget/loading_animation_widget.dart';
import 'package:splash_onboarding_test/Registeration/auth_service.dart';
import 'package:splash_onboarding_test/constant/Colors.dart';
import 'package:splash_onboarding_test/views/ConatctUspage/contactUsPage.dart';
import 'package:splash_onboarding_test/views/FAQPage.dart';
import 'package:splash_onboarding_test/views/PreviosTestPage/PreviousTestPage.dart';
import 'package:splash_onboarding_test/views/PrivacySettingPage/PrivacySettingPage.dart';
import 'package:splash_onboarding_test/views/accountsetting.dart';
import 'package:splash_onboarding_test/views/getintouch.dart';
import 'package:splash_onboarding_test/views/notifications/notifications.dart';
import 'package:splash_onboarding_test/views/widgets/user_image.dart';

import '../helpers/image_storage.dart';

class UserProfile extends StatefulWidget {
  const UserProfile({super.key});

  @override
  State<UserProfile> createState() => _UserProfileState();
}

class _UserProfileState extends State<UserProfile> {
  String? userImage;
  String? userName = '';
  String? userEmail = '';
  update() async {
    userName = await AuthService.getUsername();
    userEmail = await AuthService.getEmail();
    userImage = await ImageStorage.getImage();

    setState(() {});
  }

  @override
  void initState() {
    super.initState();
    update();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: Container(
      padding: const EdgeInsets.symmetric(horizontal: 10),
      color: const Color(0xFF537F5C),
      child: Column(
        children: [
          const SizedBox(height: 65),
          //
          //Image + name + Email
          //
          Row(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              Padding(
                padding: const EdgeInsets.only(bottom: 3),
                child: Container(
                  margin: const EdgeInsets.only(right: 10),
                  width: 40 * 2, // Adjust the width as needed
                  height: 40 * 2, // Adjust the height as needed
                  child: const ClipOval(
                    child: UserImage(),
                  ),
                ),
              ),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Padding(
                      padding: const EdgeInsets.only(right: 100),
                      child: Text(
                        userName!,
                        style: TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
                          fontFamily: 'Inter',
                          fontSize: 14.sp,
                        ),
                      ),
                    ),
                    Container(
                      constraints: BoxConstraints(
                        maxWidth: MediaQuery.of(context).size.width * 0.5,
                      ),
                      child: Text(
                        userEmail!,
                        style: TextStyle(
                          color: Colors.white,
                          fontFamily: 'Inter',
                          overflow: TextOverflow.ellipsis,
                          fontSize: 14.sp,
                        ),
                        maxLines: 2,
                      ),
                    )
                  ],
                ),
              ),
            ],
          ),
          //
          //
          //
          const SizedBox(height: 20),
          Expanded(
            child: SingleChildScrollView(
              child: Column(
                children: [
                  Container(
                    width: MediaQuery.of(context).size.width,
                    padding:
                        const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(10),
                      color: backgroundColor,
                    ),
                    child: Column(
                      children: [
                        Padding(
                          padding: const EdgeInsets.symmetric(
                              horizontal: 5.0, vertical: 0),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text(
                                "Previous Tests",
                                style: TextStyle(
                                  fontWeight: FontWeight.bold,
                                  fontSize: 16.sp,
                                  fontFamily: 'Ledger',
                                ),
                              ),
                              GestureDetector(
                                onTap: () {
                                  Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                      builder: (context) =>
                                          const Previoustestpage(),
                                    ),
                                  );
                                },
                                child: Row(
                                  children: [
                                    Text(
                                      "show all",
                                      style: TextStyle(
                                        color: primaryColor,
                                        fontSize: 14.sp,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                    Icon(
                                      Icons.play_arrow,
                                      color: primaryColor,
                                      size: 16,
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          ),
                        ),
                        FutureBuilder<List<Test>>(
                          future: getTests(),
                          builder: (context, snapshot) {
                            if (snapshot.connectionState ==
                                ConnectionState.waiting) {
                              return Center(
                                child: LoadingAnimationWidget.discreteCircle(
                                  color: Colors.white,
                                  size: 30,
                                ),
                              );
                            } else if (snapshot.hasError) {
                              return Center(
                                  child: Text('Error: ${snapshot.error}'));
                            } else if (!snapshot.hasData ||
                                snapshot.data!.isEmpty) {
                              return const Center(
                                  child: Text('No tests available'));
                            }

                            final tests = snapshot.data!;
                            return ListView.builder(
                              padding: const EdgeInsets.all(0),
                              itemCount: tests.length > 3 ? 3 : tests.length,
                              shrinkWrap: true,
                              physics: const NeverScrollableScrollPhysics(),
                              itemBuilder: (context, index) {
                                // Calculate the safe starting index for the sublist
                                var safeLength =
                                    tests.length >= 3 ? tests.length - 3 : 0;

                                // Create the reversed sublist
                                var reversedList =
                                    tests.sublist(safeLength).reversed.toList();

                                // Safely access the item at the desired index
                                final test = reversedList[index];

                                return Padding(
                                  padding: const EdgeInsets.symmetric(
                                      horizontal: 5.0, vertical: 3),
                                  child: PerviousTestTile(
                                    testName: test.testName,
                                    testDate: test.date,
                                  ),
                                );
                              },
                            );
                          },
                        )
                      ],
                    ),
                  ),

                  const SizedBox(height: 25),

                  Container(
                    width: MediaQuery.of(context).size.width,
                    padding:
                        const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(10),
                      color: backgroundColor,
                    ),
                    child: Column(
                      children: [
                        Padding(
                          padding: const EdgeInsets.symmetric(
                              horizontal: 5.0, vertical: 0),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text(
                                "Settings",
                                style: TextStyle(
                                    fontWeight: FontWeight.bold,
                                    fontFamily: 'Ledger',
                                    fontSize: 16.sp),
                              ),
                            ],
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.symmetric(
                              horizontal: 5.0, vertical: 3),
                          child: GestureDetector(
                            onTap: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) => const Accountsetting(),
                                ),
                              );
                            },
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.start,
                              children: [
                                Icon(
                                  FontAwesomeIcons.userGear,
                                  color: const Color(0xff6B7280),
                                  size: 13.sp,
                                ),
                                const SizedBox(width: 10),
                                Text("Account Settings",
                                    style: TextStyle(
                                      color:
                                          const Color.fromARGB(255, 41, 50, 66),
                                      fontFamily: 'Inter',
                                      fontSize: 13.sp,
                                    )),
                              ],
                            ),
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.symmetric(
                              horizontal: 5.0, vertical: 3),
                          child: GestureDetector(
                            onTap: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) =>
                                      const NotificationSettingsScreen(),
                                ),
                              );
                            },
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.start,
                              children: [
                                Icon(
                                  FontAwesomeIcons.solidBell,
                                  color: const Color(0xff6B7280),
                                  size: 13.sp,
                                ),
                                const SizedBox(width: 10),
                                Text("Notification Settings",
                                    style: TextStyle(
                                      color:
                                          const Color.fromARGB(255, 41, 50, 66),
                                      fontFamily: 'Inter',
                                      fontSize: 13.sp,
                                    )),
                              ],
                            ),
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.symmetric(
                              horizontal: 5.0, vertical: 3),
                          child: GestureDetector(
                            onTap: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (context) =>
                                        const PrivacySettingPage()),
                              );
                            },
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.start,
                              children: [
                                Icon(
                                  FontAwesomeIcons.lock,
                                  color: const Color(0xff6B7280),
                                  size: 13.sp,
                                ),
                                const SizedBox(width: 10),
                                Text("Privacy Settings",
                                    style: TextStyle(
                                      color:
                                          const Color.fromARGB(255, 41, 50, 66),
                                      fontFamily: 'Inter',
                                      fontSize: 13.sp,
                                    )),
                              ],
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),

                  //
                  const SizedBox(height: 25),

                  Container(
                    width: MediaQuery.of(context).size.width,
                    padding:
                        const EdgeInsets.symmetric(horizontal: 10, vertical: 0),
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(10),
                      color: backgroundColor,
                    ),
                    child: Column(
                      children: [
                        Padding(
                          padding: const EdgeInsets.symmetric(
                              horizontal: 5.0, vertical: 3),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text(
                                "Help and support",
                                style: TextStyle(
                                  fontFamily: 'Ledger',
                                  fontWeight: FontWeight.bold,
                                  fontSize: 16.sp,
                                ),
                              ),
                            ],
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.symmetric(
                              horizontal: 5.0, vertical: 3),
                          child: GestureDetector(
                            onTap: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) => const FAQPage(),
                                ),
                              );
                            },
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.start,
                              children: [
                                Icon(
                                  FontAwesomeIcons.circleInfo,
                                  color: const Color(0xff6B7280),
                                  size: 13.sp,
                                ),
                                const SizedBox(width: 10),
                                Text(
                                  "FAQ",
                                  style: TextStyle(
                                    color:
                                        const Color.fromARGB(255, 41, 50, 66),
                                    fontFamily: 'Inter',
                                    fontSize: 13.sp,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.symmetric(
                              horizontal: 5.0, vertical: 3),
                          child: GestureDetector(
                            onTap: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) => const ContactUsPage(),
                                ),
                              );
                            },
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.start,
                              children: [
                                Icon(
                                  FontAwesomeIcons.solidEnvelope,
                                  color: const Color(0xff6B7280),
                                  size: 13.sp,
                                ),
                                const SizedBox(width: 10),
                                Text(
                                  "Contact us",
                                  style: TextStyle(
                                    fontFamily: 'Inter',
                                    color:
                                        const Color.fromARGB(255, 41, 50, 66),
                                    fontSize: 13.sp,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.only(bottom: 7),
                          child: GestureDetector(
                            onTap: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) => const Getintouch(),
                                ),
                              );
                            },
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.start,
                              children: [
                                const Padding(
                                  padding: EdgeInsets.only(left: 5),
                                  child: Icon(FontAwesomeIcons.handshakeAngle,
                                      color: Color(0xff6B7280), size: 12),
                                ),
                                const SizedBox(width: 7),
                                Text(
                                  " Get in Touch",
                                  style: TextStyle(
                                    fontFamily: 'Inter',
                                    color:
                                        const Color.fromARGB(255, 41, 50, 66),
                                    fontSize: 13.sp,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),

                  //
                ],
              ),
            ),
          ),
        ],
      ),
    ));
  }
}

class PerviousTestTile extends StatelessWidget {
  const PerviousTestTile({
    super.key,
    required this.testName,
    required this.testDate,
  });
  final String testName;
  final String testDate;
  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(testName,
            style: TextStyle(
              color: const Color.fromARGB(255, 41, 50, 66),
              fontFamily: 'Inter',
              fontSize: 13.sp,
            )),
        Text(
          testDate,
          style: TextStyle(
            color: primaryColor,
            fontSize: 14.sp,
            fontWeight: FontWeight.bold,
          ),
        ),
      ],
    );
  }
}
