// Dart imports:
import 'dart:async';

// Flutter imports:
import 'package:flutter/material.dart';

// Package imports:
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:unicons/unicons.dart';

// Project imports:
import 'package:app/constants/design_constants.dart';
import 'package:app/dtos/system/design_colors_model.dart';
import 'package:app/dtos/system/design_typography_model.dart';
import 'package:app/widgets/behaviours/positive_tap_behaviour.dart';
import '../../../providers/system/design_controller.dart';

class PositiveSearchField extends ConsumerStatefulWidget {
  const PositiveSearchField({
    this.onSubmitted,
    this.initialText = '',
    this.hintText,
    this.onCancel,
    this.onChange,
    this.controller,
    this.focusNode,
    this.isEnabled = true,
    super.key,
  });

  final FutureOr<void> Function(String)? onSubmitted;
  final FutureOr<void> Function(String)? onChange;
  final String initialText;
  final String? hintText;
  final void Function()? onCancel;

  final TextEditingController? controller;

  final bool isEnabled;

  final FocusNode? focusNode;

  static final BorderRadius kFieldBorderRadius = BorderRadius.circular(30);
  static const EdgeInsets kFieldPadding = EdgeInsets.all(kPaddingSmall);

  static const double kIconRadius = 24.0;
  static const double kOutlineOpacity = 0.2;
  static const double kOutlineWidth = 1.0;

  @override
  PositiveSearchFieldState createState() => PositiveSearchFieldState();
}

class PositiveSearchFieldState extends ConsumerState<PositiveSearchField> {
  late final FocusNode _focusNode;
  late final TextEditingController _controller;

  @override
  void initState() {
    super.initState();

    _controller = widget.controller ?? TextEditingController(text: widget.initialText);
    _focusNode = widget.focusNode ?? FocusNode();

    setupListeners();
  }

  @override
  void dispose() {
    teardownListeners();
    super.dispose();
  }

  void setupListeners() {
    _focusNode.addListener(onFocusChanged);
  }

  void teardownListeners() {
    _focusNode.removeListener(onFocusChanged);
  }

  void onFocusChanged() {}

  void onResetRequested() {
    if (!mounted) {
      return;
    }

    widget.onCancel?.call();
    widget.onChange?.call('');
    _controller.clear();
    setState(() {});
  }

  void onFieldChanged(String value) {
    if (!mounted) {
      return;
    }
    widget.onChange?.call(value);

    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    final AppLocalizations localizations = AppLocalizations.of(context)!;
    final DesignColorsModel colors = ref.watch(designControllerProvider.select((value) => value.colors));
    final DesignTypographyModel typography = ref.watch(designControllerProvider.select((value) => value.typography));

    final OutlineInputBorder border = OutlineInputBorder(
      borderRadius: PositiveSearchField.kFieldBorderRadius,
      borderSide: BorderSide(
        width: PositiveSearchField.kOutlineWidth,
        color: colors.black.withOpacity(PositiveSearchField.kOutlineOpacity),
      ),
    );

    Widget? suffixIcon;
    if (_controller.text.isNotEmpty) {
      suffixIcon = PositiveTapBehaviour(
        onTap: onResetRequested,
        child: IntrinsicWidth(
          child: Container(
            alignment: Alignment.centerRight,
            padding: const EdgeInsets.only(right: kPaddingMedium),
            child: Text(
              localizations.shared_actions_cancel,
              style: typography.styleFieldAction.copyWith(color: colors.colorGray5),
            ),
          ),
        ),
      );
    }

    return AnimatedOpacity(
      opacity: widget.isEnabled ? kOpacityFull : kOpacityHalf,
      duration: kAnimationDurationRegular,
      child: TextFormField(
        controller: _controller,
        focusNode: _focusNode,
        textInputAction: TextInputAction.search,
        style: typography.styleButtonRegular.copyWith(color: colors.colorGray7),
        onChanged: onFieldChanged,
        onFieldSubmitted: widget.onSubmitted,
        enabled: widget.isEnabled,
        decoration: InputDecoration(
          hintText: widget.hintText ?? localizations.shared_search_hint,
          hintStyle: typography.styleButtonRegular.copyWith(color: colors.black),
          prefixIcon: Icon(
            UniconsLine.search,
            size: PositiveSearchField.kIconRadius,
            color: colors.black,
          ),
          suffixIcon: suffixIcon,
          contentPadding: PositiveSearchField.kFieldPadding,
          errorBorder: border,
          focusedBorder: border,
          disabledBorder: border,
          enabledBorder: border,
          border: border,
        ),
      ),
    );
  }
}
