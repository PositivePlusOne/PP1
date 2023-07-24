// Flutter imports:
import 'package:app/dtos/database/activities/activities.dart';
import 'package:app/dtos/system/design_colors_model.dart';
import 'package:app/providers/system/design_controller.dart';
import 'package:app/widgets/atoms/buttons/enumerations/positive_button_style.dart';
import 'package:app/widgets/atoms/buttons/positive_button.dart';
import 'package:app/widgets/organisms/post/create_post_dialogue.dart';
import 'package:app/widgets/organisms/post/create_post_tag_dialogue.dart';
import 'package:app/widgets/organisms/post/vms/create_post_data_structures.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:unicons/unicons.dart';

class CreateStatefulPostDialogue extends StatefulHookConsumerWidget {
  const CreateStatefulPostDialogue({
    required this.allowSharing,
    required this.activity,
    required this.onFinish,
    super.key,
  });

  final bool allowSharing;
  final Activity activity;
  final Function(ActivityData) onFinish;

  @override
  ConsumerState<CreateStatefulPostDialogue> createState() => _CreateStatefulPostDialogueState();
}

class _CreateStatefulPostDialogueState extends ConsumerState<CreateStatefulPostDialogue> {
  bool isBusy = false;
  bool allowSharing = false;
  bool saveToGallery = false;
  String allowComments = "";
  String visibleTo = "";
  List<String> newTags = const [];
  TextEditingController captionController = TextEditingController();
  //TODO alt text in activities
  TextEditingController altTextController = TextEditingController(text: "Alt text");

  @override
  void initState() {
    allowSharing = widget.allowSharing;
    newTags = widget.activity.enrichmentConfiguration?.tags ?? const [];
    captionController.text = widget.activity.generalConfiguration?.content ?? "";
    // altTextController.text = widget.activity.enrichmentConfiguration?.altText ?? "";
    // allowComments = widget.activity.enrichmentConfiguration?.allowComments ?? "";
    // visibleTo = widget.activity.enrichmentConfiguration?.visibleTo ?? "";
    super.initState();
  }

  void onUpdateAllowSharing() {
    setState(() {
      allowSharing = !allowSharing;
    });
  }

  void onUpdateSaveToGallery() {
    setState(() {
      saveToGallery = !saveToGallery;
    });
  }

  void onUpdateAllowComments(String value) {
    setState(() {
      allowComments = value;
    });
  }

  void onUpdateVisibleTo(String value) {
    setState(() {
      visibleTo = value;
    });
  }

  Future<void> onTagsPressed() async {
    //TODO get tags from server
    final List<String> allTags = ["tag1", "tag2", "tag3", "tag4", "tag5", "tag6", "tag7", "tag8", "tag9", "tag10"];
    newTags = await showCupertinoDialog(
      context: context,
      builder: (_) => CreatePostTagDialogue(
        allTags: allTags,
        currentTags: newTags,
      ),
    );
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    final DesignColorsModel colours = ref.read(designControllerProvider.select((value) => value.colors));
    final AppLocalizations localisations = AppLocalizations.of(context)!;

    return CreatePostDialogue(
      isBusy: isBusy,
      //TODO Count images from endpoint
      postType: PostType.getPostTypeFromActivity(widget.activity),
      captionController: captionController,
      altTextController: altTextController,
      tags: newTags,
      onTagsPressed: onTagsPressed,
      onUpdateAllowSharing: () => onUpdateAllowSharing(),
      onUpdateSaveToGallery: () => onUpdateSaveToGallery(),
      onUpdateAllowComments: onUpdateAllowComments,
      onUpdateVisibleTo: onUpdateVisibleTo,

      valueAllowSharing: allowSharing,
      valueSaveToGallery: saveToGallery,

      trailingWidget: PositiveButton(
        colors: colours,
        onTapped: () => widget.onFinish(
          ActivityData(
            content: captionController.text,
            tags: newTags,
            allowComments: allowComments,
            allowSharing: allowSharing,
            visibleTo: visibleTo,
          ),
        ),
        label: localisations.post_dialogue_update_post,
        primaryColor: colours.black,
        iconColorOverride: colours.white,
        icon: UniconsLine.file_times_alt,
        style: PositiveButtonStyle.primary,
      ),

      prepopulatedActivity: widget.activity,
    );
  }
}
