// Flutter imports:
import 'package:flutter/material.dart';

// Package imports:
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:ppoa/client/components/atoms/buttons/enumerations/ppo_button_size.dart';
import 'package:unicons/unicons.dart';

// Project imports:
import 'package:ppoa/business/services/service_mixin.dart';
import 'package:ppoa/business/state/design_system/models/design_system_brand.dart';
import 'enumerations/ppo_button_layout.dart';
import 'enumerations/ppo_button_style.dart';
import 'ppo_button.dart';

class PPOCloseButton extends HookConsumerWidget with ServiceMixin {
  const PPOCloseButton({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final DesignSystemBrand branding = ref.watch(stateProvider.select((value) => value.designSystem.brand));
    final AppLocalizations localizations = AppLocalizations.of(context)!;

    return PPOButton(
      brand: branding,
      onTapped: () async => router.removeLast(),
      style: PPOButtonStyle.primary,
      icon: UniconsLine.multiply,
      size: PPOButtonSize.medium,
      isActive: true,
      layout: PPOButtonLayout.iconOnly,
      tooltip: localizations.shared_actions_close,
      label: '',
    );
  }
}
