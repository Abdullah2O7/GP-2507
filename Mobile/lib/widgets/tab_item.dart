import 'package:flutter/material.dart';
import 'package:splash_onboarding_test/constant/Colors.dart';

class TabItem extends StatelessWidget {
  final String label;
  final bool isSelected;
  final VoidCallback onTap;

  const TabItem({
    super.key,
    required this.label,
    required this.isSelected,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Expanded(
      flex: isSelected ? 2 : 1,
      child: GestureDetector(
        onTap: onTap,
        child: AnimatedContainer(
          alignment: Alignment.center,
          curve: Curves.easeInOut,
          duration: const Duration(milliseconds: 0),
          padding: const EdgeInsets.symmetric(vertical: 20),
          decoration: BoxDecoration(
            color: isSelected ? primaryColor : Colors.white,
            borderRadius: !isSelected
                ? const BorderRadius.vertical(bottom: Radius.circular(5))
                : null,
            boxShadow: [
              if (isSelected)
                BoxShadow(
                  color: const Color(0x00000040).withOpacity(0.25),
                  blurRadius: 6,
                  spreadRadius: 1,
                  offset: const Offset(0, 4),
                )
            ],
          ),
          child: Text(
            label,
            style: TextStyle(
              fontFamily: 'InriaSans-Bold',
              fontSize: 22,
              fontWeight: FontWeight.w700,
              color: isSelected ? Colors.white : primaryColor,
            ),
          ),
        ),
      ),
    );
  }
}
