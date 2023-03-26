// Flutter imports:
import 'package:flutter/material.dart';

// Package imports:
import 'package:calendar_date_picker2/calendar_date_picker2.dart';

// Project imports:
import 'package:app/dtos/system/design_typography_model.dart';
import 'package:app/main.dart';
import 'package:app/providers/system/design_controller.dart';
import '../constants/design_constants.dart';
import '../dtos/system/design_colors_model.dart';

Future<DateTime?> showPositiveDatePickerDialog(
  BuildContext context, {
  DateTime? initialDate,
  DateTime? firstDate,
  DateTime? lastDate,
}) async {
  final DesignColorsModel colors = providerContainer.read(designControllerProvider.select((value) => value.colors));
  final List<DateTime?>? dates = await showCalendarDatePicker2Dialog(
    context: context,
    config: CalendarDatePicker2WithActionButtonsConfig(
      firstDate: firstDate ?? DateTime(1900),
      lastDate: lastDate ?? DateTime(2100),
      selectedDayHighlightColor: colors.purple,
    ),
    dialogSize: kDefaultDatePickerDialogSize,
    value: <DateTime>[
      initialDate ?? DateTime.now(),
    ],
  );

  if (dates?.any((element) => element != null) ?? false) {
    return dates?.firstWhere((element) => element != null);
  }

  return null;
}
