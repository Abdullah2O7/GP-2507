import 'package:flutter/material.dart';
//import 'package:splash_onboarding_test/Registeration/registeration.dart';
//import 'package:splash_onboarding_test/views/accountsetting.dart';
import 'package:splash_onboarding_test/views/confirmpasswordfordeleteaccount.dart';

class DeleteAccountScreen extends StatefulWidget {
  const DeleteAccountScreen({super.key});

  @override
  _DeleteAccountScreenState createState() => _DeleteAccountScreenState();
}

class _DeleteAccountScreenState extends State<DeleteAccountScreen> {
  int? _selectedReason;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        backgroundColor: const Color(0xff537F5C),
        elevation: 0,
        actions: [
          Container(
            margin: const EdgeInsets.only(right: 320),
            width: 35.0, // Adjust the width of the circle
            height: 35.0, // Adjust the height of the circle
            decoration: BoxDecoration(
              color: Colors.white
                  .withOpacity(.80), // Background color (light green)
              shape: BoxShape.circle, // Circular shape
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.15), // Shadow color
                  spreadRadius: 2, // How much the shadow should spread
                  blurRadius: 5, // The blur radius of the shadow
                  offset: const Offset(0, 2), // Offset the shadow vertically
                ),
              ],
            ),
            child: IconButton(
              icon: const Icon(Icons.arrow_back_ios),
              color: const Color(0xFF537F5C), // Set the color of the arrow icon
              onPressed: () {
                Navigator.of(context).pop();
              },
              iconSize: 25.0, // Adjust the size of the icon
              padding: const EdgeInsets.symmetric(
                  vertical: 3, horizontal: 9), // Adjust padding around the icon
              splashRadius: 25.0, // Adjust the splash radius on click
              tooltip: "Next",
            ),
          ),
        ],
      ),
      body: Container(
        padding: const EdgeInsets.all(16.0),
        color: const Color(0xFF537F5C), // Background color matching the image
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Reasons for deleting profile',
              style: TextStyle(
                fontSize: 22.0,
                fontFamily: 'InriaSans-Bold',
                color: Colors.white,
              ),
            ),
            const SizedBox(height: 8.0),
            const Text(
              'we are really sorry to see you go, are you sure you want to delete your account? Once you confirm your data will be gone.',
              style: TextStyle(
                  fontSize: 17.0,
                  color: Colors.white,
                  fontFamily: 'InriaSans-Light'),
            ),
            const SizedBox(height: 40.0),
            _buildCustomRadioButton(0, 'I have privacy concerns'),
            Divider(
              color: const Color(0xffD9D9D9).withOpacity(.59),
            ),
            _buildCustomRadioButton(1, 'Something is broken'),
            Divider(
              color: const Color(0xffD9D9D9).withOpacity(.59),
            ),
            _buildCustomRadioButton(2, 'I’m no longer using my account'),
            Divider(
              color: const Color(0xffD9D9D9).withOpacity(.59),
            ),
            _buildCustomRadioButton(3, 'Other'),
            const Spacer(),
            Center(
              child: Container(
                height: 60,
                width: 300,
                decoration: BoxDecoration(
                  // color: Colors.white.withOpacity(0.06),
                  borderRadius: BorderRadius.circular(18),
                  border: Border.all(
                    color: const Color(0xffD9D9D9),
                  ),
                ),
                child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color.fromARGB(
                        129, 217, 217, 217), // Button color matching the image

                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(18),
                    ),
                  ),
                  onPressed: () {
                    Navigator.pushReplacement(
                      context,
                      MaterialPageRoute(
                          builder: (context) =>
                              const Confirmpasswordfordeleteaccount()),
                    );
                  },
                  child: const Text(
                    'Confirm',
                    style: TextStyle(
                        fontSize: 26.0,
                        color: Colors.white,
                        fontFamily: 'InriaSans-Bold'),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildCustomRadioButton(int value, String text) {
    return ListTile(
      leading: Transform.scale(
        scale: 1.3, // Adjust the scale to make the circle bigger
        child: Radio<int>(
          value: value,
          groupValue: _selectedReason,
          onChanged: (int? newValue) {
            setState(() {
              _selectedReason = newValue;
            });
          },
          activeColor: Colors.white,

          // fillColor: disab.Colors.transparent,
        ),
      ),
      title: Text(
        text,
        style:
            const TextStyle(color: Colors.white, fontFamily: 'InriaSans-Bold'),
      ),
    );
  }
}
