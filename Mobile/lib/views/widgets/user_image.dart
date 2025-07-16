import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:splash_onboarding_test/components/custom_shimmer.dart';

import '../../cubits/user_image_cubit.dart';

class UserImage extends StatelessWidget {
  const UserImage({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<UserProfileCubit, UserProfileState>(
          builder: (context, state) {
            if (state is UserProfileLoading) {
              return const CustomShimmer(
                height: 50,
                width: 50,
                shape: BoxShape.circle,
              );
            } else if (state is UserProfileLoaded) {
              return Image.memory(
                state.image,
                fit: BoxFit.cover,
              );
            } else if (state is UserProfileError) {
              print(state.message);
              return Image.asset(
                'assets/contact.png',
                fit: BoxFit.cover,
              );
            }

            return const SizedBox();
          },
        );
  }
}
