import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:splash_onboarding_test/views/generaltest.dart';
import 'package:splash_onboarding_test/widgets/back_button.dart';

class GeneralTest extends StatelessWidget {
  const GeneralTest({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor:const Color(0xffFFFAEF),
      body: SingleChildScrollView(
        child: Column(
          children: [
            _buildHeader(context),
            SizedBox(height: 30.h),
            _buildStartButton(context),
          ],
        ),
      ),
    );
  }

  Widget _buildHeader(BuildContext context) {
    return Stack(
      children: [
        _buildBackgroundImage(),
        Center(child: _buildContentBox(context)),
        _buildBackButton(context),
      ],
    );
  }

  Widget _buildBackgroundImage() {
    return Container(
      height: 820.h,
      width: double.infinity,
      decoration: const BoxDecoration(
        borderRadius: BorderRadius.only(
          bottomLeft: Radius.circular(40),
          bottomRight: Radius.circular(40),
        ),
        image: DecorationImage(
          image: AssetImage('assets/lastupdateofgeneraltest.png'),
          fit: BoxFit.cover,
        ),
      ),
    );
  }

  Widget _buildContentBox(BuildContext context) {
    return Container(
      height: 570.h,
      width: 355.w,
      margin: EdgeInsets.symmetric(horizontal: 24.w, vertical: 0.1.sh),
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 40),
      decoration: BoxDecoration(
        color: Colors.black.withOpacity(0.30),
        borderRadius: BorderRadius.circular(20.r),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          SizedBox(height: 30.h),
          Text(
            "General Test",
            textAlign: TextAlign.center,
            style: TextStyle(
              color: Colors.white,
              fontSize: 24.sp,
              fontWeight: FontWeight.w500,
              fontFamily: 'InriaSans-Light',
              shadows: const [
                Shadow(
                  offset: Offset(0, 6.0),
                  blurRadius: 4.0,
                  color: Colors.black,
                ),
              ],
            ),
          ),
          SizedBox(height: 20.h),
          Text(
            "This test includes various symptoms for a\n"
            "range of mental disorders, such as ADHD, OCD, PTSD, and more\n"
            "we know, identifying these disorders is crucial\n"
            "for improving the quality of life for many individuals.",
            textAlign: TextAlign.center,
            overflow: TextOverflow.ellipsis,
            maxLines: 9,
            style: TextStyle(
              color: Colors.white,
              fontSize: 24.sp,
              fontFamily: 'InriaSans-Light',

              shadows: const [
                Shadow(
                  offset: Offset(0, 2.0),
                  blurRadius: 4.0,
                  color: Colors.black,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildBackButton(BuildContext context) {
    return Positioned(
      top: 40.h,
      left: 20.w,
      child: const GoBackButton(),
    );
  }

  Widget _buildStartButton(BuildContext context) {
    return TextButton(
      onPressed: () {
        Navigator.of(context).push(
          MaterialPageRoute(
            builder: (context) => const Generaltest(),
          ),
        );
      },
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(
            "Let's get started",
            style: TextStyle(
              color: const Color(0xff537F5C),
              fontSize: 24.sp,
              fontFamily: 'InriaSans-Bold',
            ),
          ),
          SizedBox(width: 10.w),
          const Icon(
            Icons.arrow_forward_ios,
            color: Color(0xff537F5C),
            size: 24,
          ),
        ],
      ),
    );
  }
}
