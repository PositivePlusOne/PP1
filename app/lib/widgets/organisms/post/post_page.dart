// Flutter imports:
import 'package:app/widgets/organisms/post/create_post_dialogue.dart';
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
import '../../../dtos/system/design_colors_model.dart';
import '../../../providers/system/design_controller.dart';
import '../../atoms/camera/camera_floating_button.dart';
import '../shared/components/positive_post_navigation_bar.dart';

@RoutePage()
class PostPage extends ConsumerWidget {
  const PostPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final DesignColorsModel colors = ref.watch(designControllerProvider.select((value) => value.colors));
    final AppRouter router = ref.read(appRouterProvider);

    final CreatePostViewModel viewModel = ref.read(createPostViewModelProvider.notifier);
    final CreatePostViewModelState state = ref.watch(createPostViewModelProvider);

    return AnnotatedRegion(
      value: SystemUiOverlayStyle(
        statusBarColor: colors.transparent,
      ),
      child: Scaffold(
        body: CreatePostDialog(),
        //   body: PositiveCamera(
        //     onCameraImageTaken: (path) async {},
        //     cameraNavigation: navigation,
        //     leftActionCallback: () => viewModel.showCreatePostDialogue(context),
        //     topChildren: [
        //       CameraFloatingButton.close(active: true, onTap: () => router.pop()),
        //       CameraFloatingButton.addImage(active: true, onTap: () {}),
        //     ],
        //   ),
      ),
    );
  }
}

Widget navigation(CameraState state) {
  return PositivePostNavigationBar(
    onTapPost: () {},
    onTapClip: () {},
    onTapEvent: () {},
    onTapFlex: () {},
    activeButton: PositivePostNavigationActiveButton.post,
    flexCaption: "Next",
  );
}
