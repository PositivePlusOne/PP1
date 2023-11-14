// Dart imports:
import 'dart:ui';

// Flutter imports:
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

// Package imports:
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:unicons/unicons.dart';

// Project imports:
import 'package:app/constants/design_constants.dart';
import 'package:app/dtos/system/design_colors_model.dart';
import 'package:app/widgets/atoms/buttons/enumerations/positive_button_layout.dart';
import 'package:app/widgets/atoms/buttons/enumerations/positive_button_size.dart';
import 'package:app/widgets/atoms/buttons/enumerations/positive_button_style.dart';
import 'package:app/widgets/atoms/buttons/positive_button.dart';
import '../../../dtos/system/design_typography_model.dart';
import '../../../providers/system/design_controller.dart';

enum PositiveDialogStyle {
  overlay,
  fullScreen,
}

class PositiveDialog extends ConsumerWidget {
  const PositiveDialog({
    required this.title,
    required this.child,
    this.hints = const <Widget>[],
    this.style = PositiveDialogStyle.overlay,
    this.backgroundOpacity = kBackgroundOpacity,
    this.isDisabled = false,
    this.heroTag = '',
    this.barrierOpacity = kBarrierOpacityOverlay,
    this.barrierDismissible = true,
    this.showCloseButton = true,
    super.key,
  });

  final String title;
  final Widget child;

  final List<Widget> hints;

  final PositiveDialogStyle style;

  final bool isDisabled;
  final String heroTag;

  final double barrierOpacity;
  final double backgroundOpacity;

  final bool barrierDismissible;
  final bool showCloseButton;

  static const double kBorderRadius = 40.0;
  static const double kPadding = 20.0;
  static const double kMargin = 10.0;
  static const double kBackgroundOpacity = 0.15;
  static const double kBarrierOpacityOverlay = 0.85;
  static const double kBarrierOpacityFullScreen = 1.0;
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
    List<Widget> hints = const <Widget>[],
    bool barrierDismissible = true,
    bool useSafeArea = false,
    double backgroundOpacity = kBackgroundOpacity,
    PositiveDialogStyle style = PositiveDialogStyle.overlay,
    bool showCloseButton = true,
  }) async {
    return await showCupertinoDialog(
      context: context,
      barrierDismissible: barrierDismissible,
      useRootNavigator: true,
      builder: (_) => PositiveDialog(
        title: title,
        backgroundOpacity: backgroundOpacity,
        barrierOpacity: style == PositiveDialogStyle.overlay ? kBarrierOpacityOverlay : kBarrierOpacityFullScreen,
        style: style,
        hints: hints,
        barrierDismissible: barrierDismissible,
        showCloseButton: showCloseButton,
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
      child: ScaffoldMessenger(
        child: Builder(builder: (context) {
          return GestureDetector(
            onTap: () => barrierDismissible ? Navigator.of(context).pop() : null,
            child: AnnotatedRegion<SystemUiOverlayStyle>(
              value: buildSystemUiOverlayStyle(appBarColor: colors.black, backgroundColor: colors.black),
              child: WillPopScope(
                onWillPop: () async => barrierDismissible,
                child: Scaffold(
                  backgroundColor: colors.black.withOpacity(barrierOpacity),
                  body: CustomScrollView(
                    slivers: <Widget>[
                      SliverPadding(
                        padding: EdgeInsets.only(bottom: bottomViewInsets),
                        sliver: SliverFillRemaining(
                          child: style == PositiveDialogStyle.overlay
                              ? PositiveOverlayDialogContent(
                                  kBorderRadius: kBorderRadius,
                                  kSigmaBlur: kSigmaBlur,
                                  kPadding: kPadding,
                                  colors: colors,
                                  backgroundOpacity: backgroundOpacity,
                                  title: title,
                                  typography: typography,
                                  isDisabled: isDisabled,
                                  hints: hints,
                                  showCloseButton: showCloseButton,
                                  child: child,
                                )
                              : PositiveFullscreenDialogContent(
                                  kBorderRadius: kBorderRadius,
                                  kSigmaBlur: kSigmaBlur,
                                  kPadding: kPadding,
                                  colors: colors,
                                  backgroundOpacity: backgroundOpacity,
                                  title: title,
                                  typography: typography,
                                  isDisabled: isDisabled,
                                  hints: hints,
                                  child: child,
                                ),
                        ),
                      ),
                    ],
                  ),
                ),
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

class PositiveFullscreenDialogContent extends StatelessWidget {
  const PositiveFullscreenDialogContent({
    super.key,
    required this.kBorderRadius,
    required this.kSigmaBlur,
    required this.kPadding,
    required this.colors,
    required this.backgroundOpacity,
    required this.title,
    required this.typography,
    required this.isDisabled,
    required this.hints,
    required this.child,
  });

  final double kBorderRadius;
  final double kSigmaBlur;
  final double kPadding;
  final DesignColorsModel colors;
  final double backgroundOpacity;
  final String title;
  final DesignTypographyModel typography;
  final bool isDisabled;
  final List<Widget> hints;
  final Widget child;

  @override
  Widget build(BuildContext context) {
    return ListView(
      padding: EdgeInsets.only(
        top: MediaQuery.of(context).padding.top + kPadding,
        right: kPadding,
        left: kPadding,
        bottom: MediaQuery.of(context).viewInsets.bottom,
      ),
      children: <Widget>[
        Align(
          alignment: Alignment.centerLeft,
          child: PositiveButton(
            colors: colors,
            primaryColor: colors.white,
            onTapped: () => Navigator.of(context).pop(),
            style: PositiveButtonStyle.outline,
            icon: UniconsLine.multiply,
            size: PositiveButtonSize.medium,
            isActive: true,
            layout: PositiveButtonLayout.iconOnly,
            label: '',
          ),
        ),
        const SizedBox(height: kPaddingMassive),
        Text(
          title,
          style: typography.styleHeroMedium.copyWith(color: colors.white),
        ),
        const SizedBox(height: kPaddingMedium),
        if (hints.isNotEmpty) ...<Widget>[
          Wrap(
            alignment: WrapAlignment.start,
            runAlignment: WrapAlignment.start,
            spacing: kPaddingSmall,
            runSpacing: kPaddingSmall,
            children: hints,
          ),
          const SizedBox(height: kPaddingMedium),
        ],
        ClipRRect(
          borderRadius: BorderRadius.circular(kBorderRadius),
          child: BackdropFilter(
            filter: ImageFilter.blur(sigmaX: kSigmaBlur, sigmaY: kSigmaBlur),
            child: Container(
              width: double.infinity,
              padding: const EdgeInsets.all(PositiveDialog.kPadding),
              decoration: BoxDecoration(
                color: colors.colorGray3.withOpacity(backgroundOpacity),
                borderRadius: BorderRadius.circular(kBorderRadius),
              ),
              child: child,
            ),
          ),
        )
      ],
    );
  }
}

class PositiveOverlayDialogContent extends StatelessWidget {
  const PositiveOverlayDialogContent({
    super.key,
    required this.kBorderRadius,
    required this.kSigmaBlur,
    required this.kPadding,
    required this.colors,
    required this.backgroundOpacity,
    required this.title,
    required this.typography,
    required this.isDisabled,
    required this.hints,
    required this.child,
    required this.showCloseButton,
  });

  final double kBorderRadius;
  final double kSigmaBlur;
  final double kPadding;
  final DesignColorsModel colors;
  final double backgroundOpacity;
  final String title;
  final DesignTypographyModel typography;
  final bool isDisabled;
  final List<Widget> hints;
  final Widget child;

  final bool showCloseButton;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(PositiveDialog.kMargin),
      child: Center(
        child: SingleChildScrollView(
          child: ClipRRect(
            borderRadius: BorderRadius.circular(kBorderRadius),
            child: BackdropFilter(
              filter: ImageFilter.blur(sigmaX: kSigmaBlur, sigmaY: kSigmaBlur),
              child: GestureDetector(
                behavior: HitTestBehavior.opaque,
                onTap: () {},
                child: Container(
                  width: double.infinity,
                  padding: const EdgeInsets.all(PositiveDialog.kPadding),
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
                          if (showCloseButton) ...<Widget>[
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
                        ],
                      ),
                      if (title.isNotEmpty) const SizedBox(height: kPaddingMedium),
                      child,
                    ],
                  ),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
