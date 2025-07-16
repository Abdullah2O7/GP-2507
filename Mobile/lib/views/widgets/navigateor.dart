import 'package:flutter/material.dart';

class NavigationButtons extends StatelessWidget {
  final VoidCallback onPrevious;
  final VoidCallback onNext;

  const NavigationButtons({
    super.key,
    required this.onPrevious,
    required this.onNext,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
     // mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
       IconButton(onPressed: onNext, icon: const Icon(Icons.arrow_forward_ios)),
       IconButton(onPressed: onPrevious, icon: const Icon(Icons.arrow_back_ios)),
      ],
    );
  }
}
