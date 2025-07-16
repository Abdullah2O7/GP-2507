import 'package:flutter/material.dart';

class AnswerButton extends StatefulWidget {
  final String answer;
  final Color backgroundColor;
  final void Function(String) onSelectAnswer;

  const AnswerButton({
    required this.answer,
    required this.backgroundColor,
    required this.onSelectAnswer,
    super.key,
  });

  @override
  _AnswerButtonState createState() => _AnswerButtonState();
}

class _AnswerButtonState extends State<AnswerButton> {
  Color _currentColor;

  _AnswerButtonState() : _currentColor = Colors.transparent;

  void _handleTap() {
    setState(() {
      _currentColor = widget.backgroundColor.withOpacity(0.7); // Change color on click
    });
    widget.onSelectAnswer(widget.answer);
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: _handleTap,
      child: Container(
        width: double.infinity,
        padding: const EdgeInsets.symmetric(vertical: 12),
        decoration: BoxDecoration(
          color: _currentColor == Colors.transparent ? widget.backgroundColor : _currentColor,
          borderRadius: BorderRadius.circular(10),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.2),
              spreadRadius: 2,
              blurRadius: 4,
              offset: const Offset(0, 2),
            ),
          ],
        ),
        child: Center(
          child: Text(
            widget.answer,
            style: const TextStyle(
              color: Colors.white,
              fontSize: 16,
              fontFamily: 'InriaSans-Regular',
            ),
          ),
        ),
      ),
    );
  }
}
