import 'package:flutter/material.dart';

import 'package:splash_onboarding_test/components/custom_card_widget.dart';
import 'package:splash_onboarding_test/views/widgets/user_image.dart';
import 'Registeration/auth_service.dart';
import 'package:splash_onboarding_test/views/DepressionOrBipolarTest/DepOrBi_Test.dart';
import 'package:splash_onboarding_test/views/General_Test.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  bool isGuest = false;
  TextEditingController searchController = TextEditingController();
  List<Map<String, dynamic>> tests = [
    {"text": "Depression\nOr\nBipolar", "destination": const DeporbiTest(), "imagePath": "assets/image.png"},
    
    {"text": "General\nTest", "destination": const GeneralTest(), "imagePath": "assets/Generaltest.png"},
  ];
  List<Map<String, dynamic>> filteredTests = [];

  @override
  void initState() {
    super.initState();
    _isGuest();
    filteredTests = List.from(tests); // Initially, all tests are displayed
  }

  Future<bool> _isGuest() async {
    isGuest = await AuthService.isGuest() ?? false;
    return isGuest;
  }

  void filterTests(String query) {
    setState(() {
      if (query.isEmpty) {
        filteredTests = List.from(tests);
      } else {
        filteredTests = tests
            .where((test) =>
                test["text"].toLowerCase().contains(query.toLowerCase()))
            .toList();
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xffFFFAEF),
      appBar: AppBar(
        title: const Padding(
          padding: EdgeInsets.only(left: 5),
          child: Text(
            'MALAZ',
            style: TextStyle(
              decoration: TextDecoration.underline,
              decorationColor: Color(0xff849A8A),
              color: Color(0xff849A8A),
              fontSize: 30,
              fontFamily: 'Ledger',
            ),
          ),
        ),
        automaticallyImplyLeading: false,
        backgroundColor: Colors.transparent,
        actions: [
          Padding(
            padding: const EdgeInsets.only(bottom: 3),
            child: Container(
              margin: const EdgeInsets.only(right: 10),
              width: 50,
              height: 50,
              child: const ClipOval(
                child: UserImage(),
              ),
            ),
          ),
        ],
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            const SizedBox(height: 20),
            Container(
              margin: const EdgeInsets.symmetric(horizontal: 7),
              padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 12),
              width: double.infinity,
              decoration: BoxDecoration(
                border: Border.all(width: 1, color: Colors.black),
                color: const Color(0xff537F5C),
                borderRadius: BorderRadius.circular(20),
              ),
              child: Row(
                children: [
                  Text(
                    '"Getting help is a\n sign of wisdom, \n not weakness."',
                    style: TextStyle(
                      fontSize: 20,
                      color: Colors.white.withOpacity(.80),
                      fontWeight: FontWeight.w500,
                      shadows: [
                        Shadow(
                          offset: const Offset(3.0, 3.0),
                          blurRadius: 5.0,
                          color: Colors.black.withOpacity(.50),
                        ),
                      ],
                    ),
                  ),
                  const Spacer(),
                  Image.asset('assets/logo.png'),
                ],
              ),
            ),
            const SizedBox(height: 14),
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 15),
              child: SizedBox(
                height: 40,
                width: 400,
                child: TextFormField(
                  style: const TextStyle(color: Color(0xFF537F5C)),
                  controller: searchController,
                  autofocus: false,
                  cursorColor:const Color(0xFF537F5C),
                  onChanged: filterTests,
                  decoration: InputDecoration(
                    filled: true,
                    fillColor: const Color(0xffFFFAEF),
                    prefixIcon: const Icon(Icons.search, color: Color(0xFF537F5C)),
                    suffixIcon: IconButton(
                      icon: const Icon(Icons.mic_none, color: Color(0xFF537F5C)),
                      onPressed: () {
                        filterTests(searchController.text);
                      },
                    ),
                    hintText: 'Search for test',
                  
                    hintStyle: const TextStyle(
                      color: Color(0xFF537F5C),
                      fontFamily: 'Ledger',
                      fontSize: 16,
                    ),
                    contentPadding: const EdgeInsets.symmetric(vertical: 2.0),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(25.0),
                      borderSide: const BorderSide(
                        color: Color(0xFF52734D),
                        width: 1.2,
                      ),
                    ),
                    enabledBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(25.0),
                      borderSide: const BorderSide(
                        color: Color(0xFF537F5C),
                        width: 1.2,
                      ),
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(25.0),
                      borderSide: const BorderSide(
                        color: Color(0xFF537F5C),
                        width: 1.2,
                      ),
                    ),
                  ),
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(left: 10),
              child: SizedBox(
                height: 370,
                child: ListView.builder(
                  scrollDirection: Axis.horizontal,
                  itemCount: filteredTests.length,
                  itemBuilder: (context, index) {
                    return Row(
                       mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        
                        CustomCardWidget(
                          imagePath: filteredTests[index]["imagePath"],
                          text: filteredTests[index]["text"],
                          destination: filteredTests[index]["destination"],
                        ),
                        const SizedBox(width: 10,),
                      ],
                    );
                  },
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
