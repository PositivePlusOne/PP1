// Flutter imports:
import 'package:flutter/material.dart';

// Package imports:
import 'package:adaptive_dialog/adaptive_dialog.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class PositiveModalDropdown {
  static Future<T?> show<T>(
    BuildContext context, {
    String title = '',
    required List<T> values,
    T? initialValue,
    String Function(dynamic value)? valueStringBuilder,
  }) async {
    final AppLocalizations localizations = AppLocalizations.of(context)!;

    return showConfirmationDialog(
      context: context,
      title: title,
      style: AdaptiveStyle.adaptive,
      okLabel: localizations.shared_actions_confirm,
      fullyCapitalizedForMaterial: true,
      actions: <AlertDialogAction<T>>[
        ...values.map(
          (value) => AlertDialogAction<T>(
            label: valueStringBuilder?.call(value) ?? value.toString(),
            key: value,
          ),
        ),
      ],
    );
  }
}
