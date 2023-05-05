// Dart imports:

// Flutter imports:
import 'dart:io';

import 'package:app/widgets/organisms/profile/vms/profile_photo_view_model.dart';
import 'package:app/widgets/organisms/shared/positive_camera.dart';
import 'package:flutter/material.dart';

// Package imports:
import 'package:auto_route/auto_route.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

// Project imports:

@RoutePage()
class ProfileCameraPage extends ConsumerWidget {
  const ProfileCameraPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final ProfilePhotoViewModel viewModel = ref.watch(profilePhotoViewModelProvider.notifier);

    return Scaffold(
      body: PositiveCamera(onCameraImageTaken: (path) {
        viewModel.onTakeSelfie(path);
      }),
    );
  }
}
