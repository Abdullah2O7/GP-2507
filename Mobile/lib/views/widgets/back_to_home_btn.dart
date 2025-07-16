//import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:line_icons/line_icons.dart';
import 'package:splash_onboarding_test/constant/Colors.dart';
import 'package:splash_onboarding_test/nav_layout.dart';

class BackTohomeBtn extends StatelessWidget {
  const BackTohomeBtn({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () {
        Navigator.pushAndRemoveUntil(
          context,
          MaterialPageRoute(
            builder: (context) => const NavLayout(),
          ),
          (route) => false,
        );
      },
      child: Container(
        height: 50,
        width: MediaQuery.of(context).size.width * 0.7,
        decoration: BoxDecoration(
          border: Border.all(width: 2, color: thirdColor),
          color: const Color(0xffC4D3C7),
          borderRadius: BorderRadius.circular(20),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              "Back to Home",
              style: TextStyle(
                color: const Color(0xff537F5C),
                fontSize: 20.sp,
                fontFamily: 'InriaSans-Bold',
              ),
            ),
            const SizedBox(width: 10),
            const Icon(
              LineIcons.home,
              color: Color(0xff537F5C),
              size: 24,
            )
          ],
        ),
      ),
    );
  }
}
