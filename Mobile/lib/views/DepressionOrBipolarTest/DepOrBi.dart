import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:splash_onboarding_test/nav_layout.dart';
import 'package:splash_onboarding_test/views/DepressionOrBipolarTest/depo_r_bi_submit_page.dart';
import 'package:splash_onboarding_test/views/models/question.dart';
import 'package:splash_onboarding_test/views/widgets/custom_widgets.dart';

class Deporbi extends StatefulWidget {
  const Deporbi({super.key});

  @override
  _Deporbi createState() => _Deporbi();
}

class _Deporbi extends State<Deporbi> {
  int _currentQuestionIndex = 0;
  String? _selectedAnswer;

  final List<Question> _questions = [
    Question(
      questionText: "I usually experience Mood Swings",
      possibleAnswers: [
        "YES",
        "NO",
      ],
    ),
    Question(
      questionText:
          "On a scale of 1 to 10, how often do you find yourself optimistic",
      possibleAnswers: [
        "1",
        "2",
        "3",
        "4",
        "5",
        "6",
        "7",
        "8",
        "9",
        "10",
      ],
    ),
    Question(
      questionText: "I experience a lot of nervous breakdowns",
      possibleAnswers: [
        "YES",
        "NO",
      ],
    ),
    Question(
      questionText: "I’ve suicidal thoughts and can be easily triggered",
      possibleAnswers: [
        "YES",
        "NO",
      ],
    ),
    Question(
      questionText: "I feel an unstoppable wave of sadness",
      possibleAnswers: ["Seldom", "Sometimes", "Usually", "Most-often"],
    ),
    Question(
      questionText: "I usually find myself deep in the pit of overthinking",
      possibleAnswers: [
        "YES",
        "NO",
      ],
    ),
    Question(
      questionText: "I feel euphoric",
      possibleAnswers: ["Seldom", "Sometimes", "Usually", "Most-often"],
    ),
    Question(
      questionText: "Do you find yourself sexually active?",
      possibleAnswers: [
        "YES",
        "NO",
      ],
    ),
    Question(
      questionText:
          "On a scale of 1 to 10, rank your attention span/concentration",
      possibleAnswers: [
        "1",
        "2",
        "3",
        "4",
        "5",
        "6",
        "7",
        "8",
        "9",
        "10",
      ],
    ),
    Question(
      questionText: "How often do you feel drained?",
      possibleAnswers: ["Seldom", "Sometimes", "Usually", "Most-often"],
    ),
  ];

  List<String?> _generalAnswers = [];

  @override
  void initState() {
    super.initState();
    _generalAnswers = List<String?>.filled(_questions.length, null);
  }

  void _selectAnswer(String answer) {
    setState(() {
      _selectedAnswer = answer;
      _generalAnswers[_currentQuestionIndex] = answer;
    });
  }

  void _nextQuestion() {
    if (_selectedAnswer != null) {
      if (_currentQuestionIndex < _questions.length - 1) {
        setState(() {
          _currentQuestionIndex++;
          _selectedAnswer = _generalAnswers[_currentQuestionIndex];
        });
      } else {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => DepoRBiSubmitPage(answers: _generalAnswers),
          ),
        );
      }
    } else {
      _showAnswerRequiredDialog();
    }
  }

  void _showQuitConfirmationDialog() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          contentPadding: const EdgeInsets.all(24),

          shape: RoundedRectangleBorder(
            // side:
            //BorderSide(color: Color(0xffD9D9D9).withOpacity(.69), width: 2),
            borderRadius: BorderRadius.circular(20),
          ),
          backgroundColor: const Color(0xff537F5C)
              .withOpacity(.88), // Match the background color
          content: SizedBox(
            // height: 350, // Set the height of the dialog
            width: 320,
            // Set the width of the dialog
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                const SizedBox(
                  height: 40,
                ),
                const Text(
                  "Are you sure\n you want to Quit the \ntest?",
                  style: TextStyle(
                      color: Colors.white, // White text color
                      fontSize: 18, // Similar font size
                      //fontWeight: FontWeight.bold,
                      fontFamily: 'InriaSans-Light'),
                  textAlign: TextAlign.center,
                ),
                const SizedBox(
                    height: 20), // Add space between text and buttons
                Container(
                  width: 150,
                  decoration: BoxDecoration(
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withOpacity(.25),
                        spreadRadius: 0,
                        blurRadius: 4,
                        offset: const Offset(0, 4),
                      ),
                    ],
                  ),
                  child: ElevatedButton(
                    onPressed: () {
                      Navigator.pushAndRemoveUntil(
                        context,
                        MaterialPageRoute(
                            builder: (context) => const NavLayout()),
                        (route) => false,
                      
                      ); // Close the dialog
                      // Add your logic to quit the test here
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color(0xffA71C1C)
                          .withOpacity(.88), // Red color for "Quit"
                      shape: RoundedRectangleBorder(
                        borderRadius:
                            BorderRadius.circular(10), // Rounded button
                      ),
                      padding: const EdgeInsets.symmetric(vertical: 12),
                    ),
                    child: const Text(
                      "Quit",
                      style: TextStyle(
                          color: Colors.white, // White text color
                          fontSize: 22, // Adjust the font size
                          fontFamily: 'InriaSans-Bold'),
                    ),
                  ),
                ),
                const SizedBox(height: 20), // Add space between buttons
                SizedBox(
                  width: 150, // Set the width of the "Cancel" button
                  child: OutlinedButton(
                    onPressed: () {
                      Navigator.of(context).pop(); // Close the dialog
                    },
                    style: OutlinedButton.styleFrom(
                      side: const BorderSide(
                          color: Colors.white, width: 2), // White border
                      shape: RoundedRectangleBorder(
                        borderRadius:
                            BorderRadius.circular(10), // Rounded button
                      ),
                      padding: const EdgeInsets.symmetric(vertical: 12),
                    ),
                    child: const Text(
                      "Cancel",
                      style: TextStyle(
                        color: Colors.white, // White text color
                        fontSize: 22, // Adjust the font size
                        fontFamily: 'InriaSans-Bold',
                      ),
                    ),
                  ),
                ),
                const SizedBox(
                  height: 40,
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  void _showAnswerRequiredDialog() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(20),
          ),
          backgroundColor: const Color(0xff537F5C).withOpacity(.88),
          content: SizedBox(
            // height: 350,
            width: 320,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                const SizedBox(height: 20),
                const Text(
                  "Answer Required!",
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 22,
                    fontWeight: FontWeight.bold,
                    fontFamily: 'InriaSans-Bold',
                  ),
                  textAlign: TextAlign.center,
                ),
                Image.asset(
                  'assets/Answerreqiured.png',
                  width: 120,
                  height: 120,
                ),
                const Text(
                  "Please answer the question\nbefore moving to the other\nquestions",
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 16,
                    fontFamily: 'InriaSans-Light',
                  ),
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 20),
                SizedBox(
                  width: 95,
                  child: OutlinedButton(
                    onPressed: () {
                      Navigator.of(context).pop();
                    },
                    style: OutlinedButton.styleFrom(
                      side: const BorderSide(color: Colors.white, width: 1),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10),
                      ),
                      padding: const EdgeInsets.symmetric(vertical: 12),
                    ),
                    child: const Text(
                      "OK",
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 16,
                        fontFamily: 'InriaSans-Light',
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  void _previousQuestion() {
    if (_currentQuestionIndex > 0) {
      setState(() {
        _currentQuestionIndex--;
        _selectedAnswer = _generalAnswers[_currentQuestionIndex];
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xff537F5C),
      body: SafeArea(
        child: Center(
          child: Column(
            children: [
              const SizedBox(height: 10),
              ProgressIndicatorWidget(
                currentIndex: _currentQuestionIndex,
                totalQuestions: _questions.length,
              ),
              const SizedBox(height: 80),
              Expanded(
                child: SingleChildScrollView(
                  child: Center(
                    child: Column(
                      children: [
                        Container(
                          margin: const EdgeInsets.symmetric(horizontal: 30),
                          padding: const EdgeInsets.all(30),
                          decoration: BoxDecoration(
                            color: const Color(0xff5B8864),
                            borderRadius: BorderRadius.circular(20),
                            boxShadow: [
                              BoxShadow(
                                color: Colors.white.withOpacity(.20),
                                spreadRadius: 2,
                                blurRadius: 10,
                                offset: const Offset(3, 3),
                              ),
                            ],
                          ),
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Text(
                                _questions[_currentQuestionIndex].questionText,
                                style: const TextStyle(
                                  fontSize: 23,
                                  color: Colors.white,
                                  fontWeight: FontWeight.w700,
                                ),
                                textAlign: TextAlign.center,
                              ),
                              const SizedBox(height: 40),
                              if (_currentQuestionIndex == 1 ||
                                  _currentQuestionIndex == 8)
                                Column(
                                  children: [
                                    Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceEvenly,
                                      children:
                                          _questions[_currentQuestionIndex]
                                              .possibleAnswers
                                              .sublist(0, 5)
                                              .map((answer) {
                                        return _buildNumberCircle(answer);
                                      }).toList(),
                                    ),
                                    const SizedBox(height: 10),
                                    Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceEvenly,
                                      children:
                                          _questions[_currentQuestionIndex]
                                              .possibleAnswers
                                              .sublist(5, 10)
                                              .map((answer) {
                                        return _buildNumberCircle(answer);
                                      }).toList(),
                                    ),
                                  ],
                                )
                              else
                                Column(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceEvenly,
                                  children: _questions[_currentQuestionIndex]
                                      .possibleAnswers
                                      .map((answer) {
                                    return _buildTextButton(answer);
                                  }).toList(),
                                ),
                            ],
                          ),
                        ),
                        const SizedBox(height: 30),
                        Row(
                          crossAxisAlignment: CrossAxisAlignment.center,
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Container(
                              width: 35.0, // Adjust the width of the circle
                              height: 35.0, // Adjust the height of the circle
                              decoration: BoxDecoration(
                                color: Colors.white.withOpacity(
                                    .70), // Background color (light green)
                                shape: BoxShape.circle, // Circular shape
                                boxShadow: [
                                  BoxShadow(
                                    color: Colors.black
                                        .withOpacity(0.15), // Shadow color
                                    spreadRadius:
                                        2, // How much the shadow should spread
                                    blurRadius:
                                        5, // The blur radius of the shadow
                                    offset: const Offset(
                                        0, 2), // Offset the shadow vertically
                                  ),
                                ],
                              ),
                              child: IconButton(
                                icon: const Icon(Icons.arrow_back_ios),
                                color: const Color(
                                    0xFF537F5C), // Set the color of the arrow icon
                                onPressed: _previousQuestion,
                                iconSize: 25.0, // Adjust the size of the icon
                                padding: const EdgeInsets.only(
                                    left: 7), // Adjust padding around the icon
                                splashRadius:
                                    25.0, // Adjust the splash radius on click
                                tooltip: "Next",
                              ),
                            ),
                            SizedBox(
                              width: 110.h,
                            ),
                            Container(
                              width: 35.0, // Adjust the width of the circle
                              height: 35.0, // Adjust the height of the circle
                              decoration: BoxDecoration(
                                color: Colors.white.withOpacity(
                                    .70), // Background color (light green)
                                shape: BoxShape.circle, // Circular shape
                                boxShadow: [
                                  BoxShadow(
                                    color: Colors.black
                                        .withOpacity(0.15), // Shadow color
                                    spreadRadius:
                                        2, // How much the shadow should spread
                                    blurRadius:
                                        5, // The blur radius of the shadow
                                    offset: const Offset(
                                        0, 2), // Offset the shadow vertically
                                  ),
                                ],
                              ),
                              child: IconButton(
                                icon: const Icon(Icons.arrow_forward_ios),
                                color: const Color(
                                    0xFF537F5C), // Set the color of the arrow icon
                                onPressed: _nextQuestion,
                                iconSize: 25.0, // Adjust the size of the icon
                                padding: const EdgeInsets.all(
                                    3.0), // Adjust padding around the icon
                                splashRadius:
                                    25.0, // Adjust the splash radius on click
                                tooltip: "Next",
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 40),
                        buildQuitButton(),
                      ],
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 20),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildNumberCircle(String answer) {
    return GestureDetector(
      onTap: () => _selectAnswer(answer),
      child: CircleAvatar(
        maxRadius: 25,
        backgroundColor: _selectedAnswer == answer
            ? const Color(0xff666556)
            : const Color(0xFFB7B597),
        child: Text(
          answer,
          style: const TextStyle(
            color: Color(0xFF3E1904),
            fontSize: 18,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
    );
  }

  Widget _buildTextButton(String answer) {
    return GestureDetector(
      onTap: () => _selectAnswer(answer),
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: TextButton(
          style: ButtonStyle(
            fixedSize: WidgetStateProperty.all<Size>(const Size(220, 50)),
            backgroundColor: WidgetStateProperty.all<Color>(
              _selectedAnswer == answer
                  ? const Color(0xff666556)
                  : const Color(0xFFB7B597),
            ),
            shape: WidgetStateProperty.all<RoundedRectangleBorder>(
              RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(25.0),
              ),
            ),
            elevation: WidgetStateProperty.all<double>(5.0),
            shadowColor: WidgetStateProperty.all<Color>(
              Colors.black.withOpacity(.80),
            ),
          ),
          onPressed: () => _selectAnswer(answer),
          child: Text(
            answer,
            style: const TextStyle(
              color: Color(0xFF3E1904),
              fontFamily: 'InriaSans-Bold',
              fontSize: 18,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
      ),
    );
  }

  Widget buildQuitButton() {
    return Container(
      width: 200,
      height: 44,
      decoration: BoxDecoration(
        border: Border.all(width: 1, color: Colors.white),
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(.25),
            spreadRadius: 0,
            blurRadius: 4,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: ElevatedButton(
        style: ElevatedButton.styleFrom(
          backgroundColor: const Color(0xff618969),
          shadowColor: const Color(0xff537F5C),
          alignment: Alignment.center,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(20),
          ),
        ),
        onPressed: _showQuitConfirmationDialog,
        child: const Text(
          'Quit test',
          style: TextStyle(
            color: Color(0xffD9D9D9),
            fontSize: 22,
            fontFamily: 'InriaSans-Bold',
            fontWeight: FontWeight.w700,
          ),
        ),
      ),
    );
  }
}
