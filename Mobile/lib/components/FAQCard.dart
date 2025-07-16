import 'package:flutter/material.dart';
import 'package:splash_onboarding_test/constant/Colors.dart';

class FAQCard extends StatelessWidget {
  const FAQCard({super.key, required this.Q, required this.A});
  final String Q;
  final String A;
  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(10),
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      decoration: BoxDecoration(boxShadow: [
        BoxShadow(
          color: Colors.black.withOpacity(0.25), // Shadow color with opacity
          // Spread the shadow
          blurRadius: 4, // Blur radius of the shadow
          offset: const Offset(0, 4), // Offset in x and y directions
        ),
      ], borderRadius: BorderRadius.circular(10), color: primaryColor),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            Q,
            style: const TextStyle(
                color: Colors.white, fontSize: 17, fontWeight: FontWeight.w500),
          ),
          const SizedBox(
            height: 5,
          ),
          Text(
            A,
            style: const TextStyle(
                color: Colors.white, fontSize: 15, fontFamily: "Ledger"),
          )
        ],
      ),
    );
  }
}
