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

  void onTagTapped(String tag) {
    if (selectedTags.contains(tag)) {
      selectedTags.remove(tag);
    } else {
      selectedTags.add(tag);
    }

    setState(() {});
  }

  @override
  void initState() {
    selectedTags.addAll(widget.currentTags);
    filteredTags.addAll(widget.allTags);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final DesignColorsModel colours = ref.read(designControllerProvider.select((value) => value.colors));

    final MediaQueryData mediaQueryData = MediaQuery.of(context);
    final double marginHeight = kPaddingMedium + mediaQueryData.padding.top;

    final List<Widget> tagWidgets = [];
    for (var i = 0; i < min(20, filteredTags.length); i++) {
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
                onSubmitted: (string) {
                  filteredTags.add(string);
                  selectedTags.add(string);
                  setState(() {});
                },
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
    required this.tagId,
    required this.isSelected,
    required this.onTap,
    super.key,
  });

  final String tagName;
  final String tagId;
  final bool isSelected;
  final VoidCallback onTap;

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
        padding: const EdgeInsets.symmetric(horizontal: kPaddingMedium),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Text(
              localisations.shared_hashtag,
              style: typography.styleTopic.copyWith(color: isSelected ? colours.colorGray7 : colours.colorGray6),
            ),
            const SizedBox(width: kPaddingExtraSmall),
            Text(
              tagName,
              style: typography.styleTopic.copyWith(color: isSelected ? colours.white : colours.black),
            ),
            const Spacer(),
            Text(
              tagId,
              style: typography.styleNotification.copyWith(color: colours.colorGray6),
            ),
          ],
        ),
      ),
    );
  }
}
