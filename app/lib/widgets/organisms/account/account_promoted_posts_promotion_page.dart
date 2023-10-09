// Flutter imports:

import 'package:app/dtos/system/design_colors_model.dart';
import 'package:app/dtos/system/design_typography_model.dart';
import 'package:app/extensions/string_extensions.dart';
import 'package:app/gen/app_router.dart';
import 'package:app/widgets/atoms/buttons/enumerations/positive_button_layout.dart';
import 'package:app/widgets/atoms/buttons/enumerations/positive_button_style.dart';
import 'package:app/widgets/atoms/buttons/positive_back_button.dart';
import 'package:app/widgets/atoms/buttons/positive_button.dart';
import 'package:app/widgets/atoms/typography/positive_bulleted_text.dart';
import 'package:app/widgets/molecules/containers/positive_transparent_sheet.dart';
import 'package:app/widgets/molecules/input/positive_rich_text.dart';
import 'package:app/widgets/molecules/layouts/positive_basic_sliver_list.dart';
import 'package:app/widgets/molecules/scaffolds/positive_scaffold.dart';
import 'package:flutter/material.dart';

// Package imports:
import 'package:auto_route/auto_route.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

// Project imports:
import 'package:app/constants/design_constants.dart';
import '../../../providers/system/design_controller.dart';
import 'package:app/providers/user/account_form_controller.dart';
import '../../../helpers/brand_helpers.dart';

/// this is a page to show when the organisation does not have the ability to create any promotions - to promote
/// the use of promotions - basically an advert to get them to sign up and pay for promotions
@RoutePage()
class AccountPromotedPostsPromotionPage extends HookConsumerWidget {
  const AccountPromotedPostsPromotionPage({super.key});

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
  Widget build(BuildContext context, WidgetRef ref) {
    final AppRouter appRouter = ref.read(appRouterProvider);
    final DesignColorsModel colors = ref.watch(designControllerProvider.select((value) => value.colors));
    final DesignTypographyModel typography = ref.watch(designControllerProvider.select((value) => value.typography));

    final Locale locale = Localizations.localeOf(context);
    final AppLocalizations localisations = AppLocalizations.of(context)!;
    final AccountFormControllerProvider provider = accountFormControllerProvider(locale);
    final AccountFormState state = ref.watch(provider);

    return PositiveScaffold(
      decorations: buildType5ScaffoldDecorations(colors),
      headingWidgets: <Widget>[
        PositiveBasicSliverList(
          children: <Widget>[
            PositiveBackButton(isDisabled: state.isBusy),
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
