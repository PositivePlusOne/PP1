// Flutter imports:
import 'package:flutter/material.dart';

// Package imports:
import 'package:auto_route/auto_route.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:photo_view/photo_view.dart';

// Project imports:
import 'package:app/constants/design_constants.dart';
import 'package:app/dtos/database/common/media.dart';
import 'package:app/widgets/atoms/buttons/positive_back_button.dart';
import 'package:app/widgets/atoms/imagery/positive_media_image.dart';

@RoutePage()
class MediaPage extends ConsumerWidget {
  const MediaPage({super.key, required this.media});
  final Media media;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final MediaQueryData mediaQueryData = MediaQuery.of(context);
    return Stack(
      children: <Widget>[
        if (media.type.isImage) ...<Widget>[
          PhotoView(
            imageProvider: PositiveMediaImageProvider(
              media: media,
              useThumbnailIfAvailable: false,
            ),
          ),
        ],
        Positioned(
          top: kPaddingNone,
          left: kPaddingNone,
          bottom: kPaddingMedium + mediaQueryData.padding.bottom,
          right: kPaddingMedium,
          child: const PositiveBackButton(),
        ),
      ],
    );
  }
}
