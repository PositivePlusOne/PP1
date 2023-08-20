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
    required this.child,
    this.backgroundOpacity = kBackgroundOpacity,
    this.isDisabled = false,
    this.heroTag = '',
    this.barrierOpacity = kBarrierOpacity,
    super.key,
  });

  final String title;
  final Widget child;

  final bool isDisabled;
  final String heroTag;

  final double barrierOpacity;
  final double backgroundOpacity;

  static const double kBorderRadius = 40.0;
  static const double kPadding = 20.0;
  static const double kMargin = 10.0;
  static const double kBackgroundOpacity = 0.15;
  static const double kBarrierOpacity = 0.85;
  static const double kCalandarOpacity = 0.95;
  static const double kSigmaBlur = 2.0;

  static PositiveDialog buildDialog({
    required String title,
    required Widget child,
  }) {
    return PositiveDialog(title: title, child: child);
  }

  static Future<T> show<T>({
    required BuildContext context,
    required Widget child,
    String title = '',
    bool barrierDismissible = true,
    bool useSafeArea = false,
    double barrierOpacity = kBarrierOpacity,
    double backgroundOpacity = kBackgroundOpacity,
  }) async {
    final DesignColorsModel colors = providerContainer.read(designControllerProvider.select((value) => value.colors));

    return await showCupertinoDialog(
      context: context,
      barrierDismissible: barrierDismissible,
      useRootNavigator: true,
      builder: (_) => PositiveDialog(
        title: title,
        backgroundOpacity: backgroundOpacity,
        child: child,
      ),
    );
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final DesignColorsModel colors = ref.read(designControllerProvider.select((value) => value.colors));
    final DesignTypographyModel typography = ref.read(designControllerProvider.select((value) => value.typography));

    final MediaQueryData mediaQuery = MediaQuery.of(context);
    final double bottomViewInsets = mediaQuery.viewInsets.bottom;

    final Widget child2 = Material(
      type: MaterialType.transparency,
      // ScaffoldMessenger, Builder, and Scaffold are required for the snackbar to show on top of the modal (as opposed to behind it)
      child: ScaffoldMessenger(
        child: Builder(builder: (context) {
          return GestureDetector(
            // Pop the page on background tap
            onTap: () => Navigator.of(context).pop(),
            child: Scaffold(
              backgroundColor: colors.black.withOpacity(barrierOpacity),
              body: CustomScrollView(
                slivers: <Widget>[
                  SliverPadding(
                    padding: EdgeInsets.only(bottom: bottomViewInsets),
                    sliver: SliverFillRemaining(
                      child: Padding(
                        padding: const EdgeInsets.all(kMargin),
                        child: Center(
                          child: SingleChildScrollView(
                            child: ClipRRect(
                              borderRadius: BorderRadius.circular(kBorderRadius),
                              child: BackdropFilter(
                                filter: ImageFilter.blur(sigmaX: kSigmaBlur, sigmaY: kSigmaBlur),
                                child: Container(
                                  width: double.infinity,
                                  padding: const EdgeInsets.all(kPadding),
                                  decoration: BoxDecoration(
                                    color: colors.colorGray3.withOpacity(backgroundOpacity),
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
                                      child,
                                    ],
                                  ),
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
            ),
          );
        }),
      ),
    );

    if (heroTag.isNotEmpty) {
      return Hero(
        tag: heroTag,
        child: child2,
      );
    }

    return child2;
  }
}
