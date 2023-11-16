// Dart imports:
import 'dart:typed_data';

// Flutter imports:
import 'package:flutter/material.dart';

// Package imports:
import 'package:camerawesome/camerawesome_plugin.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:sliver_tools/sliver_tools.dart';
import 'package:unicons/unicons.dart';

// Project imports:
import 'package:app/constants/design_constants.dart';
import 'package:app/dtos/system/design_colors_model.dart';
import 'package:app/providers/content/dtos/gallery_entry.dart';
import 'package:app/providers/system/design_controller.dart';
import 'package:app/widgets/atoms/buttons/enumerations/positive_button_style.dart';
import 'package:app/widgets/atoms/buttons/positive_button.dart';
import 'package:app/widgets/behaviours/positive_tap_behaviour.dart';
import 'package:app/widgets/molecules/navigation/positive_app_bar.dart';
import 'package:app/widgets/organisms/post/component/positive_image_editor.dart';

class PositiveImageGallery extends ConsumerWidget {
  const PositiveImageGallery({
    super.key,
    required this.galleryEntries,
    this.onGalleryEntrySelected,
    this.selectedGalleryEntry,
    this.onBackButtonPressed,
  });

  final List<GalleryEntry> galleryEntries;
  final GalleryEntry? selectedGalleryEntry;
  final void Function(GalleryEntry)? onGalleryEntrySelected;
  final VoidCallback? onBackButtonPressed;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final MediaQueryData mediaQueryData = MediaQuery.of(context);
    final DesignColorsModel colors = ref.read(designControllerProvider.select((value) => value.colors));

    final double imagePreviewSize = mediaQueryData.size.width;

    return CustomScrollView(
      slivers: <Widget>[
        SliverPinnedHeader(
          child: Column(
            children: <Widget>[
              PositiveAppBar(
                backgroundColor: colors.black,
                foregroundColor: colors.white,
                includeLogoWherePossible: false,
                safeAreaQueryData: mediaQueryData,
                applyLeadingandTrailingPadding: true,
                leading: PositiveButton.appBarIcon(
                  colors: colors,
                  icon: UniconsLine.angle_left,
                  primaryColor: colors.white,
                  style: PositiveButtonStyle.outline,
                  onTapped: () => onBackButtonPressed != null ? onBackButtonPressed?.call() : Navigator.of(context).pop(),
                ),
                trailing: <Widget>[
                  PositiveButton.appBarIcon(
                    colors: colors,
                    icon: UniconsLine.image_edit,
                    primaryColor: colors.white,
                    style: PositiveButtonStyle.outline,
                    isDisabled: selectedGalleryEntry == null,
                    onTapped: () => onGalleryEntrySelected?.call(selectedGalleryEntry!),
                  ),
                ],
              ),
              PositiveGalleryPreview(
                colors: colors,
                imagePreviewSize: imagePreviewSize,
                editedImageBytes: selectedGalleryEntry?.data ?? Uint8List(0),
                currentFilter: AwesomeFilter.None,
                showEditingHint: false,
              ),
            ],
          ),
        ),
        if (galleryEntries.length > 1) ...[
          SliverToBoxAdapter(
            child: GridView.builder(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              padding: EdgeInsets.only(
                bottom: kPaddingMedium + kCreatePostNavigationHeight + kPaddingMedium + mediaQueryData.padding.bottom,
              ),
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 3,
                crossAxisSpacing: 1,
                mainAxisSpacing: 1,
              ),
              itemCount: galleryEntries.length,
              itemBuilder: (BuildContext context, int index) {
                final GalleryEntry galleryEntry = galleryEntries[index];
                return PositiveTapBehaviour(
                  onTap: (_) => onGalleryEntrySelected?.call(galleryEntry),
                  isEnabled: onGalleryEntrySelected != null,
                  child: AnimatedOpacity(
                    duration: kAnimationDurationFast,
                    opacity: selectedGalleryEntry?.fileName == galleryEntry.fileName ? 0.25 : 1.0,
                    child: PositiveGalleryPreview(
                      colors: colors,
                      imagePreviewSize: imagePreviewSize,
                      editedImageBytes: galleryEntry.data ?? Uint8List(0),
                      currentFilter: AwesomeFilter.None,
                      showEditingHint: false,
                    ),
                  ),
                );
              },
            ),
          ),
        ],
      ],
    );
  }
}

enum PositiveEditorState {
  loading,
  editing,
}
