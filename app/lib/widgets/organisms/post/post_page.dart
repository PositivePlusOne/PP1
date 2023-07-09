// Flutter imports:
import 'dart:io';

import 'package:app/constants/design_constants.dart';
import 'package:app/widgets/molecules/scaffolds/positive_scaffold.dart';
import 'package:app/widgets/organisms/post/create_post_dialogue.dart';
import 'package:app/widgets/organisms/post/vms/create_post_enums.dart';
import 'package:app/widgets/organisms/post/vms/create_post_view_model.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

// Package imports:
import 'package:auto_route/auto_route.dart';
import 'package:camerawesome/camerawesome_plugin.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

// Project imports:
import 'package:app/gen/app_router.dart';
import 'package:app/widgets/organisms/shared/positive_camera.dart';
import '../../../dtos/database/activities/activities.dart';
import '../../../dtos/system/design_colors_model.dart';
import '../../../providers/system/design_controller.dart';
import '../../atoms/camera/camera_floating_button.dart';
import '../shared/components/positive_post_navigation_bar.dart';

@RoutePage()
class PostPage extends ConsumerWidget {
  const PostPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final DesignColorsModel colours = ref.watch(designControllerProvider.select((value) => value.colors));
    final MediaQueryData mediaQueryData = MediaQuery.of(context);

    final CreatePostViewModel viewModel = ref.read(createPostViewModelProvider.notifier);
    final CreatePostViewModelState state = ref.watch(createPostViewModelProvider);

    return AnnotatedRegion(
      value: SystemUiOverlayStyle(
        statusBarColor: colours.transparent,
      ),
      child: WillPopScope(
        onWillPop: state.isBusy ? (() async => false) : viewModel.onWillPopScope,
        child: Scaffold(
          backgroundColor: colours.black,
          body: GestureDetector(
            onTap: () => FocusManager.instance.primaryFocus?.unfocus(),
            child: Stack(
              children: [
                //* -=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-= *\\
                //* -=-=-=-=-=-                    Camera                    -=-=-=-=-=- *\\
                //* -=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-= *\\
                if (state.currentCreatePostPage == CreatePostCurrentPage.camera) ...[
                  Positioned.fill(
                    child: PositiveCamera(
                      onCameraImageTaken: (image) => viewModel.onImageTaken(context, image),
                      cameraNavigation: (_) {
                        return SizedBox(
                          height: kCreatePostNavigationHeight + mediaQueryData.padding.bottom,
                        );
                      },
                      leftActionWidget: CameraFloatingButton.postWithoutImage(
                        active: true,
                        onTap: () => viewModel.showCreateTextPost(context),
                      ),
                      topChildren: [
                        CameraFloatingButton.close(active: true, onTap: viewModel.onWillPopScope),
                        CameraFloatingButton.addImage(active: true, onTap: () {}),
                      ],
                    ),
                  ),
                ],
                //* -=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-= *\\
                //* -=-=-=-=-=-    Background Image on Create Image Post     -=-=-=-=-=- *\\
                //* -=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-= *\\
                if (state.currentCreatePostPage == CreatePostCurrentPage.createPostImage && state.imagePaths.isNotEmpty) ...[
                  Positioned.fill(
                    child: Image.file(
                      File(state.imagePaths.first),
                      fit: BoxFit.cover,
                    ),
                  ),
                ],
                //* -=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-= *\\
                //* -=-=-=-=-=-              Create Post Dialog              -=-=-=-=-=- *\\
                //* -=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-= *\\
                if (state.currentCreatePostPage != CreatePostCurrentPage.camera)
                  Positioned.fill(
                    child: CreatePostDialog(
                      onWillPopScope: viewModel.onWillPopScope,
                      postType: state.currentPostType,
                      captionController: viewModel.captionController,
                      altTextController: viewModel.altTextController,
                    ),
                  ),
                //* -=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-= *\\
                //* -=-=-=-=-=-                Navigation Bar                -=-=-=-=-=- *\\
                //* -=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-= *\\
                Positioned(
                  bottom: kPaddingSmall + mediaQueryData.padding.bottom,
                  height: kCreatePostNavigationHeight,
                  left: kPaddingSmall,
                  right: kPaddingSmall,
                  child: PositivePostNavigationBar(
                    onTapPost: () {},
                    onTapClip: () {},
                    onTapEvent: () {},
                    onTapFlex: () => viewModel.onPostFinished(),
                    activeButton: state.activeButton,
                    flexCaption: state.activeButtonFlexText,
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
