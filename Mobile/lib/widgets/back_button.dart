import 'package:flutter/material.dart';

class GoBackButton extends StatelessWidget {
  const GoBackButton({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return IconButton(
      icon: const Icon(Icons.arrow_back_ios),
      color: Colors.white,
      onPressed: () {
        Navigator.of(context).pop();
      },
      iconSize: 25.0,
      padding: const EdgeInsets.symmetric(vertical: 3, horizontal: 9),
      splashRadius: 25.0,
      tooltip: "Next",
    );
  }
}
