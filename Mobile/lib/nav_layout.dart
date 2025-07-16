import 'package:animations/animations.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_nav_bar/google_nav_bar.dart';
import 'package:line_icons/line_icons.dart';
import 'package:splash_onboarding_test/Registeration/auth_service.dart';
import 'package:splash_onboarding_test/helpers/show_login_alert.dart';
import 'package:splash_onboarding_test/home.dart';
import 'package:splash_onboarding_test/views/UserProfile.dart';
import 'package:splash_onboarding_test/views/journalPages/journalPage.dart';
import 'package:splash_onboarding_test/views/resources_screen.dart';

import 'cubits/user_image_cubit.dart';

class NavLayout extends StatefulWidget {
  const NavLayout({super.key});

  @override
  State<NavLayout> createState() => _NavLayoutState();
}

class _NavLayoutState extends State<NavLayout> {
  int _selectedIndex = 0;

  final List<Widget> _screens = const [
    HomeScreen(),
    JournalPage(),
    UserProfile(),
    ResourcesScreen(),
    

    //Accountsetting(),
  ];

  Future<bool> _isGuest() async {
    return (await AuthService.isGuest()) ?? false;
  }

  void _handleNavigation(int index) async {
    if (index == 1 || index == 2 || index == 3) {
      final isGuest = await _isGuest();
      if (isGuest) {
        if (mounted) {
          showLoginAlert(context);
        }
        return;
      }
    }
    if (mounted) {
      setState(() {
        _selectedIndex = index;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => UserProfileCubit()..fetchUserProfile(),
      child: Scaffold(
        body: PageTransitionSwitcher(
          duration: const Duration(milliseconds: 1),
          transitionBuilder: (Widget child, Animation<double> animation,
              Animation<double> secondaryAnimation) {
            return FadeThroughTransition(
              fillColor: Colors.transparent,
              animation: animation,
              secondaryAnimation: secondaryAnimation,
              child: child,
            );
          },
          child: _screens[_selectedIndex],
        ),
        bottomNavigationBar: Container(
          decoration: BoxDecoration(
            color: Colors.white,
            boxShadow: [
              BoxShadow(
                blurRadius: 20,
                color: Colors.black.withOpacity(.1),
              )
            ],
          ),
          child: SafeArea(
            child: Padding(
              padding:
                  const EdgeInsets.symmetric(horizontal: 15.0, vertical: 8),
              child: GNav(
                rippleColor: Colors.grey[300]!,
                hoverColor: Colors.grey[100]!,
                gap: 8,
                activeColor: Colors.black,
                iconSize: 24,
                padding:
                    const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
                duration: const Duration(milliseconds: 300),
                tabBackgroundColor: const Color(0xff537F5C).withOpacity(0.50),
                color: Colors.black,
                tabs: const [
                  GButton(
                    icon: LineIcons.home,
                    text: 'Home',
                  ),
                  GButton(
                    icon: LineIcons.edit,
                    text: 'Journal',
                  ),
                  GButton(
                    icon: LineIcons.user,
                    text: 'Profile',
                  ),
                  GButton(
                    icon: LineIcons.search,
                    text: 'Resources',
                  ),
                ],
                selectedIndex: _selectedIndex,
                onTabChange: _handleNavigation,
              ),
            ),
          ),
        ),
      ),
    );
  }
}
