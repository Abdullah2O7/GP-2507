import 'package:awesome_snackbar_content/awesome_snackbar_content.dart';
import 'package:flutter/material.dart';
import 'package:splash_onboarding_test/main.dart';

void showSnackbar(
  BuildContext context,
  String title,
  String message,
  ContentType type, {
  double? fontsize = 14,
  double? height,
}) {
  final snackBar = SnackBar(
    elevation: 0,
    behavior: SnackBarBehavior.floating,
    backgroundColor: Colors.transparent,
    clipBehavior: Clip.none,
    margin: const EdgeInsets.all(10),
    content: SizedBox(
      height: height,
      child: AwesomeSnackbarContent(
        title: title,
        message: message,
        messageTextStyle: TextStyle(
          color: Colors.white,
          fontSize: fontsize,
          fontFamily: 'InriaSans-Regular',
        ),
        titleTextStyle: const TextStyle(
          color: Colors.white,
          fontSize: 16,
          fontFamily: 'Ledger',
        ),
        contentType: type,
      ),
    ),
  );

  scaffoldMessengerKey.currentState?.showSnackBar(snackBar);
}
