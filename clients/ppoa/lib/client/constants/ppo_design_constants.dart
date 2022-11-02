// See <https://www.w3.org/TR/WCAG20/#contrast-ratiodef>
// The spec says to use kThreshold=0.0525, but Material Design appears to bias
// more towards using light text than WCAG20 recommends. Material Design spec
// doesn't say what value to use, but 0.15 seemed close to what the Material
// Design spec shows for its color palette on
// <https://material.io/go/design-theming#color-color-palette>.
const double ppoBrightnessThreshold = 0.15;

const String ppoFontFamilyAlbertSans = 'AlbertSans';

//* Animations
const Duration ppoAnimationDurationRegular = Duration(milliseconds: 250);
