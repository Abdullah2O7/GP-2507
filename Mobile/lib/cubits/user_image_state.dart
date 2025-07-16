import 'package:flutter/services.dart';

abstract class UserImageState {}

class UserImageInitial extends UserImageState {}

class UserImageLoading extends UserImageState {}

class UserImageLoaded extends UserImageState {
  final Uint8List image;

  UserImageLoaded(this.image);
}

class UserImageError extends UserImageState {
  final String message;

  UserImageError(this.message);
}
