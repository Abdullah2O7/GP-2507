import 'dart:convert';
import 'dart:developer';
import 'dart:io';
import 'dart:typed_data';

import 'package:awesome_snackbar_content/awesome_snackbar_content.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:http/http.dart' as http;
import 'package:http/http.dart';
import 'package:image_picker/image_picker.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:splash_onboarding_test/Registeration/auth_service.dart';
import 'package:splash_onboarding_test/helpers/show_snackbar.dart';
import 'package:splash_onboarding_test/nav_layout.dart';
import 'package:splash_onboarding_test/views/ConatctUspage/contactUsPage.dart';

import '../helpers/image_storage.dart';

class EditUserProfile extends StatefulWidget {
  final Map<String, dynamic> userData;

  const EditUserProfile({super.key, required this.userData});
  @override
  _EditUserProfile createState() => _EditUserProfile();
}

class _EditUserProfile extends State<EditUserProfile> {
  final GlobalKey<FormState> formKey = GlobalKey<FormState>();
  final TextEditingController nameController = TextEditingController();
  final TextEditingController emailController = TextEditingController();
  final TextEditingController bioController = TextEditingController();

  File? _image;
  late Uint8List _imageData = Uint8List(0); // Initialize with an empty list
// For displaying the base64 image
  final ImagePicker _picker = ImagePicker();
  late String _selectedGender;
  List<String> genderOptions = ['Female', 'Male', 'Other'];

  String capitalize(String? s) {
    if (s == null || s.isEmpty) return '';
    return s[0].toUpperCase() + s.substring(1).toLowerCase();
  }

  @override
  void initState() {
    super.initState();
    nameController.text = widget.userData['name'] ?? '';
    emailController.text = widget.userData['email'] ?? '';
    bioController.text = widget.userData['bio'] ?? '';

    // Initialize _selectedGender with a value from genderOptions
    String userGender = capitalize(widget.userData['gender']?.toString());
    if (genderOptions.contains(userGender)) {
      _selectedGender = userGender;
    } else {
      _selectedGender =
          'Other'; // fallback if userGender does not match any option
    }

    if (widget.userData['picture'] != null) {
      try {
        String base64Image = widget.userData['picture'];
        if (base64Image.startsWith('data:image/jpeg;base64,')) {
          base64Image = base64Image.replaceFirst('data:image/jpeg;base64,', '');
        }
        _imageData = base64Decode(base64Image);
      } catch (e) {
        print('Failed to decode image: $e');
        _imageData = Uint8List(0); // Assign an empty list in case of error
      }
    }
  }

  @override
  void dispose() {
    nameController.dispose();
    emailController.dispose();
    bioController.dispose();
    super.dispose();
  }

  Future<void> _showImagePickerDialog() async {
    return showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              ListTile(
                leading: const Icon(Icons.camera_alt),
                title: const Text('Camera'),
                onTap: () {
                  _pickImage(ImageSource.camera);
                  Navigator.of(context).pop();
                },
              ),
              ListTile(
                leading: const Icon(Icons.photo_library),
                title: const Text('Gallery'),
                onTap: () {
                  _pickImage(ImageSource.gallery);
                  Navigator.of(context).pop();
                },
              ),
            ],
          ),
        );
      },
    );
  }

  Future<void> _pickImage(ImageSource source) async {
    final pickedFile = await _picker.pickImage(source: source);
    if (pickedFile != null) {
      setState(() {
        _image = File(pickedFile.path);
      });
    }
  }

  String? _validateName(String? value) {
    if (value == null || value.isEmpty) {
      return 'Please enter your name';
    }
    return null;
  }

  String? _validateBio(String? value) {
    if (value == null || value.isEmpty) {
      return 'Please enter a bio';
    }
    return null;
  }

  String? _validateEmail(String? value) {
    if (value == null || value.isEmpty) {
      return 'Please enter your email';
    }

    String pattern =
        r"^[a-zA-Z0-9!#$%&'*+/=?^_`{|}~-]+(?:\.[a-zA-Z0-9!#$%&'*+/=?^_`{|}~-]+)*@(?:[a-zA-Z0-9-]+\.)+[a-zA-Z]{2,7}$";

    RegExp regex = RegExp(pattern);
    if (!regex.hasMatch(value)) {
      return 'Enter a valid email address';
    }
    return null;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFFFFAEF),
      appBar: AppBar(
        backgroundColor: const Color(0xFF537F5C),
        automaticallyImplyLeading: false,
        iconTheme: const IconThemeData(color: Colors.white),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios),
          color: Colors.white,
          onPressed: () {
            //pop
            Navigator.pop(context);
          },
          iconSize: 25.0,
          splashRadius: 25.0,
          tooltip: "Back",
        ),
        actions: [
          TextButton(
            onPressed: () async {
              final String? token = await getToken();
              log(token!);
              Map<String, dynamic> updatedData = {};

              // Check if each field has changed, and add only updated fields
              if (nameController.text != widget.userData['name']) {
                updatedData['username'] = nameController.text;
              }
              if (emailController.text != widget.userData['email']) {
                updatedData['email'] = emailController.text;
              }
              if (bioController.text != widget.userData['bio']) {
                updatedData['bio'] = bioController.text;
              }
              if (_selectedGender != widget.userData['gender']) {
                updatedData['gender'] = _selectedGender;
              }

              await AuthService.updateLoginInfo(
                  email: emailController.text, username: nameController.text);
              // update token
              // log(updatedData);
              final SharedPreferences prefs =
                  await SharedPreferences.getInstance();
              log(prefs.getString('email')!);
              log(prefs.getString('username')!);

              // Encode image if it has been picked
              if (_image != null) {
                List<int> imageBytes = await _image!.readAsBytes();
                String base64Image = base64Encode(imageBytes);
                updatedData['picture'] = 'data:image/jpeg;base64,$base64Image';

                await ImageStorage.saveImage(updatedData['picture']!);
              }

              if (updatedData.isNotEmpty) {
                // Make API request
                Response response = await http.patch(
                  Uri.parse(
                      'https://gpappapis.azurewebsites.net/api/edit-profile'),
                  headers: {
                    'Content-Type': 'application/json',
                    'Authorization': token,
                  },
                  body: jsonEncode(updatedData),
                );
                print('Response Status: ${response.statusCode}');
                print('Response Headers: ${response.headers}');
                print('Full Response Body: ${response.body}');

                if (response.statusCode == 200) {
                  final responseBody = jsonDecode(response.body);
                  String token = responseBody['token'];
                  await AuthService.setToken(token);
                  print('Full Response Body: ${response.body}');

                  String message = responseBody['message'] ??
                      'Profile updated successfully!';

                  // Show message Snackbar
                  showSnackbar(
                    context,
                    'Profile updated',
                    message,
                    ContentType.success,
                  );
                  navigateToHome(context);
                  // Print the full response to console
                  print('Full Response: $responseBody');
                } else {
                  // Show error message in AlertDialog
                  final responseBody = jsonDecode(response.body);

                  showSnackbar(
                    context,
                    'Error',
                    responseBody['error'],
                    ContentType.failure,
                    fontsize: 14,
                    height: 120,
                  );
                }
              } else {
                // Show "No Changes" message in AlertDialog
                showSnackbar(
                  context,
                  'No Changes',
                  'No changes made. Profile saved successfully!',
                  ContentType.warning,
                );
                navigateToHome(context);
              }
            },
            child: const Text(
              'Done',
              style: TextStyle(
                color: Colors.white,
                fontSize: 18,
                fontWeight: FontWeight.bold,
                fontFamily: 'Inter',
              ),
            ),
          ),
        ],
      ),
      body: SingleChildScrollView(
        child: Form(
          key: formKey,
          child: Column(
            children: [
              SizedBox(
                height: 20.h,
              ),
              Center(
                child: GestureDetector(
                  onTap: _showImagePickerDialog,
                  child: CircleAvatar(
                    radius: 50,
                    backgroundColor: Colors.grey[300],
                    backgroundImage: _image != null
                        ? FileImage(_image!)
                        : _imageData.isNotEmpty
                            ? MemoryImage(_imageData)
                            : null,
                    child: _image == null && _imageData.isEmpty
                        ? const Icon(Icons.camera_alt, size: 40)
                        : null,
                  ),
                ),
              ),
              const SizedBox(height: 20),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 32),
                child: Row(
                  children: [
                    const Text(
                      "Name",
                      style: TextStyle(
                        color: Color(0xff42664A),
                        fontSize: 16,
                        fontFamily: 'Inter',
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                    const SizedBox(width: 30),
                    Expanded(
                      child: TextFormField(
                        controller: nameController,
                        autovalidateMode: AutovalidateMode.onUserInteraction,
                        validator: _validateName,
                        cursorColor: const Color(0xff42664A),
                        style: const TextStyle(
                          color: Color(0xff42664A),
                          fontSize: 16,
                        ),
                        decoration: const InputDecoration(
                          hoverColor: Color(0xff42664A),
                          enabledBorder: UnderlineInputBorder(
                            borderSide: BorderSide(color: Color(0xff42664A)),
                          ),
                          focusedBorder: UnderlineInputBorder(
                            borderSide: BorderSide(color: Color(0xff42664A)),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 20),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 32),
                child: Row(
                  children: [
                    const Text(
                      "Email",
                      style: TextStyle(
                        color: Color(0xff42664A),
                        fontSize: 18,
                        fontFamily: 'Inter',
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                    const SizedBox(width: 28),
                    Expanded(
                      child: TextFormField(
                        controller: emailController,
                        autovalidateMode: AutovalidateMode.onUserInteraction,
                        validator: _validateEmail,
                        cursorColor: const Color(0xff42664A),
                        style: const TextStyle(
                          color: Color(0xff42664A),
                          fontSize: 18,
                        ),
                        decoration: const InputDecoration(
                          hoverColor: Color(0xff42664A),
                          enabledBorder: UnderlineInputBorder(
                            borderSide: BorderSide(color: Color(0xff42664A)),
                          ),
                          focusedBorder: UnderlineInputBorder(
                            borderSide: BorderSide(color: Color(0xff42664A)),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 40),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 32),
                child: Row(
                  children: [
                    const Text(
                      "Gender",
                      style: TextStyle(
                        color: Color(0xff42664A),
                        fontSize: 16,
                        fontFamily: 'Inter',
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                    const SizedBox(width: 40),
                    Container(
                      height: 40,
                      // width: 60,
                      padding: const EdgeInsets.symmetric(horizontal: 10),
                      decoration: BoxDecoration(
                        color: const Color(0xff6B7280).withOpacity(.30),
                        border: Border.all(
                            color: const Color(0xff42664A), width: 1.5),
                        borderRadius: BorderRadius.circular(10),
                      ),
                      child: DropdownButton<String>(
                        value: _selectedGender,
                        icon: const Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            VerticalDivider(
                              color: Color(0xff42664A),
                              thickness: 1.5,
                            ),
                            Icon(Icons.arrow_drop_down,
                                size: 38, color: Color(0xff42664A)),
                          ],
                        ),
                        underline: const SizedBox(),
                        dropdownColor: const Color(
                            0xffFFFAEF), // Set the dropdown background color
                        onChanged: (String? newValue) {
                          setState(() {
                            _selectedGender = newValue!;
                          });
                        },
                        items: genderOptions
                            .map<DropdownMenuItem<String>>((String value) {
                          return DropdownMenuItem<String>(
                            value: value,
                            child: Text(
                              value,
                              style: const TextStyle(
                                  fontSize: 20,
                                  color: Color(0xff42664A),
                                  fontFamily: 'Inter'),
                            ),
                          );
                        }).toList(),
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 40),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 32),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      "Bio",
                      style: TextStyle(
                        color: Color(0xff42664A),
                        fontSize: 16,
                        fontFamily: 'Inter',
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                    const SizedBox(width: 48),
                    Expanded(
                      child: TextFormField(
                        controller: bioController,
                        autovalidateMode: AutovalidateMode.onUserInteraction,
                        validator: _validateBio,
                        maxLines: null,
                        minLines: 3,
                        keyboardType: TextInputType.multiline,
                        cursorColor: const Color(0xff42664A),
                        style: const TextStyle(
                          color: Color(0xff42664A),
                          fontSize: 16,
                        ),
                        decoration: const InputDecoration(
                          hoverColor: Color(0xff42664A),
                          enabledBorder: UnderlineInputBorder(
                            borderSide: BorderSide(color: Color(0xff42664A)),
                          ),
                          focusedBorder: UnderlineInputBorder(
                            borderSide: BorderSide(color: Color(0xff42664A)),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              // const SizedBox(height: 200),
              // const BarButton(),
              // Remaining fields and button
            ],
          ),
        ),
      ),
    );
  }

  void navigateToHome(BuildContext context) {
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(builder: (context) => const NavLayout()),
    );
  }
}
