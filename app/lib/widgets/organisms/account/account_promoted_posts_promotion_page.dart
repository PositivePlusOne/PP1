// Flutter imports:

// Flutter imports:
import 'package:app/dtos/database/profile/profile.dart';
import 'package:app/extensions/widget_extensions.dart';
import 'package:app/providers/profiles/profile_controller.dart';
import 'package:app/widgets/molecules/navigation/positive_app_bar.dart';
import 'package:app/widgets/molecules/navigation/positive_navigation_bar.dart';
import 'package:app/widgets/molecules/navigation/positive_tab_bar.dart';
import 'package:flutter/material.dart';

// Package imports:
import 'package:auto_route/auto_route.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

// Project imports:
import 'package:app/extensions/profile_extensions.dart';
import 'package:app/constants/design_constants.dart';
import 'package:app/dtos/system/design_colors_model.dart';
import 'package:app/dtos/system/design_typography_model.dart';
import 'package:app/extensions/string_extensions.dart';
import 'package:app/gen/app_router.dart';
import 'package:app/providers/user/account_form_controller.dart';
import 'package:app/widgets/atoms/buttons/enumerations/positive_button_layout.dart';
import 'package:app/widgets/atoms/buttons/enumerations/positive_button_style.dart';
import 'package:app/widgets/atoms/buttons/positive_back_button.dart';
import 'package:app/widgets/atoms/buttons/positive_button.dart';
import 'package:app/widgets/atoms/typography/positive_bulleted_text.dart';
import 'package:app/widgets/molecules/containers/positive_transparent_sheet.dart';
import 'package:app/widgets/molecules/input/positive_rich_text.dart';
import 'package:app/widgets/molecules/layouts/positive_basic_sliver_list.dart';
import 'package:app/widgets/molecules/scaffolds/positive_scaffold.dart';
import '../../../helpers/brand_helpers.dart';
import '../../../providers/system/design_controller.dart';

/// this is a page to show when the organisation does not have the ability to create any promotions - to promote
/// the use of promotions - basically an advert to get them to sign up and pay for promotions
@RoutePage()
class AccountPromotedPostsPromotionPage extends HookConsumerWidget {
  const AccountPromotedPostsPromotionPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final AppRouter appRouter = ref.read(appRouterProvider);
    final DesignColorsModel colors = ref.watch(designControllerProvider.select((value) => value.colors));
    final DesignTypographyModel typography = ref.watch(designControllerProvider.select((value) => value.typography));

    final Locale locale = Localizations.localeOf(context);
    final AppLocalizations localisations = AppLocalizations.of(context)!;
    final AccountFormControllerProvider provider = accountFormControllerProvider(locale);
    final AccountFormState state = ref.watch(provider);

    final Profile? currentProfile = ref.watch(profileControllerProvider.select((value) => value.currentProfile));
    final int activePromotionsCount = currentProfile?.activePromotionsCount ?? 0;
    final int availablePromotionsCount = currentProfile?.availablePromotionsCount ?? 0;
    final bool profileCanPromote = activePromotionsCount > 0 || availablePromotionsCount > 0;

    if (profileCanPromote) {
      return AccountPromotedPostsFeeds(
        colors: colors,
        typography: typography,
        localisations: localisations,
        isBusy: state.isBusy,
        activePromotionsCount: activePromotionsCount,
        availablePromotionsCount: availablePromotionsCount,
        currentProfile: currentProfile,
      );
    }

    return AccountPromotedPostsPlaceholder(
      colors: colors,
      typography: typography,
      localisations: localisations,
      isBusy: state.isBusy,
      appRouter: appRouter,
    );
  }
}

enum AccountPromotedPostsType {
  hub,
  chat,
}

class AccountPromotedPostsFeeds extends StatefulWidget {
  const AccountPromotedPostsFeeds({
    required this.colors,
    required this.typography,
    required this.localisations,
    required this.isBusy,
    required this.activePromotionsCount,
    required this.availablePromotionsCount,
    required this.currentProfile,
    super.key,
  });

  final DesignColorsModel colors;
  final DesignTypographyModel typography;
  final AppLocalizations localisations;

  final bool isBusy;
  final int activePromotionsCount;
  final int availablePromotionsCount;

  final Profile? currentProfile;

  @override
  State<AccountPromotedPostsFeeds> createState() => _AccountPromotedPostsFeedsState();
}

class _AccountPromotedPostsFeedsState extends State<AccountPromotedPostsFeeds> {
  AccountPromotedPostsType _type = AccountPromotedPostsType.hub;
  AccountPromotedPostsType get type => _type;
  set type(AccountPromotedPostsType value) {
    if (_type == value) {
      return;
    }

    _type = value;
    setStateIfMounted();
  }

  @override
  Widget build(BuildContext context) {
    final List<Widget> actions = [];

    final String currentProfileId = widget.currentProfile?.flMeta?.id ?? '';
    if (currentProfileId.isNotEmpty) {
      actions.addAll(widget.currentProfile?.buildCommonProfilePageActions() ?? []);
    }

    final MediaQueryData mediaQueryData = MediaQuery.of(context);

    final int remainingPromotions = (widget.availablePromotionsCount - widget.activePromotionsCount).clamp(0, widget.availablePromotionsCount);
    final int promotionKindIndex = type == AccountPromotedPostsType.hub ? 0 : 1;

    return PositiveScaffold(
      visibleComponents: PositiveScaffoldComponent.excludeFooterPadding,
      bottomNavigationBar: PositiveNavigationBar(
        mediaQuery: mediaQueryData,
        index: NavigationBarIndex.hub,
      ),
      headingWidgets: <Widget>[
        PositiveBasicSliverList(
          appBarTrailing: actions,
          appBarSpacing: kPaddingNone,
          children: <Widget>[
            Container(
              padding: const EdgeInsets.symmetric(horizontal: kPaddingMedium, vertical: kPaddingSmallMedium),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(kBorderRadiusInfinite),
                color: widget.colors.colorGray2,
              ),
              child: Row(
                children: <Widget>[
                  Text(
                    widget.localisations.page_account_promoted_posts_present_tooltip,
                    style: widget.typography.styleButtonBold.copyWith(color: widget.colors.black),
                  ),
                  const Spacer(),
                  const SizedBox(width: kPaddingMedium),
                  Text(
                    remainingPromotions.toString(),
                    style: widget.typography.styleButtonBold.copyWith(color: widget.colors.black),
                  ),
                ],
              ),
            ),
            const SizedBox(height: kPaddingSmall),
            PositiveTabBar(
              index: promotionKindIndex,
              onTapped: (index) => type = index == 0 ? AccountPromotedPostsType.hub : AccountPromotedPostsType.chat,
              margin: EdgeInsets.zero,
              tabColours: <Color>[
                widget.colors.green,
                widget.colors.yellow,
              ],
              tabs: <String>[
                widget.localisations.shared_promotion_type_hub,
                widget.localisations.shared_promotion_type_chat,
              ],
            ),
            const SizedBox(height: kPaddingSmall),
          ],
        ),
      ],
    );
  }
}

class AccountPromotedPostsPlaceholder extends StatelessWidget {
  const AccountPromotedPostsPlaceholder({
    required this.colors,
    required this.typography,
    required this.localisations,
    required this.isBusy,
    required this.appRouter,
    super.key,
  });

  final DesignColorsModel colors;
  final DesignTypographyModel typography;
  final AppLocalizations localisations;
  final bool isBusy;
  final AppRouter appRouter;

  List<Widget> _bullets(
    List<String> points,
    DesignColorsModel colors,
    DesignTypographyModel typography,
  ) =>
      points
          .map((e) => Padding(
                padding: const EdgeInsets.only(
                  bottom: kPaddingMedium,
                  left: kPaddingMedium,
                ),
                child: PositiveBulletedText(
                  text: Text(
                    e,
                    style: typography.styleBody.copyWith(color: colors.black),
                  ),
                ),
              ))
          .toList();

  @override
  Widget build(BuildContext context) {
    return PositiveScaffold(
      decorations: buildType5ScaffoldDecorations(colors),
      headingWidgets: <Widget>[
        PositiveBasicSliverList(
          children: <Widget>[
            PositiveBackButton(isDisabled: isBusy),
            const SizedBox(height: kPaddingMedium),
            Text(
              localisations.page_account_promote_posts_title,
              style: typography.styleHero.copyWith(color: colors.black),
            ),
            const SizedBox(height: kPaddingMedium),
            Text(
              localisations.page_account_promote_posts_body,
              style: typography.styleBody.copyWith(color: colors.black),
            ),
            const SizedBox(height: kPaddingMedium),
            PositiveTransparentSheet(
              children: [
                ..._bullets(
                  [
                    localisations.page_account_promote_posts_body_one,
                    localisations.page_account_promote_posts_body_two,
                    localisations.page_account_promote_posts_body_three,
                    localisations.page_account_promote_posts_body_four,
                    localisations.page_account_promote_posts_body_five,
                    localisations.page_account_promote_posts_body_six,
                  ],
                  colors,
                  typography,
                ),
                PositiveRichText(
                  body: "To get started, drop us a line at\n{}",
                  onActionTapped: (_) => 'mailto:promote@positiveplusone.com'.attemptToLaunchURL(),
                  actionColor: colors.linkBlue,
                  actions: const <String>["promote@positiveplusone.com"],
                ),
              ],
            ),
          ],
        ),
      ],
      footerWidgets: <Widget>[
        PositiveButton(
          colors: colors,
          onTapped: () => appRouter.pop(),
          label: localisations.page_account_close_button,
          layout: PositiveButtonLayout.textOnly,
          style: PositiveButtonStyle.primary,
          primaryColor: colors.white,
        ),
      ],
    );
  }
}
