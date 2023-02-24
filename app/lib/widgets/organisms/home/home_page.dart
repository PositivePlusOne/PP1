import 'package:app/dtos/system/design_colors_model.dart';
import 'package:app/providers/system/design_controller.dart';
import 'package:app/services/third_party.dart';
import 'package:app/widgets/atoms/buttons/enumerations/positive_button_layout.dart';
import 'package:app/widgets/atoms/buttons/enumerations/positive_button_size.dart';
import 'package:app/widgets/atoms/buttons/enumerations/positive_button_style.dart';
import 'package:app/widgets/molecules/scaffolds/positive_scaffold.dart';
import 'package:firebase_crashlytics/firebase_crashlytics.dart';
import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:unicons/unicons.dart';

import '../../atoms/buttons/positive_button.dart';
import '../../atoms/buttons/positive_close_button.dart';
import '../../molecules/navigation/positive_app_bar.dart';
import '../../molecules/navigation/positive_app_bar_content.dart';

class HomePage extends ConsumerWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final DesignColorsModel colors = ref.watch(designControllerProvider.select((value) => value.colors));
    final FirebaseCrashlytics crashlytics = ref.watch(firebaseCrashlyticsProvider);

    final MediaQueryData mediaQueryData = MediaQuery.of(context);

    return PositiveScaffold(
      appBar: PositiveAppBar(
        applyLeadingandTrailingPadding: true,
        safeAreaQueryData: mediaQueryData,
        foregroundColor: colors.black,
        backgroundColor: colors.pink,
        trailing: <Widget>[
          PositiveButton(
            colors: colors,
            primaryColor: colors.black,
            style: PositiveButtonStyle.outline,
            layout: PositiveButtonLayout.iconOnly,
            icon: UniconsLine.bell,
            size: PositiveButtonSize.medium,
            onTapped: () async {},
          ),
          PositiveButton(
            colors: colors,
            primaryColor: colors.black,
            style: PositiveButtonStyle.outline,
            layout: PositiveButtonLayout.iconOnly,
            icon: UniconsLine.user,
            size: PositiveButtonSize.medium,
            onTapped: () async {},
          ),
        ],
      ),
      children: <Widget>[
        SliverToBoxAdapter(
          child: PositiveAppBarContent(
            backgroundColor: colors.pink,
          ),
        ),
      ],
    );
  }
}
