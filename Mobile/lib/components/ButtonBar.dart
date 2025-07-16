import 'package:flutter/material.dart';
import 'package:splash_onboarding_test/Registeration/auth_service.dart';
import 'package:splash_onboarding_test/constant/Colors.dart';
import 'package:splash_onboarding_test/helpers/show_login_alert.dart';
import 'package:splash_onboarding_test/home.dart';
import 'package:splash_onboarding_test/views/UserProfile.dart';
import 'package:splash_onboarding_test/views/journalPages/journalPage.dart';

class BarButton extends StatelessWidget {
  const BarButton({
    super.key,
    this.height = 58,
    this.ratioOfContainerWidth = 0.7,
    this.ratioOfStartAndEndPadding = 0.1,
    this.iconSize = 37,
    this.backGroundColor = const Color(0xffC4D3C7),
    this.iconColor = const Color(0xff3B5D44),
  });

  final double height;
  final double ratioOfContainerWidth;
  final double ratioOfStartAndEndPadding;
  final double iconSize;
  final Color backGroundColor;
  final Color iconColor;

  Future<bool> _isGuest() async {
    return (await AuthService.isGuest()) ?? false;
  }

  void _handleButtonPress(BuildContext context, VoidCallback onAction) async {
    final isGuest = await _isGuest();
    if (isGuest) {
      showLoginAlert(context);
    } else {
      onAction();
    }
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<bool>(
      future: _isGuest(),
      builder: (context, snapshot) {
        final isGuest = snapshot.data ?? false;

        return Container(
          height: height,
          width: MediaQuery.of(context).size.width * ratioOfContainerWidth,
          decoration: BoxDecoration(
            border: Border.all(width: 2, color: thirdColor),
            color: backGroundColor,
            borderRadius: BorderRadius.circular(20),
          ),
          child: SizedBox(
            height: height,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                SizedBox(
                  width: MediaQuery.of(context).size.width *
                      ratioOfStartAndEndPadding,
                ),
                Expanded(
                  child: IconButton(
                    color: isGuest ? const Color(0xff3B5D44) : iconColor,
                    onPressed: () {
                      _handleButtonPress(context, () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => const JournalPage()),
                        );
                      });
                    },
                    icon: Icon(
                      Icons.edit,
                      size: iconSize,
                    ),
                  ),
                ),
                Expanded(
                  child: IconButton(
                    color: const Color(0xff3B5D44),
                    onPressed: () {
                      Navigator.pushReplacement(
                        context,
                        MaterialPageRoute(
                          builder: (context) => const HomeScreen(),
                        ), // Assuming Home is the correct route.
                      );
                    },
                    icon: Icon(
                      Icons.home,
                      size: iconSize,
                    ),
                  ),
                ),
                Expanded(
                  child: IconButton(
                    color: const Color(0xff3B5D44),
                    onPressed: () {
                      _handleButtonPress(context, () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => const UserProfile(),
                          ),
                        );
                      });
                    },
                    icon: Icon(
                      Icons.person,
                      size: iconSize,
                    ),
                  ),
                ),
                SizedBox(
                  width: MediaQuery.of(context).size.width *
                      ratioOfStartAndEndPadding,
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}
