// Dart imports:
import 'dart:io';

// Flutter imports:
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

// Package imports:
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:auto_route/auto_route.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

// Project imports:
import 'package:app/constants/design_constants.dart';
import 'package:app/widgets/organisms/post/create_post_dialogue.dart';
import 'package:app/widgets/organisms/post/vms/create_post_data_structures.dart';
import 'package:app/widgets/organisms/post/vms/create_post_view_model.dart';
import 'package:app/widgets/organisms/shared/positive_camera.dart';
import '../../../dtos/system/design_colors_model.dart';
import '../../../providers/system/design_controller.dart';
import '../../atoms/camera/camera_floating_button.dart';
import '../shared/components/positive_post_navigation_bar.dart';

@RoutePage()
class PostPage extends ConsumerStatefulWidget {
  const PostPage({
    this.isEditPage = false,
    this.activityData,
    this.localisations,
    super.key,
  }) : assert(isEditPage == false || (activityData != null && localisations != null));

  final bool isEditPage;
  final ActivityData? activityData;
  final AppLocalizations? localisations;

  @override
  ConsumerState<PostPage> createState() => _PostPageState();
}

class _PostPageState extends ConsumerState<PostPage> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (widget.isEditPage) {
        ref.read(createPostViewModelProvider.notifier).loadActivityData(context, widget.activityData!);
      }
    });
  }

  @override
  Widget build(BuildContext context) {
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
                      onTapClose: viewModel.onWillPopScope,
                      onTapAddImage: () => viewModel.onMultiImagePicker(context),
                      //! Flash controlls in FlutterAwesome do not seem to be working
                      // enableFlashControlls: true,
                    ),
                  ),
                ],
                //* -=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-= *\\
                //* -=-=-=-=-=-    Background Image on Create Image Post     -=-=-=-=-=- *\\
                //* -=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-= *\\
                if (state.currentCreatePostPage == CreatePostCurrentPage.createPostImage && viewModel.singleImagePath.isNotEmpty) ...[
                  Positioned.fill(
                    child: Image.file(
                      File(viewModel.singleImagePath),
                      fit: BoxFit.cover,
                    ),
                  ),
                ],
                //* -=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-= *\\
                //* -=-=-=-=-=-              Create Post Dialog              -=-=-=-=-=- *\\
                //* -=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-= *\\
                if (state.currentCreatePostPage != CreatePostCurrentPage.camera)
                  Positioned.fill(
                    child: CreatePostDialogue(
                      isBusy: state.isBusy,
                      postType: state.currentPostType,
                      captionController: viewModel.captionController,
                      altTextController: viewModel.altTextController,
                      onTagsPressed: () => viewModel.onTagsPressed(context),
                      onUpdateAllowSharing: viewModel.onUpdateAllowSharing,
                      onUpdateAllowComments: viewModel.onUpdateAllowComments,
                      onUpdateSaveToGallery: viewModel.isEditMode ? null : viewModel.onUpdateSaveToGallery,
                      onUpdateVisibleTo: viewModel.onUpdateVisibleTo,
                      valueAllowSharing: state.allowSharing,
                      valueSaveToGallery: state.saveToGallery,
                      multiImageFiles: viewModel.multiImageXFiles,
                      tags: state.tags,
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
                    onTapFlex: () => viewModel.onPostFinished(context),
                    activeButton: state.activeButton,
                    flexCaption: state.activeButtonFlexText,
                    isEnabled: viewModel.isNavigationEnabled,
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
