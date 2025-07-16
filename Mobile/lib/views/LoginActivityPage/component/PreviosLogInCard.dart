import 'package:flutter/material.dart';

class Previoslogincard extends StatelessWidget {
  const Previoslogincard({
    super.key,
    required this.loginClock,
    required this.loginDevice,
    required this.loginDate,
  });

  final String loginClock;
  final String loginDevice;
  final String loginDate;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(5),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Expanded(
            flex: 4,
            child: Text(
              loginDate,
              style: const TextStyle(
                  color: Colors.black, fontSize: 14, fontFamily: "Inter"),
            ),
          ),
          Expanded(
            flex: 3,
            child: Text(
              loginDevice,
              style: const TextStyle(
                overflow: TextOverflow.ellipsis,
                color: Colors.black,
                fontSize: 14,
              ),
            ),
          ),
          Expanded(
            flex: 3,
            child: Text(
              loginClock,
              textAlign: TextAlign.end,
              style: const TextStyle(
                fontFamily: "Inter",
                fontSize: 14,
                color: Colors.black,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
