import 'package:animations/animations.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class CustomCardWidget extends StatelessWidget {
  const CustomCardWidget({
    super.key,
    required this.imagePath,
    required this.text,
    required this.destination,
   //
  });
  final String imagePath;
  final String text;
  final Widget destination;
  
  @override
  Widget build(BuildContext context) {
    return OpenContainer(
      transitionType: ContainerTransitionType.fade,
      transitionDuration: const Duration(milliseconds: 400),
      closedElevation: 0,
      openElevation: 0,
      clipBehavior: Clip.none,
      closedShape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.all(Radius.circular(20)),
      ),
      closedBuilder: (BuildContext context, VoidCallback openContainer) {
        return GestureDetector(
          onTap: openContainer,
          child: Container(
            height: 320,
            width: 220,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(30),
              color: Colors.transparent,
              image: DecorationImage(
                image: AssetImage(imagePath, ),
                fit: BoxFit.cover,
              ),
            ),
            child: Stack(
              children: [
                Positioned(
                  bottom: 25,
                  left: 25,
                  right: 25,
                  child: Container(
                    height: 111.h,
                    decoration: BoxDecoration(
                      border: Border.all(
                          width: 2, color: Colors.black.withOpacity(.35)),
                      color: Colors.black.withOpacity(.35),
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: Center(
                      child: Text(
                        text,
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          color: Colors.white.withOpacity(.80),
                          fontSize: 19,
                          fontWeight: FontWeight.bold,
                          fontFamily: 'InriaSans',
                          shadows: const [
                            Shadow(
                              offset: Offset(3.0, 3.0),
                              blurRadius: 5.0,
                              color: Colors.black,
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        );
      },
      openBuilder: (BuildContext context, VoidCallback _) {
        return destination;
      },
    );
  }
}
