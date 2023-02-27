// Flutter imports:
import 'package:flutter/material.dart';

// Package imports:
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:unicons/unicons.dart';

// Project imports:
import 'package:app/constants/design_constants.dart';
import 'package:app/dtos/system/design_colors_model.dart';
import 'package:app/dtos/system/design_typography_model.dart';
import '../../../providers/system/design_controller.dart';

class PositiveSearchField extends ConsumerStatefulWidget {
  const PositiveSearchField({super.key});

  static final BorderRadius kFieldBorderRadius = BorderRadius.circular(30);
  static const EdgeInsets kFieldPadding = EdgeInsets.all(kPaddingSmall);

  static const double kIconRadius = 24.0;
  static const double kOutlineOpacity = 0.2;
  static const double kOutlineWidth = 1.0;

  @override
  PositiveSearchFieldState createState() => PositiveSearchFieldState();
}

class PositiveSearchFieldState extends ConsumerState<PositiveSearchField> {
  final TextEditingController _controller = TextEditingController();
  final FocusNode _focusNode = FocusNode();

  @override
  void initState() {
    super.initState();
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

  @override
  Widget build(BuildContext context) {
    final DesignColorsModel colors = ref.watch(designControllerProvider.select((value) => value.colors));
    final DesignTypographyModel typography = ref.watch(designControllerProvider.select((value) => value.typography));

    final OutlineInputBorder border = OutlineInputBorder(
      borderRadius: PositiveSearchField.kFieldBorderRadius,
      borderSide: BorderSide(
        width: PositiveSearchField.kOutlineWidth,
        color: colors.black.withOpacity(PositiveSearchField.kOutlineOpacity),
      ),
    );

    // TODO(any): localize this
    return TextFormField(
      controller: _controller,
      focusNode: _focusNode,
      textInputAction: TextInputAction.search,
      style: typography.styleButtonRegular.copyWith(color: colors.colorGray7),
      decoration: InputDecoration(
        hintText: 'Search',
        hintStyle: typography.styleButtonRegular.copyWith(color: colors.black),
        prefixIcon: Icon(
          UniconsLine.search,
          size: PositiveSearchField.kIconRadius,
          color: colors.black,
        ),
        contentPadding: PositiveSearchField.kFieldPadding,
        errorBorder: border,
        focusedBorder: border,
        disabledBorder: border,
        enabledBorder: border,
        border: border,
      ),
    );
  }
}
