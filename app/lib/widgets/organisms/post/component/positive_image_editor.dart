import 'dart:typed_data';

import 'package:app/constants/design_constants.dart';
import 'package:app/extensions/number_extensions.dart';
import 'package:app/extensions/widget_extensions.dart';
import 'package:app/main.dart';
import 'package:app/providers/activities/dtos/gallery_entry.dart';
import 'package:app/services/third_party.dart';
import 'package:app/widgets/atoms/buttons/positive_back_button.dart';
import 'package:app/widgets/atoms/buttons/positive_button.dart';
import 'package:app/widgets/organisms/post/create_post_page.dart';
import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:logger/logger.dart';

class PositiveImageEditor extends StatefulHookConsumerWidget {
  const PositiveImageEditor({super.key, this.galleryEntry});

  final GalleryEntry? galleryEntry;

  @override
  ConsumerState<PositiveImageEditor> createState() => _PositiveImageEditorState();
}

enum PositiveEditorState {
  loading,
  editing,
}

class _PositiveImageEditorState extends ConsumerState<PositiveImageEditor> {
  PositiveEditorState state = PositiveEditorState.loading;
  Uint8List originalImageBytes = Uint8List(0);
  Uint8List editedImageBytes = Uint8List(0);

  @override
  void initState() {
    super.initState();
    loadInitialGalleryEntryData();
  }

  void loadInitialGalleryEntryData() async {
    final Logger logger = providerContainer.read(loggerProvider);
    if (widget.galleryEntry?.data?.isEmpty ?? true) {
      logger.e('Gallery entry data is empty');
      return;
    }

    originalImageBytes = widget.galleryEntry!.data!;
    editedImageBytes = widget.galleryEntry!.data!;
    state = PositiveEditorState.editing;
    setStateIfMounted();
  }

  @override
  Widget build(BuildContext context) {
    final MediaQueryData mediaQueryData = MediaQuery.of(context);

    return ListView(
      children: <Widget>[
        const PositiveBackButton(),
        //* Add padding so that the create post page navigation bar doesn't overlap the image editor
        kPaddingMedium.asVerticalBox,
        kCreatePostNavigationHeight.asVerticalBox,
        kPaddingMedium.asVerticalBox,
        mediaQueryData.padding.bottom.asVerticalBox,
      ],
    );
  }
}
