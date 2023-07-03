// Flutter imports:
import 'package:app/extensions/color_extensions.dart';
import 'package:app/widgets/atoms/input/positive_text_field.dart';
import 'package:flutter/material.dart';

// Package imports:
import 'package:hooks_riverpod/hooks_riverpod.dart';

import '../../../constants/design_constants.dart';
import '../../../dtos/system/design_colors_model.dart';
import '../../../dtos/system/design_typography_model.dart';
import '../../../providers/system/design_controller.dart';
import '../../molecules/layouts/positive_basic_sliver_list.dart';

// Project imports:

class CreatePostDialog extends ConsumerWidget {
  CreatePostDialog({
    super.key,
  });

  final GlobalKey captionKey = GlobalKey();
  final GlobalKey tagsKey = GlobalKey();
  final GlobalKey altTextKey = GlobalKey();

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final DesignColorsModel colours = ref.read(designControllerProvider.select((value) => value.colors));
    final DesignTypographyModel typography = ref.read(designControllerProvider.select((value) => value.typography));
    final TextStyle textStyle = typography.styleSubtitleBold.copyWith(color: colours.white);
    final MediaQueryData mediaQueryData = MediaQuery.of(context);

    final double marginHeight = mediaQueryData.padding.top;

    //? Keys for the first three widgets as their height is variable
    final List<GlobalKey> flexibleKeyList = [captionKey, tagsKey, altTextKey];

    //? height of the remaining widgets, as they are not variable
    final List<double> widgetHeightList = [];

    return Stack(
      children: [
        SingleChildScrollView(
          child: Column(
            children: [
              SizedBox(height: marginHeight),
              CreatePostTextField(boxKey: captionKey, colours: colours, textStyle: textStyle, maxLines: 15, minLines: 8),
              const SizedBox(height: kPaddingSmall),
              CreatePostTextField(boxKey: tagsKey, colours: colours, textStyle: textStyle, maxLines: 3, minLines: 1),
              const SizedBox(height: kPaddingSmall),
              CreatePostTextField(boxKey: altTextKey, colours: colours, textStyle: textStyle, maxLines: 3, minLines: 1),
              const SizedBox(height: kPaddingSmall),
            ],
          ),
        ),
        ClipPath(
          clipper: CustomClipperImage(
            marginHeight: marginHeight,
            flexibleKeyList: flexibleKeyList,
            widgetHeightList: widgetHeightList,
          ),
          child: Container(
            color: colours.black.withAlpha(230),
          ),
        ),
      ],
    );
  }
}

class CreatePostBox extends StatelessWidget {
  const CreatePostBox({
    super.key,
    required this.boxKey,
    required this.colours,
    required this.child,
    this.prefixWidget,
    this.suffixWidget,
  });

  final GlobalKey<State<StatefulWidget>> boxKey;
  final DesignColorsModel colours;
  final Widget child;
  final Widget? suffixWidget;
  final Widget? prefixWidget;

  @override
  Widget build(BuildContext context) {
    return Container(
      key: boxKey,
      width: double.infinity,
      margin: EdgeInsets.symmetric(horizontal: kPaddingMedium),
      decoration: BoxDecoration(
        color: colours.colorGray8.withAlpha(230),
        borderRadius: BorderRadius.circular(kBorderRadiusLargePlus),
      ),
      child: child,
    );
  }
}

class CreatePostTextField extends StatelessWidget {
  const CreatePostTextField({
    super.key,
    required this.boxKey,
    required this.colours,
    required this.minLines,
    required this.maxLines,
    required this.textStyle,
  });

  final GlobalKey<State<StatefulWidget>> boxKey;
  final DesignColorsModel colours;
  final int minLines;
  final int maxLines;
  final TextStyle textStyle;

  @override
  Widget build(BuildContext context) {
    return CreatePostBox(
      boxKey: boxKey,
      colours: colours,
      child: PositiveTextField(
        labelText: "what is thsi",
        // label: Text("TERsting"),
        onTextChanged: (_) {},
        textStyle: textStyle,
        fillColor: colours.transparent,
        tintColor: colours.white,
        borderRadius: kBorderRadiusLargePlus,
        isEnabled: true,
        minLines: minLines,
        maxLines: maxLines,
      ),
    );
  }
}

class CustomClipperImage extends CustomClipper<Path> {
  const CustomClipperImage({
    required this.widgetHeightList,
    required this.flexibleKeyList,
    required this.marginHeight,
  });

  //? Keys for the first three widgets as their height is variable
  final List<GlobalKey> flexibleKeyList;

  //? height of the remaining widgets, as they are not variable
  final List<double> widgetHeightList;

  //? total height of the padding from the top of the screen
  final double marginHeight;

  @override
  getClip(Size size) {
    var path = Path();

    path.addRect(Rect.largest);
    double verticalOffset = marginHeight;

    for (GlobalKey key in flexibleKeyList) {
      if (key.currentContext == null || key.currentContext!.size == null) {
        continue;
      }
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

    for (double height in widgetHeightList) {
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
