// Flutter imports:
import 'package:app/dtos/database/activities/activities.dart';
import 'package:app/widgets/organisms/post/create_post_dialogue.dart';
import 'package:app/widgets/organisms/post/create_post_tag_dialogue.dart';
import 'package:app/widgets/organisms/post/vms/create_post_enums.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class CreateStatefulPostDialogue extends StatefulWidget {
  const CreateStatefulPostDialogue({
    required this.allowSharing,
    required this.activity,
    super.key,
  });

  final bool allowSharing;
  final Activity activity;

  @override
  State<CreateStatefulPostDialogue> createState() => _CreateStatefulPostDialogueState();
}

class _CreateStatefulPostDialogueState extends State<CreateStatefulPostDialogue> {
  bool allowSharing = false;

  @override
  void initState() {
    allowSharing = widget.allowSharing;
    super.initState();
  }

  void onUpdateAllowSharing(bool newValue) {
    setState(() {
      allowSharing = newValue;
    });
  }

  @override
  Widget build(BuildContext context) {
    // final MediaQueryData mediaQueryData = MediaQuery.of(context);

    TextEditingController captionController = TextEditingController(text: widget.activity.generalConfiguration!.content);
    //TODO alt text in activities
    TextEditingController altTextController = TextEditingController(text: "Alt text");

    final List<String> allTags = ["tag1", "tag2", "tag3", "tag4", "tag5", "tag6", "tag7", "tag8", "tag9", "tag10"];
    List<String> newTags = [];

    return CreatePostDialogue(
      //TODO Count images from endpoint
      postType: PostType.getPostTypeFromString(widget.activity.generalConfiguration!.type, 1),
      captionController: captionController,
      altTextController: altTextController,
      //TODO get tags from server
      tags: allTags,
      onWillPopScope: () {},
      onTagsPressed: () async {
        newTags = await showCupertinoDialog(
          context: context,
          builder: (_) => CreatePostTagDialogue(
            allTags: allTags,
            currentTags: widget.activity.enrichmentConfiguration?.tags ?? const [],
          ),
        );
      },
      // onUpdateAllowSharing: viewModel.onUpdateAllowSharing,
      // onUpdateAllowComments: viewModel.onUpdateAllowComments,
      // onUpdateSaveToGallery: viewModel.onUpdateSaveToGallery,
      // onUpdateVisibleTo: viewModel.onUpdateVisibleTo,

      // valueAllowSharing: state.allowSharing,
      // valueSaveToGallery: state.saveToGallery,

      prepopulatedActivity: widget.activity,
    );
  }
}
