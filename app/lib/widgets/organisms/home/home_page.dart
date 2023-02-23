import 'package:app/constants/design_constants.dart';
import 'package:app/dtos/system/design_colors_model.dart';
import 'package:app/providers/system/design_controller.dart';
import 'package:app/services/third_party.dart';
import 'package:app/widgets/atoms/buttons/positive_button.dart';
import 'package:app/widgets/molecules/layouts/positive_basic_sliver_list.dart';
import 'package:app/widgets/molecules/scaffolds/positive_scaffold.dart';
import 'package:firebase_crashlytics/firebase_crashlytics.dart';
import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

class HomePage extends ConsumerWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final DesignColorsModel colors = ref.watch(designControllerProvider.select((value) => value.colors));
    final FirebaseCrashlytics crashlytics = ref.watch(firebaseCrashlyticsProvider);

    return PositiveScaffold(
      children: <Widget>[
        PositiveBasicSliverList(
          children: <Widget>[
            const Text('Home Page!\nReset the app and delete your user to go again!'),
            const SizedBox(height: kPaddingLarge),
            PositiveButton(
              label: 'Test exception',
              colors: colors,
              onTapped: () async {
                crashlytics.recordError("Mute this channel", StackTrace.current, printDetails: true, fatal: true);
              },
            ),
          ],
        ),
      ],
    );
  }
}
