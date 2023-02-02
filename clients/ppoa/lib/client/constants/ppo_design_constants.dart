// See <https://www.w3.org/TR/WCAG20/#contrast-ratiodef>
// The spec says to use kThreshold=0.0525, but Material Design appears to bias
// more towards using light text than WCAG20 recommends. Material Design spec
// doesn't say what value to use, but 0.15 seemed close to what the Material
// Design spec shows for its color palette on
// <https://material.io/go/design-theming#color-color-palette>.
const double kBrightnessUpperThreshold = 0.15;
const double kBrightnessLowerThreshold = 0.015;

const String kFontAlbertSans = 'AlbertSans';

//* Animations
const Duration kAnimationDurationRegular = Duration(milliseconds: 250);

//* Paddings and Spaces
const double kPaddingNone = 0.0;
const double kPaddingExtraSmall = 5.0;
const double kPaddingSmall = 10.0;
const double kPaddingMedium = 20.0;
const double kPaddingLarge = 30.0;
const double kPaddingExtraLarge = 40.0;
const double kPaddingMassive = 50.0;
const double kPaddingSection = 60.0;
const double kPaddingSectionLarge = 80.0;
const double kPaddingSectionExtraLarge = 90.0;
const double kPaddingSplashTextBreak = 200.0;

//* Opacities
const double kOpacityNone = 0.0;
const double kOpacityFull = 1.0;

//* Sizes
const double kLogoMaximumWidth = 126.0;
const double kBadgeSmallSize = 116.0;
