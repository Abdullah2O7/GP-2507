import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:http/http.dart' as http;
import 'package:splash_onboarding_test/Registeration/auth_service.dart';

import 'package:splash_onboarding_test/views/PreviosTestPage/PreviousTestPage.dart';

import '../../widgets/custom_app_bar.dart';

class DeleteDataPage extends StatelessWidget {
  const DeleteDataPage({super.key});

  Future<String?> getToken() async {
    final String? token = await AuthService.getToken();
    if (token == null) {
      print('No token found');
    } else {
      print('Retrieved Token: $token');
    }
    return token;
  }

  Future<void> deleteData(BuildContext context) async {
    final String? token = await getToken();
    if (token == null) {
      return;
    }

    final response = await http.post(
      Uri.parse('https://gpappapis.azurewebsites.net/api/deleteAllTests'),
      headers: {
        'Authorization': token,
        'Content-Type': 'application/json',
      },
    );

    if (response.statusCode == 200) {
      Navigator.of(context).pop();
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => const Previoustestpage()),
      );
    } else {
      showDialog(
        context: context,
        builder: (context) => AlertDialog(
          title: const Text("Error"),
          content: Text("Failed to delete data: ${response.body}"),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(),
              child: const Text("OK"),
            ),
          ],
        ),
      );
    }
  }

  void _deleteaccount(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(20.r),
          ),
          backgroundColor: const Color(0xff537F5C).withOpacity(.88),
          elevation: 20,
          shadowColor: Colors.black.withOpacity(0.25),
          content: SizedBox(
            width: 320.w,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                SizedBox(height: 20.h),
                SizedBox(
                  height: 120.h,
                  child: Image.asset('assets/deleteimage.png',
                      fit: BoxFit.contain),
                ),
                SizedBox(height: 20.h),
                Text(
                  "Are you sure you want to delete your data?",
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 22.sp,
                    fontFamily: 'InriaSans-Bold',
                  ),
                  textAlign: TextAlign.center,
                ),
                SizedBox(height: 20.h),
                SizedBox(
                  width: 240.w,
                  child: ElevatedButton(
                    onPressed: () {
                      deleteData(context);
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color(0xffA71C1C).withOpacity(.88),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(15.r),
                      ),
                      padding: EdgeInsets.symmetric(vertical: 12.h),
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
                        borderRadius: BorderRadius.circular(10.r),
                      ),
                      padding: EdgeInsets.symmetric(vertical: 12.h),
                    ),
                    child: Text(
                      "Cancel",
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 22.sp,
                        fontFamily: 'InriaSans-Bold',
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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      //backgroundColor: const Color(0xFFFFFAEF),
      appBar: const CustomAppBar(
        text: 'Delete Data',
      ),
      body: Container(
        color: const Color(0xFFFFFAEF),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            Expanded(
              child: Padding(
                padding: EdgeInsets.symmetric(horizontal: 20.w),
                child: Column(
                  children: [
                    Padding(
                      padding: EdgeInsets.only(top: 40.h, bottom: 40.h),
                      child: Text(
                        "Are you sure you want to delete your data? This action will remove all your previous test results you’ve stored in the app. Once deleted, this data cannot be recovered. If you’re certain, please confirm your decision by clicking 'Delete Data.'",
                        style: TextStyle(
                          color: const Color(0xff537F5C),
                          fontSize: 20.sp,
                          fontFamily: 'InriaSans-Bold',
                        ),
                        textAlign: TextAlign.center,
                      ),
                    ),
                    Container(
                      width: 270.w,
                      height: 44.h,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(20.r),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black.withOpacity(.25),
                            spreadRadius: 0,
                            blurRadius: 4.r,
                            offset: Offset(0, 4.h),
                          ),
                        ],
                      ),
                      child: ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          minimumSize: Size(100.w, 44.h),
                          backgroundColor:
                              const Color.fromARGB(220, 167, 28, 28),
                          alignment: Alignment.center,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(20.r),
                          ),
                        ),
                        onPressed: () {
                          _deleteaccount(context);
                        },
                        child: Text(
                          'Delete Data',
                          style: TextStyle(
                            fontSize: 22.sp,
                            color: const Color(0xffFFFAEF),
                            fontFamily: 'InriaSans-Bold',
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
            // const BackTohomeBtn(),
            // SizedBox(height: 10.h),
          ],
        ),
      ),
    );
  }
}
