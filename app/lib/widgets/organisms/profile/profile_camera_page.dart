// Dart imports:

// Dart imports:
import 'dart:io';

// Flutter imports:
import 'package:flutter/material.dart';

// Package imports:
import 'package:auto_route/auto_route.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

// Project imports:
import 'package:app/widgets/organisms/profile/vms/profile_photo_view_model.dart';
import 'package:app/widgets/organisms/shared/positive_camera.dart';

// Project imports:

@RoutePage()
class ProfileCameraPage extends ConsumerWidget {
  const ProfileCameraPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final ProfilePhotoViewModel viewModel = ref.watch(profilePhotoViewModelProvider.notifier);

    return Scaffold(
      body: PositiveCamera(
        fileName: "positiveselfie",
        onCameraImageTaken: (path) {
          viewModel.onTakeSelfie(path);
        },
      ),
    );
  }
}
