// Flutter imports:
import 'package:app/widgets/molecules/scaffolds/positive_scaffold.dart';
import 'package:flutter/material.dart';

// Package imports:
import 'package:hooks_riverpod/hooks_riverpod.dart';

// Project imports:
import 'package:app/dtos/system/design_colors_model.dart';
import 'package:app/providers/system/design_controller.dart';
import 'package:app/widgets/atoms/buttons/positive_close_button.dart';
import 'package:app/widgets/molecules/layouts/positive_basic_sliver_list.dart';

class HintDialogPage extends ConsumerWidget {
  const HintDialogPage({
    super.key,
    required this.widgets,
  });

  final List<Widget> widgets;

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
          children: widgets,
        ),
      ],
    );
  }
}
