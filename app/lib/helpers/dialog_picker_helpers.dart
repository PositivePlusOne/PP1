// Flutter imports:
import 'package:app/dtos/system/design_typography_model.dart';
import 'package:app/widgets/atoms/buttons/enumerations/positive_button_layout.dart';
import 'package:app/widgets/atoms/buttons/enumerations/positive_button_size.dart';
import 'package:app/widgets/atoms/buttons/enumerations/positive_button_style.dart';
import 'package:app/widgets/atoms/buttons/positive_button.dart';
import 'package:app/widgets/molecules/dialogs/positive_dialog.dart';
import 'package:flutter/material.dart';

// Package imports:
import 'package:calendar_date_picker2/calendar_date_picker2.dart';

// Project imports:
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
  final DesignTypographyModel typography = providerContainer.read(designControllerProvider.select((value) => value.typography));
  final List<DateTime?>? dates = await showCalendarDatePicker2Dialog(
    context: context,
    config: CalendarDatePicker2WithActionButtonsConfig(
      firstDate: firstDate ?? DateTime(1900),
      lastDate: lastDate ?? DateTime(2100),
      selectedDayHighlightColor: colors.red,
      disabledDayTextStyle: typography.styleNotification.copyWith(color: colors.black),
      weekdayLabelTextStyle: typography.styleSubtextBold.copyWith(color: colors.black),
      selectedRangeDayTextStyle: typography.styleNotification.copyWith(color: colors.white),
      todayTextStyle: typography.styleNotification.copyWith(color: colors.black),
      controlsTextStyle: typography.styleNotification.copyWith(color: colors.black),
      yearTextStyle: typography.styleNotification.copyWith(color: colors.black),
      selectedYearTextStyle: typography.styleNotification.copyWith(color: colors.white),
      dayTextStyle: typography.styleNotification.copyWith(color: colors.black),
      selectedDayTextStyle: typography.styleNotification.copyWith(color: colors.white),
      buttonPadding: const EdgeInsets.symmetric(horizontal: kPaddingSmall),
      calendarViewMode: DatePickerMode.year,
      selectedRangeHighlightColor: colors.black,
      centerAlignModePicker: true,
      gapBetweenCalendarAndButtons: kPaddingNone,
      controlsHeight: kPaddingExtraLarge,
      cancelButton: IgnorePointer(
        ignoring: true,
        child: TextButton(
          onPressed: () => Navigator.of(context).pop(),
          child: Text(
            'CANCEL',
            style: typography.styleButtonRegular.copyWith(color: colors.black),
          ),
        ),
      ),
      okButton: IgnorePointer(
        ignoring: true,
        child: TextButton(
          onPressed: () => Navigator.of(context).pop(),
          child: Text(
            'OK',
            style: typography.styleButtonBold.copyWith(color: colors.black),
          ),
        ),
      ),
    ),
    dialogSize: kDefaultDatePickerDialogSize,
    dialogBackgroundColor: colors.white.withOpacity(PositiveDialog.kCalandarOpacity),
    value: <DateTime>[
      initialDate ?? DateTime.now(),
    ],
  );

  if (dates?.any((element) => element != null) ?? false) {
    return dates?.firstWhere((element) => element != null);
  }

  return null;
}
