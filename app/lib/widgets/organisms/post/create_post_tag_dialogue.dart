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
import 'package:app/dtos/system/design_colors_model.dart';
import 'package:app/dtos/system/design_typography_model.dart';
import 'package:app/extensions/widget_extensions.dart';
import 'package:app/widgets/atoms/buttons/enumerations/positive_button_size.dart';
import 'package:app/widgets/atoms/buttons/enumerations/positive_button_style.dart';
import 'package:app/widgets/atoms/buttons/positive_button.dart';
import 'package:app/widgets/atoms/input/positive_search_field.dart';
import 'package:app/widgets/behaviours/positive_tap_behaviour.dart';
import '../../../providers/system/design_controller.dart';

class CreatePostTagDialogue extends StatefulHookConsumerWidget {
  const CreatePostTagDialogue({
    required this.allTags,
    required this.currentTags,
    super.key,
  });

  final List<String> allTags;
  final List<String> currentTags;

  @override
  ConsumerState<CreatePostTagDialogue> createState() => _CreatePostTagDialogueState();
}

class _CreatePostTagDialogueState extends ConsumerState<CreatePostTagDialogue> {
  final List<String> selectedTags = [];
  final List<String> filteredTags = [];
  final TextEditingController searchController = TextEditingController();

  void onTagTapped(String tag) {
    if (selectedTags.contains(tag)) {
      selectedTags.remove(tag);
    } else {
      //? We only want to allow a maximum of 6 tags, for the server validation refer to tags_service.ts under the function removeRestrictedTagsFromStringArray
      if (selectedTags.length < 6) {
        selectedTags.add(tag);
      }
    }

    setState(() {});
  }

  void rebuildTags() {
    filteredTags.clear();
    for (String tag in widget.allTags) {
      if (!filteredTags.contains(tag)) {
        filteredTags.add(tag);
      }
    }
  }

  @override
  void initState() {
    selectedTags.addAll(widget.currentTags);
    filteredTags.addAll(widget.allTags);
    super.initState();
  }

  @override
  void dispose() {
    searchController.dispose();
    super.dispose();
  }

  String validateTag(String string) {
    //* Validation of tags client side, please make sure this matches server side validation
    //* server side validation can be found in tags_service.ts under the function formatTag
    string = string.replaceAll(RegExp('[^a-zA-Z0-9 ]+'), '');
    string = string.replaceAll(RegExp('\\s+'), '_');
    int test = min(string.length, 30);
    string = string.substring(0, test);
    return string;
  }

  @override
  Widget build(BuildContext context) {
    final DesignColorsModel colours = ref.read(designControllerProvider.select((value) => value.colors));

    final MediaQueryData mediaQueryData = MediaQuery.of(context);
    final double marginHeight = kPaddingMedium + mediaQueryData.padding.top;

    // searchController.

    final List<Widget> tagWidgets = [];
    //? add the currently searched for tag as an optional tag to the top of the list
    String validatedSearchTag = validateTag(searchController.text);
    if (searchController.text.isNotEmpty && !selectedTags.contains(validatedSearchTag) && !filteredTags.contains(validatedSearchTag)) {
      tagWidgets.add(
        TagLabel(
          tagName: validatedSearchTag,
          onTap: () => onTagTapped(validatedSearchTag),
          isAddKeyword: true,
          isSelected: false,
        ),
      );
    }

    //? Add currently selected tags to the top of the list
    for (String tag in selectedTags) {
      tagWidgets.add(
        TagLabel(
          tagName: tag,
          tagId: "0",
          onTap: () => onTagTapped(tag),
          isSelected: true,
        ),
      );
    }

    //? add the first 20 filtered tags to the list
    for (var i = 0; i < min(20, filteredTags.length); i++) {
      if (selectedTags.contains(filteredTags[i])) continue;
      tagWidgets.add(
        TagLabel(
          tagName: filteredTags[i],
          tagId: "0000",
          onTap: () => onTagTapped(filteredTags[i]),
          isSelected: selectedTags.contains(filteredTags[i]) ? true : false,
        ),
      );
    }

    return Scaffold(
      body: WillPopScope(
        onWillPop: () async {
          Navigator.pop(context, selectedTags);
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
                onTapped: () async => Navigator.pop(context, selectedTags),
              ),
              const SizedBox(height: kPaddingMedium),
              PositiveSearchField(
                controller: searchController,
                onChange: (_) => setState(() {}),
                // onSubmitted: (string) {},
              ),
              const SizedBox(height: kPaddingMedium),
              ListView(
                shrinkWrap: true,
                padding: EdgeInsets.zero,
                children: tagWidgets.addSeparatorsToWidgetList(
                  separator: const SizedBox(height: kPaddingSmall),
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
    required this.tagName,
    required this.isSelected,
    required this.onTap,
    this.tagId,
    this.isAddKeyword = false,
    super.key,
  });

  final String tagName;
  final String? tagId;
  final bool isSelected;
  final VoidCallback onTap;
  final bool isAddKeyword;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final AppLocalizations localisations = AppLocalizations.of(context)!;
    final DesignColorsModel colours = ref.read(designControllerProvider.select((value) => value.colors));
    final DesignTypographyModel typography = ref.read(designControllerProvider.select((value) => value.typography));

    return PositiveTapBehaviour(
      onTap: onTap,
      child: Container(
        width: double.infinity,
        height: kPaddingLarge,
        decoration: BoxDecoration(
          color: isSelected ? colours.black : colours.colorGray1,
          borderRadius: BorderRadius.circular(kBorderRadiusLarge),
        ),
        padding: isAddKeyword ? const EdgeInsets.only(left: kPaddingSmall, right: kPaddingExtraSmall, top: 0) : const EdgeInsets.symmetric(horizontal: kPaddingMedium),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            if (isAddKeyword)
              Text(
                localisations.shared_actions_add + " ",
                style: typography.styleTopic.copyWith(color: isSelected ? colours.colorGray7 : colours.colorGray6),
              ),
            Text(
              localisations.shared_hashtag,
              style: typography.styleTopic.copyWith(color: isSelected ? colours.colorGray7 : colours.colorGray6),
            ),
            Expanded(
              child: FittedBox(
                fit: BoxFit.scaleDown,
                alignment: Alignment.centerLeft,
                child: Text(
                  tagName,
                  style: typography.styleTopic.copyWith(color: isSelected ? colours.white : colours.black),
                ),
              ),
            ),
            const SizedBox(width: kPaddingSmall),
            if (tagId != null && tagId!.isNotEmpty && !isAddKeyword)
              Text(
                tagId!,
                style: typography.styleNotification.copyWith(color: colours.colorGray6),
              ),
            if (isAddKeyword)
              SizedBox(
                height: kPaddingLarge,
                child: Icon(UniconsLine.plus_circle, color: colours.black, size: kIconMedium),
              )
          ],
        ),
      ),
    );
  }
}
