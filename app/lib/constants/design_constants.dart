// See <https://www.w3.org/TR/WCAG20/#contrast-ratiodef>
// The spec says to use kThreshold=0.0525, but Material Design appears to bias
// more towards using light text than WCAG20 recommends. Material Design spec
// doesn't say what value to use, but 0.15 seemed close to what the Material
// Design spec shows for its color palette on
// <https://material.io/go/design-theming#color-color-palette>.

// Flutter imports:
import 'package:flutter/material.dart';

const double kBrightnessUpperThreshold = 0.15;
const double kBrightnessLowerThreshold = 0.015;

// Animations
const Duration kAnimationDurationInstant = Duration(milliseconds: 0);
const Duration kAnimationDurationFast = Duration(milliseconds: 150);
const Duration kAnimationDurationRegular = Duration(milliseconds: 250);
const Duration kAnimationDurationExtended = Duration(milliseconds: 450);
const Duration kAnimationDurationDebounce = Duration(milliseconds: 500);
const Duration kAnimationDurationEntry = Duration(milliseconds: 1000);
const Duration kAnimationDurationSlow = Duration(milliseconds: 1500);

const Curve kAnimationCurveDefault = Curves.easeInOut;

// Paddings and margins
const double kPaddingNone = 0.0;
const double kPaddingThin = 1.0;
const double kPaddingExtraSmall = 5.0;
const double kPaddingVerySmall = 7.0;
const double kPaddingSmall = 10.0;
const double kPaddingSmallMedium = 15.0;
const double kPaddingMedium = 20.0;
const double kPaddingLarge = 30.0;
const double kPaddingExtraLarge = 40.0;
const double kPaddingMassive = 50.0;
const double kPaddingAppBarBreak = 70.0;
const double kPaddingInformationBreak = 100.0;
const double kPaddingSplashTextBreak = 200.0;

// Radia
const double kBorderRadiusNone = 0.0;
const double kBorderRadiusSmall = 5.0;
const double kBorderRadiusMedium = 10.0;
const double kBorderRadiusLarge = 20.0;
const double kBorderRadiusLargePlus = 25.0;
const double kBorderRadiusMassive = 40.0;
const double kBorderRadiusHuge = 50.0;

// Border thickness
const double kBorderThicknessSmall = 1.0;
const double kBorderThicknessMedium = 2.0;

// Opacities
const double kOpacityNone = 0.0;
const double kOpacityQuarter = 0.25;
const double kOpacityHalf = 0.5;
const double kOpacityFull = 1.0;

// Sizes
const double kLogoMaximumWidth = 126.0;
const double kBadgeSmallSize = 116.0;
const double kTextFieldSizeLarge = 150.0;

// Icon
const double kIconExtraSmall = 16.0;
const double kIconSmall = 20.0;
const double kIconMedium = 24.0;
const double kIconLarge = 40.0;
const double kIconHuge = 50.0;
const double kIconMassive = 60.0;
const double kIconHeader = 70.0;

// Dialogs
const Size kDefaultDatePickerDialogSize = Size(325, 400);

// Maps
const double kDefaultZoomLevel = 12;
const double kDefaultCircleRadius = 3500;
const double kDefaultSearchLocationNearbyRadius = 250;

// Other
const double kCameraButtonSize = 70.0;
const double kCarouselMaxHeight = 400.0;
const double kSizeRecommendedTopic = 100.0;
const double kCreatePostHeight = 50.0;
const double kCreatePostNavigationHeight = 60;
const String kObscuringTextCharacter = '*';

// Text and Formatting
const int kMaxLengthTruncatedPost = 75;
const int kMaxLengthCaption = 320;
const int kMaxLengthAltText = 120;
