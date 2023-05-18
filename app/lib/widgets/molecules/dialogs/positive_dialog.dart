// Dart imports:
import 'dart:ui';

// Flutter imports:
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

// Package imports:
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:unicons/unicons.dart';

// Project imports:
import 'package:app/constants/design_constants.dart';
import 'package:app/dtos/system/design_colors_model.dart';
import 'package:app/main.dart';
import 'package:app/widgets/atoms/buttons/enumerations/positive_button_size.dart';
import 'package:app/widgets/atoms/buttons/enumerations/positive_button_style.dart';
import 'package:app/widgets/atoms/buttons/positive_button.dart';
import '../../../dtos/system/design_typography_model.dart';
import '../../../providers/system/design_controller.dart';

class PositiveDialog extends ConsumerWidget {
  const PositiveDialog({
    required this.title,
    this.children = const <Widget>[],
    this.isDisabled = false,
    this.heroTag = '',
    super.key,
  });

  final String title;
  final List<Widget> children;

  final bool isDisabled;
  final String heroTag;

  static const double kBorderRadius = 40.0;
  static const double kPadding = 20.0;
  static const double kMargin = 10.0;
  static const double kBackgroundOpacity = 0.15;
  static const double kBarrierOpacity = 0.85;
  static const double kSigmaBlur = 2.0;

  static PositiveDialog buildDialog({
    required String title,
    required List<Widget> children,
  }) {
    return PositiveDialog(title: title, children: children);
  }

  static Future<T> show<T>({
    required BuildContext context,
    required Widget dialog,
    bool barrierDismissible = true,
    bool useSafeArea = true,
  }) async {
    final DesignColorsModel colors = providerContainer.read(designControllerProvider.select((value) => value.colors));

    return await showCupertinoDialog(
      context: context,
      barrierDismissible: barrierDismissible,
      useRootNavigator: true,
      builder: (_) => Material(
        color: colors.black.withOpacity(kBarrierOpacity),
        child: dialog,
      ),
    );
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final DesignColorsModel colors = ref.read(designControllerProvider.select((value) => value.colors));
    final DesignTypographyModel typography = ref.read(designControllerProvider.select((value) => value.typography));

    final MediaQueryData mediaQuery = MediaQuery.of(context);
    final double bottomViewInsets = mediaQuery.viewInsets.bottom;

    final Widget child = Material(
      type: MaterialType.transparency,
      child: CustomScrollView(
        slivers: <Widget>[
          SliverPadding(
            padding: EdgeInsets.only(bottom: bottomViewInsets),
            sliver: SliverFillRemaining(
              child: Center(
                child: SingleChildScrollView(
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(kBorderRadius),
                    child: BackdropFilter(
                      filter: ImageFilter.blur(sigmaX: kSigmaBlur, sigmaY: kSigmaBlur),
                      child: Container(
                        width: double.infinity,
                        margin: const EdgeInsets.all(kMargin),
                        padding: const EdgeInsets.all(kPadding),
                        decoration: BoxDecoration(
                          color: colors.colorGray1.withOpacity(kBackgroundOpacity),
                          borderRadius: BorderRadius.circular(kBorderRadius),
                        ),
                        child: Column(
                          children: <Widget>[
                            Row(
                              children: <Widget>[
                                Expanded(
                                  child: Text(
                                    title,
                                    style: typography.styleTitle.copyWith(color: colors.white),
                                  ),
                                ),
                                const SizedBox(width: kPaddingMedium),
                                PositiveButton.appBarIcon(
                                  colors: colors,
                                  icon: UniconsLine.multiply,
                                  primaryColor: title.isNotEmpty ? colors.white : colors.black,
                                  size: PositiveButtonSize.small,
                                  style: PositiveButtonStyle.text,
                                  isDisabled: isDisabled,
                                  onTapped: () => Navigator.of(context).pop(),
                                ),
                              ],
                            ),
                            const SizedBox(height: kPaddingMedium),
                            ...children,
                          ],
                        ),
                      ),
                    ),
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );

    if (heroTag.isNotEmpty) {
      return Hero(
        tag: heroTag,
        child: child,
      );
    }

    return child;
  }
}
