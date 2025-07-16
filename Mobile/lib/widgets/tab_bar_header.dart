import 'package:flutter/material.dart';
import 'package:splash_onboarding_test/widgets/tab_item.dart';

class TabBarHeader extends StatelessWidget {
  final int selectedIndex;
  final TabController tabController;

  const TabBarHeader({
    super.key,
    required this.selectedIndex,
    required this.tabController,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: List.generate(2, (index) {
        return TabItem(
          label: index == 0 ? 'Articles' : 'Videos',
          isSelected: selectedIndex == index,
          onTap: () {
            tabController.animateTo(index);
          },
        );
      }),
    );
  }
}
