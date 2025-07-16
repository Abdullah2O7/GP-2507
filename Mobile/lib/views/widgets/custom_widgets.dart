// ignore_for_file: unused_field

import 'package:flutter/material.dart';

class ProgressIndicatorWidget extends StatelessWidget {
  final int currentIndex;
  final int totalQuestions;

  const ProgressIndicatorWidget({
    super.key,
    required this.currentIndex,
    required this.totalQuestions,
  });

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: List.generate(totalQuestions, (index) {
          return Container(
            margin: const EdgeInsets.symmetric(horizontal: 3.0),
            width: 14,
            height: 9.8,
            decoration: BoxDecoration(
              border: Border.all(
                color: const Color(0xffD9D9D9).withOpacity(.60),
                width: 0.9,
              ),
              color: index == currentIndex
                  ? Colors.white
                  : const Color(0xffD9D9D9).withOpacity(.20),
              borderRadius: const BorderRadius.all(Radius.elliptical(16, 10)),
            ),
          );
        }),
      ),
    );
  }
}

class AnswerButton extends StatefulWidget {
  final String answer;
  final Color backgroundColor;
  final Function(String) onSelectAnswer;

  const AnswerButton({
    super.key,
    required this.answer,
    required this.backgroundColor,
    required this.onSelectAnswer,
  });

  @override
  _AnswerButtonState createState() => _AnswerButtonState();
}

class _AnswerButtonState extends State<AnswerButton> {
  final Color _buttonColor;

  _AnswerButtonState() : _buttonColor = Colors.transparent;

  void _handleTap() {
    widget.onSelectAnswer(widget.answer);
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(25),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(.25),
            spreadRadius: 0,
            blurRadius: 4,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      height: 47,
      width: 220,
      child: ElevatedButton(
        onPressed: _handleTap,
        style: ElevatedButton.styleFrom(
          backgroundColor: widget.backgroundColor,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(25),
          ),
          padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 40),
        ),
        child: Center(
          child: Text(
            widget.answer,
            style: const TextStyle(
              color: Color(0xFF3E1904),
              fontFamily: 'Inter',
              fontSize: 22,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
      ),
    );
  }
}
