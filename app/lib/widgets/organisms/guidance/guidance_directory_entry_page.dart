// Flutter imports:
import 'package:flutter/material.dart';

// Package imports:
import 'package:auto_route/auto_route.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:html2md/html2md.dart' as html2md;
import 'package:sliver_tools/sliver_tools.dart';
import 'package:unicons/unicons.dart';

// Project imports:
import 'package:app/constants/design_constants.dart';
import 'package:app/dtos/database/guidance/guidance_directory_entry.dart';
import 'package:app/dtos/system/design_colors_model.dart';
import 'package:app/dtos/system/design_typography_model.dart';
import 'package:app/extensions/profile_extensions.dart';
import 'package:app/extensions/string_extensions.dart';
import 'package:app/extensions/widget_extensions.dart';
import 'package:app/helpers/brand_helpers.dart';
import 'package:app/providers/system/cache_controller.dart';
import 'package:app/widgets/atoms/buttons/enumerations/positive_button_layout.dart';
import 'package:app/widgets/atoms/buttons/enumerations/positive_button_size.dart';
import 'package:app/widgets/atoms/buttons/enumerations/positive_button_style.dart';
import 'package:app/widgets/atoms/buttons/positive_button.dart';
import 'package:app/widgets/atoms/indicators/positive_profile_circular_indicator.dart';
import 'package:app/widgets/molecules/scaffolds/positive_scaffold.dart';
import 'package:app/widgets/organisms/guidance/guidance_entry_page.dart';
import '../../../providers/guidance/guidance_controller.dart';
import '../../../providers/profiles/profile_controller.dart';
import '../../../providers/system/design_controller.dart';
import '../../molecules/navigation/positive_navigation_bar.dart';

@RoutePage()
class GuidanceDirectoryEntryPage extends ConsumerWidget {
  const GuidanceDirectoryEntryPage({
    required this.guidanceEntryId,
    super.key,
  });

  final String guidanceEntryId;

  String searchHintText(GuidanceSection? gs) {
    switch (gs) {
      case GuidanceSection.guidance:
        return 'Search Guidance';
      case GuidanceSection.directory:
        return 'Search Directory';
      case GuidanceSection.appHelp:
        return 'Search Help';
      default:
        return 'Search';
    }
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final DesignColorsModel colors = ref.read(designControllerProvider.select((value) => value.colors));
    final DesignTypographyModel typography = ref.read(designControllerProvider.select((value) => value.typography));
    final GuidanceControllerState state = ref.watch(guidanceControllerProvider);
    final GuidanceController controller = ref.read(guidanceControllerProvider.notifier);
    final CacheController cacheController = ref.watch(cacheControllerProvider.notifier);
    final MediaQueryData mediaQuery = MediaQuery.of(context);

    final GuidanceDirectoryEntry guidanceEntry = cacheController.getFromCache(guidanceEntryId) ?? GuidanceDirectoryEntry.empty();
    final ProfileControllerState profileControllerState = ref.read(profileControllerProvider);
    final List<Widget> actions = [];

    if (profileControllerState.currentProfile != null) {
      actions.addAll(profileControllerState.currentProfile!.buildCommonProfilePageActions());
    }

    final String parsedMarkdown = html2md.convert(guidanceEntry.markdown);

    return Stack(
      children: [
        PositiveScaffold(
          isBusy: state.isBusy,
          bottomNavigationBar: PositiveNavigationBar(
            mediaQuery: mediaQuery,
            index: NavigationBarIndex.guidance,
          ),
          headingWidgets: [
            SliverPinnedHeader(
              child: GuidanceSearchBar(
                onSubmitted: controller.onSearch,
                onBackSelected: () => context.router.pop(),
                isEnabled: false,
                initialText: '',
                hintText: searchHintText(controller.guidanceSection),
              ),
            ),
            SliverPadding(
              padding: const EdgeInsets.only(left: kPaddingMedium, top: kPaddingMedium, right: kPaddingMedium),
              sliver: SliverList(
                delegate: SliverChildListDelegate(
                  <Widget>[
                    if (guidanceEntry.logoUrl.isNotEmpty) ...<Widget>[
                      Align(
                        alignment: Alignment.center,
                        child: PositiveProfileCircularIndicator(
                          imageOverridePath: guidanceEntry.logoUrl,
                          borderThickness: kBorderThicknessMedium,
                          backgroundColorOverride: colors.white,
                          size: kIconDirectoryHeader,
                          fit: BoxFit.cover,
                          isEnabled: false,
                        ),
                      ),
                      const SizedBox(height: kPaddingMedium),
                    ],
                    Text(
                      guidanceEntry.title,
                      textAlign: TextAlign.center,
                      style: typography.styleHeroMedium.copyWith(color: colors.black),
                    ),
                    const SizedBox(height: kPaddingMedium),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: <Widget>[
                        PositiveButton(
                          colors: colors,
                          onTapped: () {},
                          isDisabled: true,
                          label: 'View Profile',
                          icon: UniconsLine.user_circle,
                          forceIconPadding: true,
                          style: PositiveButtonStyle.primary,
                          size: PositiveButtonSize.medium,
                          layout: PositiveButtonLayout.iconRight,
                        ),
                        PositiveButton(
                          colors: colors,
                          onTapped: guidanceEntry.websiteUrl.attemptToLaunchURL,
                          label: 'View Website',
                          icon: UniconsLine.external_link_alt,
                          forceIconPadding: true,
                          isDisabled: guidanceEntry.websiteUrl.isEmpty,
                          primaryColor: colors.teal,
                          style: PositiveButtonStyle.primary,
                          size: PositiveButtonSize.medium,
                          layout: PositiveButtonLayout.iconRight,
                        ),
                      ],
                    ),
                    const SizedBox(height: kPaddingMedium),
                    Container(
                      padding: const EdgeInsets.all(kPaddingMedium),
                      decoration: BoxDecoration(
                        color: colors.white,
                        borderRadius: BorderRadius.circular(kBorderRadiusLarge),
                      ),
                      child: Column(
                        children: <Widget>[
                          if (guidanceEntry.place?.description.isNotEmpty ?? false) ...<Widget>[
                            Row(
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children: <Widget>[
                                Icon(UniconsLine.map_marker, color: colors.colorGray7, size: kIconSmall),
                                const SizedBox(width: kPaddingExtraSmall),
                                Expanded(
                                  child: SelectableText(
                                    guidanceEntry.place!.description,
                                    style: typography.styleSubtitleBold.copyWith(color: colors.colorGray7),
                                  ),
                                ),
                              ],
                            ),
                          ],
                          if (guidanceEntry.services.isNotEmpty) ...<Widget>[
                            Wrap(
                              spacing: kPaddingExtraSmall,
                              runSpacing: kPaddingExtraSmall,
                              children: <Widget>[
                                for (final GuidanceDirectoryEntryService service in guidanceEntry.services) ...<Widget>[
                                  Container(
                                    padding: const EdgeInsets.symmetric(horizontal: kPaddingSmall, vertical: kPaddingExtraSmall),
                                    margin: const EdgeInsets.only(right: kPaddingSmall),
                                    decoration: BoxDecoration(
                                      color: colors.colorGray1,
                                      borderRadius: BorderRadius.circular(kBorderRadiusInfinite),
                                    ),
                                    child: Text(
                                      GuidanceDirectoryEntryService.asLocale(service),
                                      style: typography.styleSubtextBold.copyWith(color: colors.colorGray7),
                                    ),
                                  ),
                                ],
                              ],
                            ),
                          ],
                        ].spaceWithVertical(kPaddingSmallMedium),
                      ),
                    ),
                    const SizedBox(height: kPaddingMedium),
                    buildMarkdownWidgetFromBody(parsedMarkdown),
                  ],
                ),
              ),
            ),
          ],
        ),
      ],
    );
  }
}
