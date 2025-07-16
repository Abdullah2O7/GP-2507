import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class CustomAppBar extends StatelessWidget implements PreferredSizeWidget {
  const CustomAppBar({
    super.key,
    required this.text,
  });
  final String text;

  @override
  Widget build(BuildContext context) {
    return AppBar(
      
      automaticallyImplyLeading: false,
      leading: IconButton(
        icon: const Icon(Icons.arrow_back_ios),
        color: Colors.white,
        onPressed: () {
          Navigator.of(context).pop();
        },
        iconSize: 25.0,
        splashRadius: 25.0,
        tooltip: "Back",
      ),
      title: Text(
        text,
        style: TextStyle(
          color: Colors.white,
          fontSize: 24.sp,
          fontWeight: FontWeight.w700,
          fontFamily: 'InriaSans-Bold',
        ),
      ),
      centerTitle: true,
      backgroundColor:const Color(0xff537F5C),
      elevation: 0,
    );
  }

  @override
  Size get preferredSize => const Size.fromHeight(65);
}
