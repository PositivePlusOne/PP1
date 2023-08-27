// Dart imports:
import 'dart:math';

// Flutter imports:
import 'package:flutter/material.dart';

// Package imports:
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:unicons/unicons.dart';

// Project imports:
import 'package:app/constants/design_constants.dart';
import 'package:app/dtos/database/activities/tags.dart';
import 'package:app/dtos/database/pagination/pagination.dart';
import 'package:app/dtos/system/design_colors_model.dart';
import 'package:app/dtos/system/design_typography_model.dart';
import 'package:app/extensions/string_extensions.dart';
import 'package:app/extensions/widget_extensions.dart';
import 'package:app/providers/profiles/tags_controller.dart';
import 'package:app/services/api.dart';
import 'package:app/widgets/atoms/buttons/enumerations/positive_button_size.dart';
import 'package:app/widgets/atoms/buttons/enumerations/positive_button_style.dart';
import 'package:app/widgets/atoms/buttons/positive_button.dart';
import 'package:app/widgets/atoms/input/positive_search_field.dart';
import 'package:app/widgets/behaviours/positive_tap_behaviour.dart';
import '../../../providers/system/design_controller.dart';

class CreatePostTagDialogue extends StatefulHookConsumerWidget {
  const CreatePostTagDialogue({
    required this.currentTags,
    super.key,
  });

  final List<Tag> currentTags;

  @override
  ConsumerState<CreatePostTagDialogue> createState() => _CreatePostTagDialogueState();
}

class _CreatePostTagDialogueState extends ConsumerState<CreatePostTagDialogue> {
  //? List of tags that have been selected by the user to add to the post
  final List<Tag> selectedTags = [];

  //? List of tags that have been filtered by the user's search query (may contain tags that have already been selected)
  final List<Tag> filteredTags = [];

  Tag? lastSearchedTag;
  final TextEditingController searchController = TextEditingController();
  static int maxTagsPerPage = 20;

  void onPageExit() {
    Navigator.pop(context, selectedTags.map((e) => e.key).toList());
  }

  void onTagTapped(BuildContext context, Tag tag, {bool insert = false}) {
    if (selectedTags.contains(tag)) {
      selectedTags.remove(tag);
    } else {
      //? We only want to allow a maximum of 5 tags, for the server validation refer to tags_service.ts under the function removeRestrictedTagsFromStringArray
      if (selectedTags.length < 5) {
        selectedTags.insert(insert ? 0 : selectedTags.length, tag);
      }
    }

    setStateIfMounted();
  }

  Future<void> onTagSearchSubmitted(String searchString) async {
    final SearchApiService searchApiService = await ref.read(searchApiServiceProvider.future);
    final String formattedSearchString = searchString.asTagKey;

    final List<Map<String, Object?>> response = await searchApiService.search(
      query: searchString,
      index: "tags",
      pagination: Pagination(
        // cursor: , for additional pagination
        limit: maxTagsPerPage,
      ),
    );
    filteredTags.clear();
    filteredTags.addAll(response.map((Map<String, dynamic> tag) => Tag.fromJson(tag)).toList());

    if (!filteredTags.any((element) => element.key == formattedSearchString)) {
      if (!selectedTags.any((element) => element.key == formattedSearchString)) {
        lastSearchedTag = formattedSearchString.asTag;
      } else {
        lastSearchedTag = null;
      }
    } else {
      lastSearchedTag = null;
    }

    setStateIfMounted();
  }

  @override
  void initState() {
    super.initState();
    selectedTags.addAll(widget.currentTags);
    enrichFilteredTagList();
  }

  @override
  void dispose() {
    searchController.dispose();
    super.dispose();
  }

  void enrichFilteredTagList() {
    final TagsControllerState tagState = ref.read(tagsControllerProvider);
    if (tagState.recentTags.isEmpty) {
      return;
    }

    final List<Tag> returnTags = [];
    final List<Tag> enrichedTags = [
      ...tagState.recentTags,
    ];

    // Remove any tags that have already been selected
    for (Tag tag in enrichedTags) {
      if (selectedTags.any((element) => element.key == tag.key)) {
        continue;
      }

      returnTags.add(tag);
    }

    // Sort by popularity
    returnTags.sort((a, b) => b.popularity.compareTo(a.popularity));

    filteredTags.clear();
    filteredTags.addAll(returnTags);
    setStateIfMounted();
  }

  @override
  Widget build(BuildContext context) {
    final DesignColorsModel colours = ref.read(designControllerProvider.select((value) => value.colors));
    final TagsController tagsController = ref.watch(tagsControllerProvider.notifier);

    final MediaQueryData mediaQueryData = MediaQuery.of(context);
    final double marginHeight = kPaddingMedium + mediaQueryData.padding.top;

    final List<Widget> tagWidgets = [];

    //? add the currently searched for tag as an optional tag to the top of the list
    final bool isSearchedTagValidForSearch = lastSearchedTag != null && lastSearchedTag!.key.isNotEmpty;

    if (isSearchedTagValidForSearch) {
      //todo this may need to become a more complex getter in tag extentions
      final bool isSearchedTagInSearchResults = filteredTags.where((element) => element.key == lastSearchedTag!.key).isNotEmpty;
      final bool isSearchedTagSelected = selectedTags.where((element) => element.key == lastSearchedTag!.key).isNotEmpty;
      if (!isSearchedTagInSearchResults && !isSearchedTagSelected) {
        tagWidgets.add(
          TagLabel(
            tag: lastSearchedTag!,
            onTap: (context) => onTagTapped(context, lastSearchedTag!, insert: true),
            isAddKeyword: true,
            isSelected: false,
          ),
        );
      }
    }

    //? Add currently selected tags to the top of the list
    for (Tag tag in selectedTags) {
      tagWidgets.add(
        TagLabel(
          tag: tag,
          onTap: (context) => onTagTapped(context, tag),
          isRemoveKeyword: !tagsController.tagExists(tag.key),
          isSelected: true,
        ),
      );
    }

    //? add the first 20 filtered tags to the list
    for (var i = 0; i < min(maxTagsPerPage, filteredTags.length); i++) {
      if (selectedTags.contains(filteredTags[i])) continue;
      tagWidgets.add(
        TagLabel(
          tag: filteredTags[i],
          onTap: (context) => onTagTapped(context, filteredTags[i]),
          isSelected: selectedTags.contains(filteredTags[i]) ? true : false,
        ),
      );
    }

    return Scaffold(
      body: WillPopScope(
        onWillPop: () async {
          onPageExit();
          return false;
        },
        child: Container(
          color: colours.white,
          padding: const EdgeInsets.symmetric(horizontal: kPaddingMedium),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              SizedBox(height: marginHeight),
              PositiveButton.appBarIcon(
                colors: colours,
                primaryColor: colours.colorGray6,
                icon: UniconsLine.times,
                size: PositiveButtonSize.medium,
                style: PositiveButtonStyle.outline,
                onTapped: () async => onPageExit(),
              ),
              const SizedBox(height: kPaddingMedium),
              PositiveSearchField(
                controller: searchController,
                onCancel: () => enrichFilteredTagList(),
                onChange: (_) {
                  lastSearchedTag = null;
                  setStateIfMounted();
                },
                onSubmitted: (string) async => onTagSearchSubmitted(string),
              ),
              const SizedBox(height: kPaddingMedium),
              Expanded(
                child: ListView(
                  shrinkWrap: true,
                  padding: EdgeInsets.zero,
                  children: tagWidgets.addSeparatorsToWidgetList(
                    separator: const SizedBox(height: kPaddingSmall),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class TagLabel extends HookConsumerWidget {
  const TagLabel({
    required this.tag,
    required this.isSelected,
    required this.onTap,
    this.isAddKeyword = false,
    this.isRemoveKeyword = false,
    super.key,
  });

  final Tag tag;
  final bool isSelected;
  final void Function(BuildContext context) onTap;
  final bool isAddKeyword;
  final bool isRemoveKeyword;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final AppLocalizations localisations = AppLocalizations.of(context)!;
    final DesignColorsModel colours = ref.read(designControllerProvider.select((value) => value.colors));
    final DesignTypographyModel typography = ref.read(designControllerProvider.select((value) => value.typography));

    late double leftPadding;
    late double rightPadding;

    if (isAddKeyword) {
      if (isRemoveKeyword) {
        leftPadding = kPaddingMedium;
        rightPadding = kPaddingMedium;
      } else {
        leftPadding = kPaddingSmall;
        rightPadding = kPaddingExtraSmall;
      }
    } else {
      if (isRemoveKeyword) {
        leftPadding = kPaddingExtraSmall;
        rightPadding = kPaddingSmall;
      } else {
        leftPadding = kPaddingMedium;
        rightPadding = kPaddingMedium;
      }
    }

    final EdgeInsetsGeometry padding = EdgeInsets.only(
      left: leftPadding,
      right: rightPadding,
      top: kPaddingNone,
      bottom: kPaddingNone,
    );

    return PositiveTapBehaviour(
      onTap: onTap,
      child: Container(
        width: double.infinity,
        height: kPaddingLarge,
        decoration: BoxDecoration(
          color: isSelected ? colours.black : colours.colorGray1,
          borderRadius: BorderRadius.circular(kBorderRadiusLarge),
        ),
        padding: padding,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            if (isAddKeyword)
              Text(
                "${localisations.shared_actions_add} ",
                style: typography.styleTopic.copyWith(color: isSelected ? colours.colorGray7 : colours.colorGray6),
              ),
            if (!isRemoveKeyword)
              Text(
                localisations.shared_hashtag,
                style: typography.styleTopic.copyWith(color: isSelected ? colours.colorGray7 : colours.colorGray6),
              ),
            if (isRemoveKeyword)
              SizedBox(
                height: kPaddingLarge,
                child: Icon(UniconsLine.times_circle, color: colours.white, size: kIconMedium),
              ),
            if (!isAddKeyword) const SizedBox(width: kPaddingVerySmall),
            Expanded(
              child: FittedBox(
                fit: BoxFit.scaleDown,
                alignment: Alignment.centerLeft,
                child: Container(
                  constraints: const BoxConstraints(minHeight: kPaddingThin, minWidth: kPaddingThin),
                  child: Text(
                    tag.fallback,
                    style: typography.styleTopic.copyWith(color: isSelected ? colours.white : colours.black),
                  ),
                ),
              ),
            ),
            const SizedBox(width: kPaddingSmall),
            if (!isAddKeyword && tag.popularity >= 0)
              Text(
                localisations.shared_hashtag + tag.popularity.toString(),
                style: typography.styleNotification.copyWith(color: colours.colorGray6),
              ),
            if (isAddKeyword)
              SizedBox(
                height: kPaddingLarge,
                child: Icon(UniconsLine.plus_circle, color: colours.black, size: kIconMedium),
              ),
          ],
        ),
      ),
    );
  }
}
