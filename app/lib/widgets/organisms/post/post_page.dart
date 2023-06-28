// Flutter imports:
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

    return AnnotatedRegion(
      value: SystemUiOverlayStyle(
        statusBarColor: colors.transparent,
      ),
      child: Scaffold(
        body: PositiveCamera(
          onCameraImageTaken: (path) async {},
          cameraNavigation: navigation,
          leftActionCallback: () {},
          topChildren: [
            CameraFloatingButton.close(active: true, onTap: () => router.pop()),
            CameraFloatingButton.addImage(active: true, onTap: () {}),
          ],
        ),
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
