// Flutter imports:
import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';

// Package imports:
import 'package:hooks_riverpod/hooks_riverpod.dart';

// Project imports:
import 'package:app/dtos/system/design_colors_model.dart';
import 'package:app/providers/system/design_controller.dart';
import 'package:app/widgets/atoms/buttons/positive_close_button.dart';
import 'package:app/widgets/molecules/layouts/positive_basic_sliver_list.dart';
import '../../../molecules/scaffolds/positive_scaffold.dart';

@RoutePage()
class ProfileImageDialogPage extends ConsumerWidget {
  const ProfileImageDialogPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final DesignColorsModel colors = ref.watch(designControllerProvider.select((value) => value.colors));

    return PositiveScaffold(
      backgroundColor: colors.black,
      headingWidgets: <Widget>[
        PositiveBasicSliverList(
          backgroundColor: colors.black,
          appBarTrailing: const <Widget>[
            PositiveCloseButton(),
          ],
        ),
      ],
    );
  }
}
