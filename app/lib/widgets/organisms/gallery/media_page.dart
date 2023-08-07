// Flutter imports:
import 'package:flutter/material.dart';

// Package imports:
import 'package:auto_route/auto_route.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:photo_view/photo_view.dart';
import 'package:unicons/unicons.dart';

// Project imports:
import 'package:app/dtos/database/common/media.dart';
import 'package:app/dtos/system/design_colors_model.dart';
import 'package:app/gen/app_router.dart';
import 'package:app/providers/system/design_controller.dart';
import 'package:app/widgets/atoms/imagery/positive_media_image.dart';

@RoutePage()
class MediaPage extends ConsumerWidget {
  const MediaPage({super.key, required this.media});
  final Media media;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final DesignColorsModel colors = ref.read(designControllerProvider.select((value) => value.colors));
    final AppRouter appRouter = ref.read(appRouterProvider);

    return Scaffold(
      backgroundColor: colors.black,
      floatingActionButton: FloatingActionButton(
        backgroundColor: colors.white,
        onPressed: () => appRouter.pop(),
        child: Icon(UniconsLine.multiply, color: colors.black),
      ),
      body: Stack(
        children: <Widget>[
          if (media.type.isImage) ...<Widget>[
            PhotoView(
              backgroundDecoration: BoxDecoration(
                color: colors.black,
              ),
              imageProvider: PositiveMediaImageProvider(
                media: media,
                useThumbnailIfAvailable: false,
              ),
            ),
          ],
        ],
      ),
    );
  }
}
