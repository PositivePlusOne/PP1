// Flutter imports:
import 'package:app/widgets/atoms/input/positive_text_field.dart';
import 'package:flutter/material.dart';

// Package imports:
import 'package:hooks_riverpod/hooks_riverpod.dart';

import '../../../constants/design_constants.dart';
import '../../../dtos/system/design_colors_model.dart';
import '../../../providers/system/design_controller.dart';
import '../../molecules/layouts/positive_basic_sliver_list.dart';

// Project imports:

class CreatePostDialog extends ConsumerWidget {
  const CreatePostDialog({
    super.key,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final DesignColorsModel colours = ref.read(designControllerProvider.select((value) => value.colors));
    final MediaQueryData mediaQueryData = MediaQuery.of(context);

    GlobalKey test = GlobalKey();
    List<GlobalKey> keyList = [test];
    final double marginHeight = mediaQueryData.padding.top;

    return Material(
      child: Container(
        color: Colors.amber,
        child: Stack(
          children: [
            SingleChildScrollView(
              child: Column(
                children: [
                  SizedBox(height: marginHeight),
                  Container(
                    key: test,
                    width: double.infinity,
                    constraints: BoxConstraints(minHeight: kTextFieldSizeLarge),
                    margin: EdgeInsets.symmetric(horizontal: kPaddingMedium),
                    decoration: BoxDecoration(
                      color: Colors.blue.withAlpha(125),
                      borderRadius: BorderRadius.circular(kBorderRadiusLargePlus),
                    ),
                    child: PositiveTextField(
                      // fillColor: colours.transparent,
                      minLines: 6,
                      maxLines: 15,
                    ),
                  ),
                ],
              ),
            ),
            ClipPath(
              clipper: CustomClipperImage(keyList, marginHeight),
              child: Container(
                color: Colors.red.withAlpha(100),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class CustomClipperImage extends CustomClipper<Path> {
  const CustomClipperImage(this.keyList, this.marginHeight);

  final List<GlobalKey> keyList;
  final double marginHeight;

  @override
  getClip(Size size) {
    var path = Path();

    for (GlobalKey key in keyList) {
      if (key.currentContext == null || key.currentContext!.size == null) {
        return path;
      }
    }

    path.addRect(Rect.largest);

    double verticalOffset = marginHeight;
    for (GlobalKey key in keyList) {
      final double height = key.currentContext!.size!.height;
      Path path2 = Path()
        ..addRRect(
          RRect.fromRectAndRadius(
            Rect.fromPoints(
              Offset(
                kPaddingMedium,
                verticalOffset,
              ),
              Offset(
                size.width - kPaddingMedium,
                verticalOffset + height,
              ),
            ),
            const Radius.circular(kBorderRadiusLargePlus),
          ),
        );
      verticalOffset += height + kPaddingSmall;
      path = Path.combine(PathOperation.difference, path, path2);
    }

    return path;
  }

  @override
  bool shouldReclip(CustomClipper oldClipper) {
    return true;
  }
}

        // child: PositiveBasicSliverList(
        //   includeAppBar: false,
        //   children: [],
        // ),