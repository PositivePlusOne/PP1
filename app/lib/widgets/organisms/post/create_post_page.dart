// Flutter imports:
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

// Package imports:
import 'package:auto_route/auto_route.dart';
import 'package:camerawesome/camerawesome_plugin.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

// Project imports:
import 'package:app/constants/design_constants.dart';
import 'package:app/dtos/database/profile/profile.dart';
import 'package:app/gen/app_router.dart';
import 'package:app/providers/profiles/profile_controller.dart';
import 'package:app/widgets/organisms/post/component/positive_image_editor.dart';
import 'package:app/widgets/organisms/post/create_post_dialogue.dart';
import 'package:app/widgets/organisms/post/vms/create_post_data_structures.dart';
import 'package:app/widgets/organisms/post/vms/create_post_view_model.dart';
import 'package:app/widgets/organisms/shared/components/positive_post_navigation_bar.dart';
import 'package:app/widgets/organisms/shared/positive_camera.dart';
import '../../../dtos/system/design_colors_model.dart';
import '../../../providers/system/design_controller.dart';
import '../../atoms/camera/camera_floating_button.dart';

@RoutePage()
class CreatePostPage extends StatefulHookConsumerWidget {
  const CreatePostPage({
    this.isEditPage = false,
    this.activityData,
    super.key,
  }) : assert(isEditPage == false || (activityData != null));

  final bool isEditPage;
  final ActivityData? activityData;

  @override
  ConsumerState<CreatePostPage> createState() => _CreatePostPageState();
}

class _CreatePostPageState extends ConsumerState<CreatePostPage> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback(onFirstRender);
  }

  void onFirstRender(Duration timeStamp) {
    ref.read(createPostViewModelProvider.notifier).onFilterSelected(AwesomeFilter.None);
    if (widget.isEditPage && widget.activityData != null) {
      ref.read(createPostViewModelProvider.notifier).loadActivityData(context, widget.activityData!);
    } else {
      ref.read(createPostViewModelProvider.notifier).initCamera(context);
    }
  }

  @override
  Widget build(BuildContext context) {
    final DesignColorsModel colours = ref.watch(designControllerProvider.select((value) => value.colors));
    final MediaQueryData mediaQueryData = MediaQuery.of(context);

    final CreatePostViewModel viewModel = ref.read(createPostViewModelProvider.notifier);
    final CreatePostViewModelState state = ref.watch(createPostViewModelProvider);
    final AppRouter appRouter = ref.read(appRouterProvider);

    final Profile? currentProfile = ref.watch(profileControllerProvider.select((value) => value.currentProfile));

    return WillPopScope(
      onWillPop: state.isBusy ? (() async => false) : viewModel.onWillPopScope,
      child: Scaffold(
        backgroundColor: colours.black,
        resizeToAvoidBottomInset: false,
        body: GestureDetector(
          onTap: () => FocusManager.instance.primaryFocus?.unfocus(),
          child: Stack(
            children: <Widget>[
              //* -=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-= *\\
              //* -=-=-=-=-=-                    Camera                    -=-=-=-=-=- *\\
              //* -=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-= *\\
              if (state.currentCreatePostPage == CreatePostCurrentPage.camera) ...[
                Positioned.fill(
                  child: PositiveCamera(
                    onCameraImageTaken: (image) => viewModel.onImageTaken(context, image),
                    cameraNavigation: (_) {
                      return const SizedBox(
                        height: kCreatePostNavigationHeight + kPaddingMedium + kPaddingExtraLarge,
                      );
                    },
                    leftActionWidget: CameraFloatingButton.postWithoutImage(
                      active: true,
                      onTap: (context) => viewModel.showCreateTextPost(context),
                    ),
                    onTapClose: (_) => appRouter.pop(),
                    onTapAddImage: (context) => viewModel.onMultiImagePicker(context),
                    //! Flash controlls in FlutterAwesome do not seem to be working
                    // enableFlashControlls: true,
                  ),
                ),
              ],
              if (state.currentCreatePostPage == CreatePostCurrentPage.editPhoto) ...[
                PositiveImageEditor(
                  galleryEntry: state.editingGalleryEntry,
                  currentFilter: state.currentFilter,
                  onFilterSelected: viewModel.onFilterSelected,
                  onBackButtonPressed: viewModel.onWillPopScope,
                ),
              ],
              //* -=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-= *\\
              //* -=-=-=-=-=-    Background Image on Create Image Post     -=-=-=-=-=- *\\
              //* -=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-= *\\
              if (state.currentCreatePostPage == CreatePostCurrentPage.createPostImage && state.galleryEntries.length == 1) ...[
                Positioned.fill(
                  child: ColorFiltered(
                    colorFilter: ColorFilter.matrix(state.currentFilter.matrix),
                    child: Image.memory(
                      state.galleryEntries.first.data ?? Uint8List(0),
                      fit: BoxFit.cover,
                    ),
                  ),
                ),
              ],
              //* -=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-= *\\
              //* -=-=-=-=-=-              Create Post Dialog              -=-=-=-=-=- *\\
              //* -=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-= *\\
              if (state.currentCreatePostPage.isCreationDialog) ...<Widget>[
                Positioned.fill(
                  child: CreatePostDialogue(
                    isBusy: state.isBusy,
                    postType: state.currentPostType,
                    captionController: viewModel.captionController,
                    altTextController: viewModel.altTextController,
                    onTagsPressed: (context) => viewModel.onTagsPressed(context),
                    onUpdateAllowSharing: viewModel.onUpdateAllowSharing,
                    onUpdateAllowComments: viewModel.onUpdateAllowComments,
                    onUpdateSaveToGallery: state.isEditing ? null : viewModel.onUpdateSaveToGallery,
                    onUpdateVisibleTo: viewModel.onUpdateVisibleTo,
                    valueAllowSharing: state.allowSharing,
                    valueSaveToGallery: state.saveToGallery,
                    galleryEntries: state.galleryEntries,
                    tags: state.tags,
                    initialValueAllowComments: state.allowComments,
                    initialValueSharingVisibility: state.visibleTo,
                  ),
                ),
              ],
              //* -=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-= *\\
              //* -=-=-=-=-=-                Navigation Bar                -=-=-=-=-=- *\\
              //* -=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-= *\\
              Positioned(
                bottom: kPaddingMedium + mediaQueryData.padding.bottom,
                height: kCreatePostNavigationHeight,
                left: kPaddingSmall,
                right: kPaddingSmall,
                //! PP1-984
                child: AnimatedOpacity(
                  opacity: state.activeButton == PositivePostNavigationActiveButton.flex ? 1.0 : 0.01,
                  duration: kAnimationDurationRegular,
                  child: PositivePostNavigationBar(
                    onTapPost: (_) {},
                    onTapClip: (_) {},
                    onTapEvent: (_) {},
                    onTapFlex: (context) => viewModel.onFlexButtonPressed(context, currentProfile),
                    activeButton: PositivePostNavigationActiveButton.flex,
                    flexCaption: state.activeButtonFlexText,
                    isEnabled: viewModel.isNavigationEnabled && !state.isBusy,
                  ),
                ),
                // child: PositivePostNavigationBar(
                //   onTapPost: (_) {},
                //   onTapClip: (_) {},
                //   onTapEvent: (_) {},
                //   onTapFlex: (context) => viewModel.onFlexButtonPressed(context),
                //   activeButton: state.activeButton,
                //   flexCaption: state.activeButtonFlexText,
                //   isEnabled: viewModel.isNavigationEnabled && !state.isBusy,
                // ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
