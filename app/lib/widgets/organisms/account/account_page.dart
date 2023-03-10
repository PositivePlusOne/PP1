import 'package:app/dtos/system/design_colors_model.dart';
import 'package:app/dtos/system/design_typography_model.dart';
import 'package:app/providers/system/design_controller.dart';
import 'package:app/widgets/molecules/scaffolds/positive_scaffold.dart';
import 'package:app/widgets/organisms/account/vms/account_view_model.dart';
import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

class AccountPage extends ConsumerWidget {
  const AccountPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final AccountViewModel viewModel = ref.read(accountViewModelProvider.notifier);

    final DesignColorsModel designColorsModel = ref.read(designControllerProvider.select((value) => value.colors));
    final DesignTypographyModel designTypographyModel = ref.read(designControllerProvider.select((value) => value.typography));

    return PositiveScaffold();
  }
}
