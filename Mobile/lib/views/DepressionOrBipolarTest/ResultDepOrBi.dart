import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart'; // Make sure to import the package
import 'package:splash_onboarding_test/views/DepressionOrBipolarTest/DepOrBiresult2.dart';

class Result1DepORBi extends StatelessWidget {
  final String result;

  const Result1DepORBi({super.key, required this.result});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xff537F5C),
      body: SafeArea(
        child: Column(
          children: [
            Padding(
              padding: EdgeInsets.only(top: 50.h),
              child: Text(
                'The Result of DEPRESSION or Bipolar Test',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 20.sp,
                  fontFamily: 'Ledger',
                ),
                textAlign: TextAlign.center,
              ),
            ),
            const Spacer(),
            ClipRRect(
              borderRadius: BorderRadius.circular(300.r),
              child: result.isEmpty
                  ? Container(
                      color: Colors.grey,
                      width: 300.w,
                      height: 300.h,
                    )
                  : Image.asset(
                      'assets/image1.png',
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
                'Based on your test results, you have been diagnosed with a mental health condition identified as: ',
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
                Image.asset('assets/resultpage.png'),
                Positioned(
                  bottom: 29.h,
                  child: Center(
                    child: TextButton(
                      onPressed: () {
                        Navigator.of(context).push(
                          MaterialPageRoute(
                            builder: (context) =>
                                Result2DepOrBi(result: result),
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
                          const Icon(
                            Icons.arrow_forward_ios_outlined,
                            color: Color(0xff537F5C),
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
