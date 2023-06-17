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

    // return showC<T?>(
    //   context: context,
    //   title: Text(title),
    //   bottomSheetColor: colors.white,
    //   barrierColor: colors.colorGray1,
    //   cancelAction: CancelAction(
    //     title: Text(localizations.shared_actions_cancel),
    //     onPressed: (context) => Navigator.of(context).pop(),
    //   ),
    //   actions: <BottomSheetAction>[
    //     ...values.map(
    //       (value) => BottomSheetAction(
    //         title: Text(valueStringBuilder?.call(value) ?? value.toString()),
    //         onPressed: (context) async => Navigator.of(context).pop(),
    //       ),
    //     ),
    //   ],
    // );
  }
}
