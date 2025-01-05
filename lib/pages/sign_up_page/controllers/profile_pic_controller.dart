import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:image_picker/image_picker.dart';

@immutable
sealed class ProfileImageStates {
  const ProfileImageStates();
}

@immutable
final class ImageInitialState extends ProfileImageStates {}

@immutable
final class ImageLoadingState extends ProfileImageStates {}

@immutable
final class ImagePickedState extends ProfileImageStates {
  final String imagePath;
  const ImagePickedState({required this.imagePath});
}

final class ImageErrorState extends ProfileImageStates {
  static const errorMessage = 'Image not picked';
}

class ProfilePicController extends Notifier<ProfileImageStates> {
  @override
  build() {
    return ImageInitialState();
  }

  onPickImageClicked() async {
    state = ImageLoadingState();
    final imagePath =
        await ImagePicker().pickImage(source: ImageSource.gallery);
    if (imagePath != null) {
      state = ImagePickedState(
        imagePath: imagePath.path,
      );
    } else {
      state = ImageErrorState();
    }
  }
}

final profileImageProvider =
    NotifierProvider<ProfilePicController, ProfileImageStates>(
        ProfilePicController.new);
