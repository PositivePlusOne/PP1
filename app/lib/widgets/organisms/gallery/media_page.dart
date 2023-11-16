// Flutter imports:
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

// Package imports:
import 'package:auto_route/auto_route.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:photo_view/photo_view.dart';

// Project imports:
import 'package:app/constants/design_constants.dart';
import 'package:app/dtos/database/common/media.dart';
import 'package:app/dtos/system/design_colors_model.dart';
import 'package:app/providers/system/design_controller.dart';
import 'package:app/widgets/atoms/buttons/positive_close_button.dart';
import 'package:app/widgets/atoms/imagery/positive_media_image.dart';

@RoutePage()
class MediaPage extends ConsumerWidget {
  const MediaPage({super.key, required this.media});
  final Media media;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final DesignColorsModel colors = ref.read(designControllerProvider.select((value) => value.colors));

    final MediaQueryData mediaQuery = MediaQuery.of(context);
    final double topPadding = mediaQuery.padding.top;

    return AnnotatedRegion<SystemUiOverlayStyle>(
      value: SystemUiOverlayStyle.light,
      child: Scaffold(
        backgroundColor: colors.black,
        body: Stack(
          children: <Widget>[
            if (media.type.isImage) ...<Widget>[
              PhotoView(
                minScale: PhotoViewComputedScale.contained,
                maxScale: PhotoViewComputedScale.covered * 2,
                backgroundDecoration: BoxDecoration(
                  color: colors.black,
                ),
                imageProvider: PositiveMediaImageProvider(
                  media: media,
                  useThumbnailIfAvailable: false,
                ),
              ),
            ],
            Positioned(
              top: topPadding + kPaddingMedium,
              right: kPaddingMedium,
              child: const PositiveCloseButton(brightness: Brightness.dark),
            ),
          ],
        ),
      ),
    );
  }
}
