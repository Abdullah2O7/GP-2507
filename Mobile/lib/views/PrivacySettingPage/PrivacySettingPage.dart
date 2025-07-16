import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import 'package:splash_onboarding_test/views/DeleteAccountPage/DeleteDataPage.dart';
import 'package:splash_onboarding_test/views/LoginActivityPage/LoginActivityPage.dart';
import 'package:splash_onboarding_test/views/requestdata/requestdata.dart';
import 'package:splash_onboarding_test/widgets/action_button.dart';
import 'package:splash_onboarding_test/widgets/custom_app_bar.dart';

class PrivacySettingPage extends StatelessWidget {
  const PrivacySettingPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF537F5C),
      appBar: const CustomAppBar(
        text: 'Privacy settings',
      ),
      body: Container(
        color: const Color(0xffFFFAEF),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            // //
            // // Appbar
            // //
            // Row(
            //   children: [
            //     SizedBox(height: 120.h),
            //     Stack(
            //       children: [
            //         Positioned(
            //           left: 20.w,
            //           top: 5.h,
            //           child: Container(
            //             width: 35,
            //             height: 35,
            //             decoration: BoxDecoration(
            //               color: Colors.white.withOpacity(.80),
            //               shape: BoxShape.circle,
            //               boxShadow: [
            //                 BoxShadow(
            //                   color: Colors.black.withOpacity(0.15),
            //                   spreadRadius: 2.r,
            //                   blurRadius: 5.r,
            //                   offset: Offset(0, 2.h),
            //                 ),
            //               ],
            //             ),
            //             child: IconButton(
            //               icon: Icon(Icons.arrow_back_ios, size: 25.sp),
            //               color: const Color(0xFF537F5C),
            //               onPressed: () {
            //                 Navigator.of(context).push(MaterialPageRoute(
            //                   builder: (context) => const UserProfile(),
            //                 ));
            //               },
            //               splashRadius: 25.r,
            //               tooltip: "Next",
            //             ),
            //           ),
            //         ),
            //         SizedBox(
            //           width: MediaQuery.of(context).size.width,
            //           child: Row(
            //             mainAxisAlignment: MainAxisAlignment.center,
            //             children: [
            //               Text(
            //                 "Privacy settings",
            //                 style: TextStyle(
            //                   fontFamily: "InriaSans-Bold",
            //                   fontSize: 28.sp,
            //                   color: Colors.white,
            //                 ),
            //               ),
            //             ],
            //           ),
            //         ),
            //       ],
            //     ),
            //   ],
            // ),

            Expanded(
              child: Padding(
                padding: EdgeInsets.symmetric(horizontal: 15.w),
                child: Column(
                  children: [
                    Padding(
                      padding: EdgeInsets.symmetric(
                          horizontal: 15.w, vertical: 20.h),
                      child: Text(
                        "Your privacy is our top priority. This section allows you to manage how your data is collected, stored, and used within the app",
                        style: TextStyle(
                          fontFamily: "InriaSans-Light",
                          fontSize: 18.sp,
                          letterSpacing: 0.sp,
                          color: const Color(0xff537F5C),
                          height: 1.2.h,
                        ),
                      ),
                    ),
                    const Divider(color: Colors.white24),
                    SizedBox(height: 20.h),
                    Column(
                      children: [
                        ActionButton(
                          title: "Login Activity",
                          description: null,
                          onTap: () => Navigator.of(context).push(
                            MaterialPageRoute(
                              builder: (context) => const Loginactivitypage(),
                              
                            ),
                          ),
                        ),
                        SizedBox(height: 25.h),
                        ActionButton(
                          title: "Delete your data",
                          description: "This action will remove all your data.",
                          onTap: () => Navigator.of(context).push(
                            MaterialPageRoute(
                                builder: (context) => const DeleteDataPage()),
                          ),
                        ),
                        SizedBox(height: 25.h),
                        ActionButton(
                          title: "Request your data",
                          description:
                              "Request a copy of your data Malaz collects about you.",
                          onTap: () => Navigator.of(context).push(
                            MaterialPageRoute(
                                builder: (context) => const RequestdataPage()),
                          ),
                        ),
                      ],
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
}
