import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:intl/intl.dart';

class ResultCard extends StatelessWidget {
  const ResultCard(
      {super.key,
      required this.testName,
      required this.testResult,
      required this.testDate});

  final String testName;
  final String testResult;
  final String testDate;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            testName,
            style: const TextStyle(
              fontFamily: "Inter",
              fontSize: 16,
              fontWeight: FontWeight.w700,
              color: Colors.black,
            ),
          ),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Text(
                    "Result",
                    style: TextStyle(
                      color: Color(0xff553508),
                      fontSize: 16,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                  const SizedBox(width: 5),
                  const Icon(
                    FontAwesomeIcons.arrowRight,
                    size: 14,
                    color:  Color(0xff553508),
                  ),
                  const SizedBox(width: 5),
                  Expanded(
                    child: Row(
                      children: [
                        Column(
                          children: [
                            Text(
                              testResult,
                              softWrap: true,
                              overflow: TextOverflow.visible,
                              style: const TextStyle(
                                color: Color(0xff553508),
                                fontSize: 16,
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ],
              ),
              Text(
                DateFormat.yMMMEd().format(DateTime.parse(testDate)),
                softWrap: true,
                overflow: TextOverflow.visible,
                style: const TextStyle(
                  color: Colors.black,
                  fontSize: 12,
                  fontFamily: "Inter",
                ),
              )
            ],
          ),
          const Divider(
            indent: 5, // Add padding to reduce width from left edge
            endIndent: 5, // Add padding to reduce width from right edge
            thickness: 0.5, // Control thickness of the line
            color: Color(0xff537F5C),
          ),
        ],
      ),
    );
  }
}
