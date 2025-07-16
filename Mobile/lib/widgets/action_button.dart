import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

class ActionButton extends StatelessWidget {
  final String title;
  final String? description;
  final VoidCallback onTap;

  const ActionButton({
    super.key,
    required this.title,
    this.description,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
       
        padding: EdgeInsets.symmetric(horizontal: 12.w, vertical: 18.h),
        decoration: BoxDecoration(
          color:  const Color(0xffA8BFAD),
          boxShadow: [
            BoxShadow(
             // color: Colors.black.withOpacity(.10),
              spreadRadius: 0,
              blurRadius: 4.r,
              offset: Offset(0, 4.h),
            ),
          ],
          borderRadius: BorderRadius.circular(17.r),
          border: Border.all(color: Colors.black),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  title,
                  softWrap: true,
                  style: TextStyle(
                    fontFamily: "InriaSans-Bold",
                    fontSize: 20.sp,
                    color: Colors.black,
                  ),
                ),
                Icon(FontAwesomeIcons.play, size: 14.sp, color: Colors.black),
              ],
            ),
            if (description != null)
              Text(
                description!,
                softWrap: true,
                style: TextStyle(fontSize: 14.sp, color: Colors.black),
              ),
          ],
        ),
      ),
    );
  }
}
