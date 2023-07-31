// Flutter imports:
import 'package:flutter/material.dart';

// Package imports:
import 'package:fast_cached_network_image/fast_cached_network_image.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

// Project imports:
import 'package:app/extensions/string_extensions.dart';

class PositiveLinkImage extends ConsumerWidget {
  const PositiveLinkImage({
    required this.url,
    this.height,
    this.width,
    super.key,
  });

  final String url;
  final double? height;
  final double? width;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    if (url.isSvgUrl) {
      return SvgPicture.network(
        url,
        height: height,
        width: width,
      );
    }

    return FastCachedImage(
      url: url,
      height: height,
      width: width,
    );
  }
}
