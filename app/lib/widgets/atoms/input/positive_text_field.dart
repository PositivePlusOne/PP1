// Flutter imports:
import 'package:app/dtos/database/pagination/pagination.dart';
import 'package:app/dtos/database/profile/profile.dart';
import 'package:app/dtos/database/relationships/relationship.dart';
import 'package:app/extensions/string_extensions.dart';
import 'package:app/extensions/widget_extensions.dart';
import 'package:app/providers/profiles/profile_controller.dart';
import 'package:app/providers/system/cache_controller.dart';
import 'package:app/services/search_api_service.dart';
import 'package:app/services/third_party.dart';
import 'package:app/widgets/atoms/indicators/positive_loading_indicator.dart';
import 'package:app/widgets/molecules/containers/positive_glass_sheet.dart';
import 'package:app/widgets/molecules/tiles/positive_profile_list_tile.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

// Package imports:
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

// Project imports:
import 'package:app/dtos/system/design_colors_model.dart';
import 'package:app/dtos/system/design_typography_model.dart';
import 'package:app/helpers/formatter_helpers.dart';
import 'package:app/helpers/text_helpers.dart';
import 'package:app/providers/system/design_controller.dart';
import 'package:app/widgets/atoms/input/positive_text_field_prefix_container.dart';
import 'package:app/widgets/behaviours/positive_tap_behaviour.dart';
import 'package:logger/logger.dart';
import 'package:stream_chat_flutter/stream_chat_flutter.dart';
import '../../../constants/design_constants.dart';

class PositiveTextField extends StatefulHookConsumerWidget {
  const PositiveTextField({
    this.initialText = '',
    this.labelText,
    this.hintText,
    this.fillColor,
    this.tintColor = Colors.blue,
    this.onTextChanged,
    this.onTextSubmitted,
    this.onFocusedChanged,
    this.textInputAction,
    this.textInputType = TextInputType.text,
    this.textCapitalization = TextCapitalization.none,
    this.prefixIcon,
    this.label,
    this.suffixIcon,
    this.obscureText = false,
    this.isEnabled = true,
    this.maxLines = 1,
    this.minLines = 1,
    this.onControllerCreated,
    this.textEditingController,
    this.maxLength,
    this.maxLengthEnforcement = MaxLengthEnforcement.none,
    this.borderRadius = kBorderRadiusLargePlus,
    this.borderWidth = kBorderThicknessSmall,
    this.forceBorder = false,
    this.textStyle,
    this.labelColor,
    this.labelStyle,
    this.inputformatters,
    this.showRemaining = false,
    this.showRemainingStyle,
    this.autofocus = false,
    this.autocorrect = true,
    this.allowMentions = false,
    super.key,
  });

  final String initialText;
  final String? hintText;
  final TextStyle? textStyle;
  final int? maxLength;
  final MaxLengthEnforcement maxLengthEnforcement;
  final double borderRadius;
  final double borderWidth;

  final Widget? label;
  final String? labelText;
  final Color? labelColor;
  final TextStyle? labelStyle;

  final bool showRemaining;
  final TextStyle? showRemainingStyle;

  final Function(String str)? onTextChanged;
  final Function(String str)? onTextSubmitted;
  final Function(bool isFocused)? onFocusedChanged;

  final Color tintColor;
  final Color? fillColor;

  final TextInputAction? textInputAction;
  final TextInputType textInputType;
  final TextCapitalization textCapitalization;
  final TextEditingController? textEditingController;

  final List<TextInputFormatter>? inputformatters;

  final Widget? prefixIcon;
  final Widget? suffixIcon;

  final bool obscureText;
  final bool isEnabled;
  final bool forceBorder;

  final int maxLines;
  final int minLines;

  final bool autofocus;
  final bool autocorrect;

  final bool allowMentions;

  final void Function(TextEditingController controller)? onControllerCreated;

  @override
  ConsumerState<ConsumerStatefulWidget> createState() => PositiveTextFieldState();
}

class PositiveTextFieldState extends ConsumerState<PositiveTextField> {
  late final FocusNode textFocusNode;
  late final TextEditingController textEditingController;

  String lastKnownText = '';
  double labelPadding = 0.0;

  CancelableOperation<Iterable<Profile>>? mentionSearchOperation;
  Iterable<Profile>? mentionSearchResults;
  String? latestMentionSearchQuery;

  bool get isSearchingForMentions => mentionSearchOperation != null;

  // Display flags based on mention search
  bool get canDisplayMentionSearchIndicator => isSearchingForMentions;
  bool get canDisplayMentionSearchResults => mentionSearchResults != null && mentionSearchResults!.isNotEmpty;

  bool get isFocused => _isFocused;
  bool _isFocused = false;
  set isFocused(bool value) {
    if (_isFocused != value) {
      setState(() {
        _isFocused = value;
      });
    }
  }

  @override
  void initState() {
    super.initState();
    setupLateVariables();
    setupListeners();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      checkTextSize();
    });
  }

  @override
  void dispose() {
    disposeListeners();
    super.dispose();
  }

  void checkTextSize() {
    if (widget.labelText == null) {
      return;
    }
    final DesignTypographyModel typography = ref.read(designControllerProvider.select((value) => value.typography));

    TextStyle labelStyle = widget.labelStyle ?? typography.styleButtonRegular;
    labelStyle = labelStyle.copyWith(fontWeight: FontWeight.w600);

    final double labelTextHeight = getTextSize(
      text: widget.labelText!,
      textStyle: labelStyle,
      context: context,
    ).height;

    //? Since this is a little arcane to understand, here's a breakdown of the calculation:
    //? 1. kCreatePostHeight is the height of the text field
    //? 2. labelTextHeight is the height of the label text
    //?     thus (kCreatePostHeight - labelTextHeight) / 2 is the space required between the top of the text label and the top of the text field
    //? From here, we need to subtract the following:
    //? 3. widget.borderWidth is the thickness of the border
    //? 4. (kPaddingExtraSmall - widget.borderWidth) is the padding applied to the whole text field (including icons etc)
    //? 5. kPaddingSmall is the padding applied to the top text field in order to allow space between it and the label once focused.
    //?        Since the unfocused text field applies the padding to the label, we need to remove it from the label padding
    //? 6. labelPadding is the padding between the label and the text field
    labelPadding = (kCreatePostHeight - labelTextHeight) / 2 - (widget.borderWidth) - (kPaddingExtraSmall - widget.borderWidth) - kPaddingSmall;
  }

  void setupLateVariables() {
    textFocusNode = FocusNode();
    textEditingController = widget.textEditingController ?? TextEditingController(text: widget.initialText);
    lastKnownText = widget.initialText;

    widget.onControllerCreated?.call(textEditingController);
  }

  void setupListeners() {
    textFocusNode.addListener(onFocusChanged);
    textEditingController.addListener(onControllerChanged);
  }

  void disposeListeners() {
    textFocusNode.removeListener(onFocusChanged);
    textEditingController.removeListener(onControllerChanged);
  }

  void onFocusChanged() {
    if (!mounted) {
      return;
    }

    isFocused = textFocusNode.hasFocus;
    if (widget.onFocusedChanged != null) {
      widget.onFocusedChanged!(isFocused);
    }
  }

  void onControllerChanged() {
    if (!mounted) {
      return;
    }

    if (widget.onTextChanged != null && lastKnownText != textEditingController.text) {
      widget.onTextChanged!(textEditingController.text);
    }

    // Clear the mention search results if the text changes
    if (mentionSearchResults != null) {
      mentionSearchResults = null;
      setStateIfMounted();
    }

    // Get the cursor position
    final int cursorPosition = textEditingController.selection.baseOffset;
    attemptPerformMentionLookup(cursorPosition);

    lastKnownText = textEditingController.text;
    setState(() {});
  }

  Future<void> attemptPerformMentionLookup(int cursorPosition) async {
    if (!widget.allowMentions) {
      return;
    }

    // Get the word at the cursor position
    final String? word = getWordAtCursorPosition(textEditingController.text, cursorPosition);
    if (word == null) {
      return;
    }

    // Check if the word is a mention
    if (!word.startsWith('@')) {
      return;
    }

    // Check if we have already searched for this word
    if (word == latestMentionSearchQuery) {
      return;
    }

    // Cancel any previous search
    await mentionSearchOperation?.cancel();
    mentionSearchOperation = null;
    mentionSearchResults = null;
    setStateIfMounted();

    // Check if we have more than just the @ symbol
    if (word.length <= 1) {
      return;
    }

    try {
      mentionSearchOperation = CancelableOperation.fromFuture(
        performMentionUserSearch(word.substring(1)),
      );

      setStateIfMounted();
      mentionSearchResults = await mentionSearchOperation?.value;
    } finally {
      mentionSearchOperation = null;
      setStateIfMounted();
    }
  }

  Future<Iterable<Profile>> performMentionUserSearch(String query) async {
    final logger = ref.read(loggerProvider);
    final SearchApiService searchApiService = await ref.read(searchApiServiceProvider.future);

    logger.d("Searching for users with query: $query");
    final SearchResult<Profile> response = await searchApiService.search(
      query: query,
      index: "users",
      fromJson: (json) => Profile.fromJson(json),
      pagination: const Pagination(
        limit: 3,
      ),
    );

    return response.results;
  }

  String? getWordAtCursorPosition(String text, int cursorPosition) {
    if (text.isEmpty) {
      return null;
    }

    // Check if the character prior to the cursor is a space
    if (cursorPosition > 0 && text[cursorPosition - 1] == ' ') {
      return null;
    }

    // Get the word at the cursor position
    final List<String> words = text.split(' ');
    int wordStart = 0;
    int wordEnd = 0;
    for (int i = 0; i < words.length; i++) {
      final String word = words[i];
      wordStart = wordEnd;
      wordEnd = wordStart + word.length + 1;
      if (cursorPosition >= wordStart && cursorPosition <= wordEnd) {
        return word;
      }
    }

    return null;
  }

  void appendMentionToCursorPosition(Profile profile) {
    final String? word = getWordAtCursorPosition(textEditingController.text, textEditingController.selection.baseOffset);
    if (word == null) {
      return;
    }

    final String mention = '@${profile.displayName}';
    final String text = textEditingController.text;
    final String newText = text.replaceRange(
      textEditingController.selection.baseOffset - word.length,
      textEditingController.selection.baseOffset,
      mention,
    );

    textEditingController.text = '$newText ';
  }

  @override
  Widget build(BuildContext context) {
    final DesignColorsModel colours = ref.watch(designControllerProvider.select((value) => value.colors));
    final DesignTypographyModel typography = ref.watch(designControllerProvider.select((value) => value.typography));
    final localisations = AppLocalizations.of(context)!;

    final bool hasText = textEditingController.text.isNotEmpty;
    final bool hasTextIsFocused = hasText || isFocused;

    final Color textColour = widget.textStyle?.color ?? colours.black;
    TextStyle labelStyle = widget.labelStyle ?? typography.styleButtonRegular;

    labelStyle = labelStyle.copyWith(
      color: widget.labelColor ?? (hasTextIsFocused ? widget.tintColor : textColour),
      fontWeight: hasTextIsFocused ? FontWeight.w800 : FontWeight.w600,
    );

    final bool hasBorder = isFocused || widget.forceBorder;

    final OutlineInputBorder baseBorder = OutlineInputBorder(
      borderRadius: BorderRadius.circular(widget.borderRadius),
      borderSide: BorderSide(
        width: kPaddingNone,
        style: BorderStyle.none,
        color: colours.transparent,
      ),
    );

    Widget? labelChild;
    if (widget.label != null) {
      labelChild = widget.label;
    }

    if (widget.showRemaining && widget.maxLength != null && (hasTextIsFocused || textEditingController.text.isNotEmpty)) {
      int remainingCharacters = widget.maxLength! - textEditingController.text.length;
      labelChild = RichText(
        text: TextSpan(
          style: labelStyle,
          text: widget.labelText,
          children: [
            TextSpan(
              style: widget.showRemainingStyle ?? typography.styleButtonRegular.copyWith(color: colours.colorGray4),
              text: localisations.page_create_post_caption_remaining_characters(remainingCharacters),
            ),
          ],
        ),
      );
    }

    final Widget child = PositiveTapBehaviour(
      onTap: (_) => textFocusNode.requestFocus(),
      child: Container(
        constraints: const BoxConstraints(minHeight: kCreatePostHeight),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(widget.borderRadius),
          color: widget.fillColor ?? colours.white,
          border: Border.all(
            color: hasBorder ? widget.tintColor : widget.fillColor ?? colours.white,
            width: widget.borderWidth,
          ),
        ),
        padding: EdgeInsets.only(
          top: kPaddingExtraSmall - widget.borderWidth,
          bottom: kPaddingExtraSmall - widget.borderWidth,
          left: (widget.prefixIcon == null) ? kPaddingLarge - widget.borderWidth : kPaddingExtraSmall - widget.borderWidth,
          right: kPaddingExtraSmall - widget.borderWidth,
        ),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            if (widget.prefixIcon != null) ...[
              PositiveTextFieldPrefixContainer(
                color: hasTextIsFocused ? widget.tintColor : colours.colorGray2,
                child: widget.prefixIcon!,
              ),
              const SizedBox(width: kPaddingExtraSmall),
            ],
            Expanded(
              child: AnimatedPadding(
                padding: EdgeInsetsDirectional.only(
                  top: hasTextIsFocused && widget.labelText != null ? kPaddingExtraSmall : labelPadding,
                  bottom: !(hasTextIsFocused && widget.labelText != null) ? kPaddingExtraSmall : labelPadding,
                ),
                duration: kAnimationDurationFast,
                child: TextFormField(
                  textCapitalization: widget.textCapitalization,
                  autocorrect: widget.autocorrect,
                  autofocus: widget.autofocus,
                  focusNode: textFocusNode,
                  inputFormatters: [
                    if (widget.maxLengthEnforcement != MaxLengthEnforcement.none) LengthLimitingTextInputFormatter(widget.maxLength),
                    removeDuplicateWhitespaceFormatter(),
                    ...?widget.inputformatters,
                  ],
                  enableSuggestions: true,
                  obscureText: widget.obscureText,
                  obscuringCharacter: kObscuringTextCharacter,
                  keyboardType: widget.textInputType,
                  textInputAction: widget.textInputAction,
                  controller: textEditingController,
                  enabled: widget.isEnabled,
                  minLines: widget.minLines,
                  maxLines: widget.maxLines,
                  cursorColor: textColour,
                  style: widget.textStyle ?? typography.styleButtonRegular.copyWith(color: textColour),
                  onFieldSubmitted: (String text) => widget.onTextSubmitted?.call(text),
                  decoration: InputDecoration(
                    isCollapsed: true,
                    isDense: true,
                    alignLabelWithHint: true,
                    label: labelChild,
                    labelText: labelChild == null ? widget.labelText : null,
                    labelStyle: labelStyle,
                    hintText: widget.hintText,
                    hintStyle: typography.styleButtonRegular.copyWith(
                      color: textColour,
                      fontWeight: FontWeight.w600,
                    ),
                    floatingLabelBehavior: FloatingLabelBehavior.auto,
                    contentPadding: const EdgeInsets.only(
                      top: kPaddingSmall,
                      bottom: kPaddingNone,
                      left: kPaddingNone,
                      right: kPaddingNone,
                    ),
                    border: baseBorder,
                    disabledBorder: baseBorder,
                    errorBorder: baseBorder,
                    focusedErrorBorder: baseBorder,
                    enabledBorder: baseBorder,
                    focusedBorder: baseBorder,
                  ),
                ),
              ),
            ),
            if (widget.suffixIcon != null) ...[
              const SizedBox(width: kPaddingExtraSmall),
              widget.suffixIcon!,
            ],
          ],
        ),
      ),
    );

    return Column(
      children: <Widget>[
        child,
        if (canDisplayMentionSearchIndicator) ...<Widget>[
          buildMentionSearchIndicator(),
        ],
        if (canDisplayMentionSearchResults) ...<Widget>[
          buildMentionSearchResults(),
        ],
      ],
    );
  }

  Widget buildMentionSearchIndicator() {
    final DesignColorsModel colours = ref.read(designControllerProvider.select((value) => value.colors));

    return Padding(
      padding: const EdgeInsets.all(kPaddingSmall),
      child: PositiveGlassSheet(
        children: <Widget>[
          PositiveLoadingIndicator(color: colours.white),
        ],
      ),
    );
  }

  Widget buildMentionSearchResults() {
    final ProfileController profileController = ref.read(profileControllerProvider.notifier);
    final CacheController cacheController = ref.read(cacheControllerProvider);

    final Profile? senderProfile = profileController.currentProfile;
    final String senderProfileId = senderProfile?.flMeta?.id ?? '';

    final List<Widget> tiles = [];
    for (final Profile targetProfile in mentionSearchResults ?? []) {
      final String targetProfileId = targetProfile.flMeta?.id ?? '';
      final String expectedRelationshipId = [senderProfileId, targetProfileId].asGUID;
      final Relationship? relationship = cacheController.get(expectedRelationshipId);

      tiles.add(
        PositiveProfileListTile(
          senderProfile: senderProfile,
          targetProfile: targetProfile,
          relationship: relationship,
          type: PositiveProfileListTileType.selectable,
          onSelected: () => appendMentionToCursorPosition(targetProfile),
        ),
      );
    }

    return Padding(
      padding: const EdgeInsets.all(kPaddingSmall),
      child: PositiveGlassSheet(
        children: tiles.spaceWithVertical(kPaddingExtraSmall),
      ),
    );
  }
}
