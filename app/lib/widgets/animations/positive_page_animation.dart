// Dart imports:
import 'dart:math' as math;

// Flutter imports:
import 'package:flutter/widgets.dart';

// Project imports:
import 'package:app/constants/design_constants.dart';

/// A [PageRoute] which transitions by expanding a circular clip from
/// the center of [expandFrom] until the page is fully revealed.
class CircularClipContextRoute<T> extends PageRoute<T> {
  CircularClipContextRoute({
    required this.expandFrom,
    required this.builder,
    this.curve = Curves.easeInOutCubic,
    this.reverseCurve = Curves.easeInOutCubic,
    this.opacity,
    this.border = CircularClipTransition.kDefaultBorder,
    this.shadow = CircularClipTransition.kDefaultShadow,
    this.maintainState = false,
    this.transitionDuration = kAnimationDurationRegular,
  });

  /// The [BuildContext] of the widget, which is used to determine the center
  /// of the expanding clip circle and its initial dimensions.
  ///
  /// The [RenderObject] which eventually renders the widget, must be a
  /// [RenderBox].
  ///
  /// See also:
  ///
  /// * [CircularClipTransition.expandingRect], which is what [expandFrom] is
  /// used to calculate.
  final BuildContext expandFrom;

  /// Builds the primary contents of the route.
  final WidgetBuilder builder;

  /// The curve used when this route is pushed.
  final Curve curve;

  /// The curve used when this route is popped.
  final Curve reverseCurve;

  /// {@macro CircularClipTransition.opacity}
  final Animatable<double>? opacity;

  /// {@macro CircularClipTransition.border}
  final BoxBorder? border;

  /// {@macro CircularClipTransition.shadow}
  final List<BoxShadow>? shadow;

  @override
  final bool maintainState;

  @override
  final Duration transitionDuration;

  // The expandFrom context is used when popping this route, to update the
  // _expandingRect. This is necessary to handle changes to the layout of
  // the routes below this one (e.g. window is resized), therefore they must be
  // kept around.
  @override
  bool get opaque => false;

  @override
  Color? get barrierColor => null;

  @override
  String? get barrierLabel => null;

  late Rect _expandingRect;

  void _updateExpandingRect() {
    setState(() {
      assert(expandFrom.findRenderObject() is RenderBox);
      final expandFromRenderBox = expandFrom.findRenderObject() as RenderBox;
      final expandFromTransform = expandFromRenderBox.getTransformTo(null);
      final navigatorTransform = navigator!.context.findRenderObject()!.getTransformTo(null);
      final transform = expandFromTransform..multiply(Matrix4.tryInvert(navigatorTransform)!);
      _expandingRect = MatrixUtils.transformRect(
        transform,
        Offset.zero & expandFromRenderBox.size,
      );
    });
  }

  @override
  TickerFuture didPush() {
    _updateExpandingRect();
    return super.didPush();
  }

  @override
  bool didPop(T? result) {
    _updateExpandingRect();
    return super.didPop(result);
  }

  @override
  Animation<double> createAnimation() {
    return CurvedAnimation(
      parent: super.createAnimation(),
      curve: curve,
      reverseCurve: reverseCurve,
    );
  }

  @override
  Widget buildPage(
    BuildContext context,
    Animation<double> animation,
    Animation<double> secondaryAnimation,
  ) =>
      builder(context);

  @override
  Widget buildTransitions(
    BuildContext context,
    Animation<double> animation,
    Animation<double> secondaryAnimation,
    Widget child,
  ) {
    return CircularClipTransition(
      animation: animation,
      expandingRect: _expandingRect,
      opacity: opacity,
      border: border,
      shadow: shadow,
      child: child,
    );
  }
}

/// A [PageRoute] which transitions by expanding a circular clip from
/// the center of [expandFrom] until the page is fully revealed.
class CircularClipRoute<T> extends PageRoute<T> {
  CircularClipRoute({
    required this.expandFromOffset,
    required this.builder,
    this.curve = Curves.easeInOutCubic,
    this.reverseCurve = Curves.easeInOutCubic,
    this.opacity,
    this.border = CircularClipTransition.kDefaultBorder,
    this.shadow = CircularClipTransition.kDefaultShadow,
    this.maintainState = false,
    this.transitionDuration = kAnimationDurationRegular,
  });

  static Widget clipRoute(BuildContext context, Animation<double> animation, Animation<double> secondaryAnimation, Widget child) {
    final MediaQueryData mediaQuery = MediaQuery.of(context);
    return CircularClipTransition(
      animation: animation,
      expandingRect: Rect.fromCenter(center: mediaQuery.size.center(Offset(-mediaQuery.size.width * 2 / 5, mediaQuery.size.height / 4)), width: 1, height: 1),
      opacity: CircularClipTransition.kDefaultOpacityAnimatable,
      border: CircularClipTransition.kDefaultBorder,
      shadow: CircularClipTransition.kDefaultShadow,
      child: child,
    );
  }

  /// A fraction which describes the center of the clip circle at
  /// [animation.value] `0`.
  final FractionalOffset expandFromOffset;

  /// Builds the primary contents of the route.
  final WidgetBuilder builder;

  /// The curve used when this route is pushed.
  final Curve curve;

  /// The curve used when this route is popped.
  final Curve reverseCurve;

  /// {@macro CircularClipTransition.opacity}
  final Animatable<double>? opacity;

  /// {@macro CircularClipTransition.border}
  final BoxBorder? border;

  /// {@macro CircularClipTransition.shadow}
  final List<BoxShadow>? shadow;

  @override
  final bool maintainState;

  @override
  final Duration transitionDuration;

  // The expandFrom context is used when popping this route, to update the
  // _expandingRect. This is necessary to handle changes to the layout of
  // the routes below this one (e.g. window is resized), therefore they must be
  // kept around.
  @override
  bool get opaque => false;

  @override
  Color? get barrierColor => null;

  @override
  String? get barrierLabel => null;

  late Rect _expandingRect;

  void _updateExpandingRect() {
    setState(() {
      final navigatorRenderBox = navigator!.context.findRenderObject() as RenderBox;
      final screenSize = navigatorRenderBox.size;
      _expandingRect = Rect.fromLTWH(
        screenSize.width * expandFromOffset.dx,
        screenSize.height * expandFromOffset.dy,
        1,
        1,
      );
    });
  }

  @override
  TickerFuture didPush() {
    _updateExpandingRect();
    return super.didPush();
  }

  @override
  bool didPop(T? result) {
    _updateExpandingRect();
    return super.didPop(result);
  }

  @override
  Animation<double> createAnimation() {
    return CurvedAnimation(
      parent: super.createAnimation(),
      curve: curve,
      reverseCurve: reverseCurve,
    );
  }

  @override
  Widget buildPage(
    BuildContext context,
    Animation<double> animation,
    Animation<double> secondaryAnimation,
  ) =>
      builder(context);

  @override
  Widget buildTransitions(
    BuildContext context,
    Animation<double> animation,
    Animation<double> secondaryAnimation,
    Widget child,
  ) {
    return CircularClipTransition(
      animation: animation,
      expandingRect: _expandingRect,
      opacity: opacity,
      border: border,
      shadow: shadow,
      child: child,
    );
  }
}

/// A widget which reveals its [child] by expanding a circular clip from
/// the center of [expandingRect] until the child is fully revealed.
///
/// [expandingRect] is a rectangle in the coordinate space of this widget, which
/// contains the clip circle when [animation.value] is `0`.
///
/// When [animation.value] is `1`, the clip circle contains both
/// [expandingRect] and the rectangle which is the bounding box of [child].
///
/// See also:
///
/// * [CircularClipRoute], which uses this widget.
class CircularClipTransition extends StatefulWidget {
  /// The default value for [opacity].
  static final kDefaultOpacityAnimatable = TweenSequence([
    TweenSequenceItem(
      tween: Tween(
        begin: .0,
        end: 1.0,
      ),
      weight: 10,
    ),
    TweenSequenceItem(
      weight: 90,
      tween: ConstantTween(1.0),
    ),
  ]);

  /// The default value for [border].
  static const kDefaultBorder = Border.fromBorderSide(BorderSide.none);

  /// The default value for [shadow].
  static const kDefaultShadow = <BoxShadow>[];

  /// Creates  widget which reveals its [child] by expanding a circular clip
  /// from the center of [expandingRect] until the child is fully revealed.
  CircularClipTransition({
    super.key,
    required this.animation,
    required this.expandingRect,
    required this.child,
    Animatable<double>? opacity,
    this.border = kDefaultBorder,
    this.shadow = kDefaultShadow,
  })  : opacity = opacity ?? kDefaultOpacityAnimatable;

  /// The animation which controls the progress (0 to 1) of the transition.
  final Animation<double> animation;

  /// The rectangle which describes the center and dimension of the clip
  /// circle at [animation.value] `0`.
  ///
  /// The expanding clip circle will always be centered at this rectangle's
  /// center.
  final Rect expandingRect;

  /// {@template CircularClipTransition.opacity}
  /// The [Animatable] which is used to fade the transition in and out.
  ///
  /// When this option is not provided or is `null` it defaults to
  /// [kDefaultOpacityAnimatable]. To use a fixed opacity pass something like
  /// `ConstantTween(1.0)`.
  /// {@endtemplate}
  final Animatable<double> opacity;

  /// {@template CircularClipTransition.border}
  /// The border which is drawn around the clip circle. The default is
  /// [kDefaultBorder]. To disable the border, set [border] to `null`.
  /// {@endtemplate}
  final BoxBorder? border;

  /// {@template CircularClipTransition.shadow}
  /// The shadow which is drawn beneath the clip circle. The default is
  /// [kDefaultShadow]. To disable the shadow, set [shadow] to `null`.
  /// {@endtemplate}
  final List<BoxShadow>? shadow;

  /// The widget which is clipped by the clip circle.
  final Widget child;

  @override
  CircularClipTransitionState createState() => CircularClipTransitionState();
}

class CircularClipTransitionState extends State<CircularClipTransition> {
  /// The widget returned from [build] is cached to prevent unnecessary
  /// rebuilds of the tree managed by the transition. The child is only
  /// rebuild when the configuration in [widget] actually changes (see
  /// [didUpdateWidget]).
  Widget? _child;

  @override
  void didUpdateWidget(CircularClipTransition oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.animation != oldWidget.animation || widget.expandingRect != oldWidget.expandingRect || widget.opacity != oldWidget.opacity || widget.border != oldWidget.border || widget.shadow != oldWidget.shadow || widget.child != oldWidget.child) {
      _child = null;
    }
  }

  @override
  Widget build(BuildContext context) => _child ??= _buildChild();

  Widget _buildChild() {
    return LayoutBuilder(
      builder: (context, constraints) {
        final clipRectAnimation = _NonNullAnimatable(RectTween(
          begin: widget.expandingRect,
          end: _getExpandedClipRect(Rect.fromPoints(
            Offset.zero,
            Offset(constraints.maxWidth, constraints.maxHeight),
          )),
        )).animate(widget.animation);

        final stackChildren = <Widget>[];

        if (widget.shadow != null) {
          stackChildren.add(_buildDecoration(
            clipRectAnimation,
            BoxDecoration(
              shape: BoxShape.circle,
              boxShadow: widget.shadow,
            ),
          ));
        }

        stackChildren.add(_buildChildClipper(clipRectAnimation));

        if (widget.border != null) {
          stackChildren.add(_buildDecoration(
            clipRectAnimation,
            BoxDecoration(
              shape: BoxShape.circle,
              border: widget.border,
            ),
            ignorePointer: true,
          ));
        }

        Widget child = Stack(children: stackChildren);

        return FadeTransition(
          opacity: widget.opacity.animate(widget.animation),
          child: child,
        );
      },
    );
  }

  Rect _getExpandedClipRect(Rect contentRect) {
    final circleRadius = [
      contentRect.topLeft,
      contentRect.topRight,
      contentRect.bottomLeft,
      contentRect.bottomRight,
    ].map((corner) => (corner - widget.expandingRect.center).distance).reduce(math.max);

    var rectSize = Size.square(circleRadius * 2);

    final border = widget.border;
    if (border != null) {
      rectSize = border.dimensions.inflateSize(rectSize);
    }

    return Rect.fromCenter(
      center: widget.expandingRect.center,
      height: rectSize.height,
      width: rectSize.width,
    );
  }

  ClipOval _buildChildClipper(Animation<Rect> clipRectAnimation) {
    return ClipOval(
      clipper: _RectAnimationClipper(animation: clipRectAnimation),
      child: widget.child,
    );
  }

  Widget _buildDecoration(
    Animation<Rect> clipRectAnimation,
    Decoration decoration, {
    bool ignorePointer = false,
  }) {
    Widget child = DecoratedBox(decoration: decoration);
    child = ignorePointer ? IgnorePointer(child: child) : child;
    return _AbsolutePositionedTransition(
      rect: clipRectAnimation,
      child: child,
    );
  }
}

/// Animates the position of a [child] in a [Stack] with  absolutely
/// positioned through a [rect].
class _AbsolutePositionedTransition extends AnimatedWidget {
  const _AbsolutePositionedTransition({
    required Animation<Rect> rect,
    required this.child,
  }) : super(listenable: rect);

  Animation<Rect> get rect => listenable as Animation<Rect>;

  final Widget child;

  @override
  Widget build(BuildContext context) {
    return Positioned.fromRect(
      rect: rect.value,
      child: child,
    );
  }
}

/// A simple [CustomClipper] which adapts an [Animation<Rect>] to animate the
/// clip rect.
class _RectAnimationClipper extends CustomClipper<Rect> {
  _RectAnimationClipper({
    required this.animation,
  }) : super(reclip: animation);

  final Animation<Rect> animation;

  @override
  Rect getClip(Size size) => animation.value;

  @override
  bool shouldReclip(_RectAnimationClipper oldClipper) => animation != oldClipper.animation;
}

class _NonNullAnimatable<T> extends Animatable<T> {
  _NonNullAnimatable(this.wrappedAnimatable);

  final Animatable<T?> wrappedAnimatable;

  @override
  T transform(double t) => wrappedAnimatable.transform(t)!;
}
