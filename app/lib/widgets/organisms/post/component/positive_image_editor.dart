// Dart imports:
import 'dart:typed_data';

// Flutter imports:
import 'package:flutter/material.dart';

// Package imports:
import 'package:camerawesome/camerawesome_plugin.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:logger/logger.dart';
import 'package:unicons/unicons.dart';

// Project imports:
import 'package:app/constants/design_constants.dart';
import 'package:app/constants/filter_constants.dart';
import 'package:app/dtos/system/design_colors_model.dart';
import 'package:app/dtos/system/design_typography_model.dart';
import 'package:app/extensions/dart_extensions.dart';
import 'package:app/extensions/number_extensions.dart';
import 'package:app/extensions/widget_extensions.dart';
import 'package:app/main.dart';
import 'package:app/providers/content/dtos/gallery_entry.dart';
import 'package:app/providers/system/design_controller.dart';
import 'package:app/services/third_party.dart';
import 'package:app/widgets/atoms/buttons/enumerations/positive_button_style.dart';
import 'package:app/widgets/atoms/buttons/positive_button.dart';
import 'package:app/widgets/atoms/indicators/positive_loading_indicator.dart';
import 'package:app/widgets/behaviours/positive_tap_behaviour.dart';
import 'package:app/widgets/molecules/dialogs/positive_toast_hint.dart';
import 'package:app/widgets/molecules/navigation/positive_app_bar.dart';

class PositiveImageEditor extends StatefulHookConsumerWidget {
  const PositiveImageEditor({
    required this.currentFilter,
    required this.onFilterSelected,
    required this.galleryEntry,
    required this.onBackButtonPressed,
    super.key,
  });

  final AwesomeFilter? currentFilter;
  final void Function(AwesomeFilter filter)? onFilterSelected;

  final GalleryEntry? galleryEntry;
  final VoidCallback? onBackButtonPressed;

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

  late final ScrollController _filterScrollController;

  @override
  void initState() {
    super.initState();
    _filterScrollController = ScrollController();
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

  void onInternalFilterSelected(BuildContext context, int index, AwesomeFilter filter) {
    widget.onFilterSelected?.call(filter);

    // Scroll the filter into the screen
    final int totalFilterCount = allSupportedFilters.length;
    const double filterSize = PositiveImageFilterSelector.kFilterSelectorSize;
    const double dividerSize = kPaddingMedium;

    final MediaQueryData mediaQueryData = MediaQuery.of(context);
    final double scrollOffset = (index * (filterSize + dividerSize)) - (mediaQueryData.size.width / 2) + (filterSize / 2);

    // TODO(stu): Please help me fix this
    // _filterScrollController.animateTo(
    //   scrollOffset,
    //   duration: kAnimationDurationRegular,
    //   curve: kAnimationCurveDefault,
    // );
  }

  @override
  Widget build(BuildContext context) {
    final MediaQueryData mediaQueryData = MediaQuery.of(context);
    final DesignColorsModel colors = ref.read(designControllerProvider.select((value) => value.colors));
    final DesignTypographyModel typography = ref.read(designControllerProvider.select((value) => value.typography));
    final double imagePreviewSize = mediaQueryData.size.width;

    return ListView(
      padding: EdgeInsets.zero,
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
            onTapped: () => widget.onBackButtonPressed != null ? widget.onBackButtonPressed?.call() : Navigator.of(context).pop(),
          ),
        ),
        const SizedBox(height: kPaddingMedium),
        PositiveGalleryPreview(
          colors: colors,
          imagePreviewSize: imagePreviewSize,
          editedImageBytes: editedImageBytes,
          currentFilter: widget.currentFilter ?? AwesomeFilter.None,
        ),
        if (widget.currentFilter != null && widget.onFilterSelected != null) ...[
          const SizedBox(height: kPaddingMedium),
          PositiveImageFilterSelector(
            controller: _filterScrollController,
            mediaQueryData: mediaQueryData,
            originalImageBytes: originalImageBytes,
            typography: typography,
            colors: colors,
            selectedFilter: widget.currentFilter ?? AwesomeFilter.None,
            onFilterSelected: onInternalFilterSelected,
          ),
        ],
        //* Add padding so that the create post page navigation bar doesn't overlap the image editor
        kPaddingMedium.asVerticalBox,
        kCreatePostNavigationHeight.asVerticalBox,
        kPaddingMedium.asVerticalBox,
        mediaQueryData.padding.bottom.asVerticalBox,
      ],
    );
  }
}

class PositiveImageFilterSelector extends StatelessWidget {
  const PositiveImageFilterSelector({
    super.key,
    required this.mediaQueryData,
    required this.originalImageBytes,
    required this.typography,
    required this.colors,
    required this.onFilterSelected,
    required this.selectedFilter,
    required this.controller,
  });

  final MediaQueryData mediaQueryData;
  final Uint8List originalImageBytes;
  final DesignTypographyModel typography;
  final DesignColorsModel colors;
  final AwesomeFilter selectedFilter;
  final ScrollController controller;

  final void Function(BuildContext context, int index, AwesomeFilter filter) onFilterSelected;

  static const double kFilterSelectorSize = 161.0;

  @override
  Widget build(BuildContext context) {
    // Put the none filter at the start of the list
    final List<AwesomeFilter> sortedFiltered = {AwesomeFilter.None, ...allSupportedFilters.where((element) => element.name != AwesomeFilter.None.name)}.toList();
    return SizedBox(
      height: kFilterSelectorSize,
      width: mediaQueryData.size.width,
      child: ListView.separated(
        controller: controller,
        scrollDirection: Axis.horizontal,
        separatorBuilder: (_, __) => const SizedBox(width: kPaddingMedium),
        padding: const EdgeInsets.symmetric(horizontal: kPaddingMedium),
        itemCount: sortedFiltered.length,
        itemBuilder: (context, index) {
          final AwesomeFilter filter = sortedFiltered[index];
          Color borderColor = colors.white;

          if (selectedFilter.name != filter.name) {
            borderColor = borderColor.withOpacity(0.5);
          }

          return Column(
            children: <Widget>[
              PositiveTapBehaviour(
                onTap: (context) => onFilterSelected(context, index, filter),
                child: AnimatedContainer(
                  duration: kAnimationDurationRegular,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(120),
                    border: Border.all(color: borderColor, width: 1),
                  ),
                  padding: const EdgeInsets.all(4.0),
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(120),
                    child: ColorFiltered(
                      colorFilter: ColorFilter.matrix(filter.matrix),
                      child: Image.memory(
                        originalImageBytes,
                        height: 120,
                        width: 120,
                        fit: BoxFit.cover,
                      ),
                    ),
                  ),
                ),
              ),
              const SizedBox(height: kPaddingSmall),
              Text(
                filter.name.pascalToSpaced,
                maxLines: 1,
                textAlign: TextAlign.center,
                overflow: TextOverflow.ellipsis,
                style: typography.styleBody.copyWith(color: colors.white),
              ),
            ],
          );
        },
      ),
    );
  }
}

class PositiveGalleryPreview extends StatefulWidget {
  const PositiveGalleryPreview({
    super.key,
    required this.imagePreviewSize,
    required this.colors,
    required this.editedImageBytes,
    required this.currentFilter,
    this.showEditingHint = true,
  });

  final double imagePreviewSize;
  final DesignColorsModel colors;

  final Uint8List editedImageBytes;
  final AwesomeFilter currentFilter;

  final bool showEditingHint;

  @override
  State<PositiveGalleryPreview> createState() => _PositiveGalleryPreviewState();
}

class _PositiveGalleryPreviewState extends State<PositiveGalleryPreview> {
  bool isShowingPinchRotateHint = false;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback(onFirstRender);
  }

  void onFirstRender(Duration _) {
    if (!widget.showEditingHint) return;
    togglePinchRotateHint();
  }

  void togglePinchRotateHint() async {
    setStateIfMounted(callback: () => isShowingPinchRotateHint = !isShowingPinchRotateHint);
    await Future.delayed(kAnimationDurationHintPreview);
    setStateIfMounted(callback: () => isShowingPinchRotateHint = !isShowingPinchRotateHint);
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      height: widget.imagePreviewSize,
      width: widget.imagePreviewSize,
      color: widget.colors.colorGray8,
      child: Stack(
        children: <Widget>[
          Align(child: PositiveLoadingIndicator(color: widget.colors.white)),
          Positioned.fill(
            child: AnimatedOpacity(
              duration: kAnimationDurationRegular,
              opacity: widget.editedImageBytes.isEmpty ? 0 : 1,
              child: ColorFiltered(
                colorFilter: ColorFilter.matrix(widget.currentFilter.matrix),
                child: Image.memory(
                  widget.editedImageBytes,
                  height: widget.imagePreviewSize,
                  width: widget.imagePreviewSize,
                  fit: BoxFit.cover,
                ),
              ),
            ),
          ),
          Align(
            alignment: Alignment.center,
            child: PositiveToastHint(
              isShowing: isShowingPinchRotateHint,
              text: 'Pinch and rotate with 2 fingers to resize and position your photo',
            ),
          ),
        ],
      ),
    );
  }
}
