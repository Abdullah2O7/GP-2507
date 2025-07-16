import 'dart:convert';

import 'package:flutter/foundation.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:http/http.dart' as http;
import 'package:splash_onboarding_test/cubits/user_image_state.dart';
import 'package:splash_onboarding_test/helpers/resize_image.dart';

import '../helpers/image_storage.dart';
import '../views/ConatctUspage/contactUsPage.dart';

class UserImageCubit extends Cubit<UserImageState> {
  UserImageCubit() : super(UserImageInitial());

  Future<void> loadImage() async {
    String? userImage = await ImageStorage.getImage();
    if (userImage == null) {
      emit(UserImageError("No image provided"));
      return;
    }

    emit(UserImageLoading());

    try {
      userImage = await ImageStorage.getImage();

      final resizedImage = await resizeImage(userImage!);
      emit(UserImageLoaded(resizedImage));
    } catch (e) {
      emit(UserImageError("Failed to load image: $e"));
    }
  }
}

class UserProfileCubit extends Cubit<UserProfileState> {
  UserProfileCubit() : super(UserProfileInitial());

  Future<void> fetchUserProfile() async {
    emit(UserProfileLoading());

    final token = await getToken();
    if (token == null) {
      emit(UserProfileError("Token not found"));
      return;
    }

    final url =
        Uri.parse('https://gpappapis.azurewebsites.net/api/user/profile');

    try {
      final response = await http.get(
        url,
        headers: {
          'Authorization': token,
          'Content-Type': 'application/json',
        },
      );
      final resizedImage =
          await resizeImage(jsonDecode(response.body)['picture']);

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        emit(UserProfileLoaded(
          name: data['name'],
          image: resizedImage,
          email: data['email'],
          bio: data['bio'],
          gender: data['gender'],
        ));
      } else {
        emit(UserProfileError("Failed to fetch profile: ${response.body}"));
      }
    } catch (e) {
      emit(UserProfileError("Error fetching profile: $e"));
    }
  }
}

abstract class UserProfileState {}

class UserProfileInitial extends UserProfileState {}

class UserProfileLoading extends UserProfileState {}

class UserProfileLoaded extends UserProfileState {
  final String name;
  final Uint8List image;
  final String email;
  final String bio;
  final String gender;

  UserProfileLoaded({
    required this.name,
    required this.image,
    required this.email,
    required this.bio,
    required this.gender,
  });
}

class UserProfileError extends UserProfileState {
  final String message;

  UserProfileError(this.message);
}
