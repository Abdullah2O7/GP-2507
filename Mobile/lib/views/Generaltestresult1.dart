import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:splash_onboarding_test/views/Generalresultpage2.dart';

class GenralResult1 extends StatelessWidget {
  final String result;

  const GenralResult1({super.key, required this.result});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xff537F5C),
      body: SafeArea(
        child: Column(
          children: [
            Padding(
              padding: EdgeInsets.only(top: 100.h),
              child: Text(
                'The Result of General Test',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 20.sp,
                  fontFamily: 'Ledger',
                ),
                textAlign: TextAlign.center,
              ),
            ),
            SizedBox(height: 40.h),
            ClipRRect(
              borderRadius: BorderRadius.circular(200.r),
              child: result.isEmpty
                  ? Container(
                      color: Colors.grey,
                      width: 200.w,
                      height: 200.h,
                    )
                  : Image.asset(
                      'assets/lastupdateofgeneraltest.png',
                      width: 200.w,
                      height: 200.h,
                      errorBuilder: (context, error, stackTrace) {
                        return Container(
                          color: Colors.grey,
                          width: 200.w,
                          height: 200.h,
                          child: const Center(
                            child: Text(
                              'Image Error',
                              style: TextStyle(color: Colors.red),
                            ),
                          ),
                        );
                      },
                    ),
            ),
            SizedBox(height: 30.h),
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 20.w),
              child: Text(
                'Based on your test results, you have been diagnosed with a mental health condition identified as:',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 17.sp,
                  fontFamily: 'Ledger',
                ),
                textAlign: TextAlign.center,
              ),
            ),
            SizedBox(height: 30.h),
            Text(
              result,
              style: TextStyle(
                color: const Color(0xffD9D9D9),
                fontSize: 30.sp,
                fontFamily: 'Ledger',
              ),
            ),
            const Spacer(),
            Stack(
              alignment: Alignment.center,
              children: [
                Image.asset(
                  'assets/resultpage.png',
                  width: double.infinity,
                  height: 150.h,
                  fit: BoxFit.cover,
                ),
                Positioned(
                  bottom: 29.h,
                  child: Center(
                    child: TextButton(
                      onPressed: () {
                        Navigator.of(context).push(
                          MaterialPageRoute(
                            builder: (context) =>
                                Resultpage2(diseaseName: result),
                          ),
                        );
                      },
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Text(
                            'Go to next page',
                            style: TextStyle(
                              fontFamily: 'InriaSans-Light',
                              fontSize: 30.sp,
                              fontWeight: FontWeight.w700,
                              color: const Color(0xff537F5C),
                            ),
                          ),
                          SizedBox(width: 10.w),
                          Icon(
                            Icons.arrow_forward_ios_outlined,
                            color: const Color(0xff537F5C),
                            size: 24.sp,
                          ),
                        ],
                      ),
                    ),
                  ),
                )
              ],
            ),
          ],
        ),
      ),
    );
  }
}
