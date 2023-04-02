// Flutter imports:
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';

// Package imports:
import 'package:hooks_riverpod/hooks_riverpod.dart';

// Project imports:
import 'package:app/dtos/system/design_typography_model.dart';
import 'package:app/providers/system/design_controller.dart';

// Project imports:

class PositiveRichText extends ConsumerWidget {
  const PositiveRichText({
    required this.body,
    this.actions = const <String>[],
    this.onActionTapped,
    this.style,
    this.padding = EdgeInsets.zero,
    this.textColor = Colors.black,
    this.actionColor = Colors.blue,
    super.key,
  });

  final String body;
  final List<String> actions;
  final Function(int index)? onActionTapped;
  final TextStyle? style;
  final EdgeInsets padding;
  final Color textColor;
  final Color actionColor;

  void handleTap(BuildContext context, int index) {
    if (onActionTapped != null) {
      onActionTapped!(index);
    }
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final DesignTypographyModel typography = ref.watch(designControllerProvider.select((value) => value.typography));

    final List<TextSpan> spans = <TextSpan>[];
    final TextStyle actualBaseStyle = style ?? typography.styleSubtitle.copyWith(color: textColor);
    final TextStyle actualBaseLinkStyle = style ?? actualBaseStyle.copyWith(fontWeight: FontWeight.w600);

    if (actions.isNotEmpty) {
      final List<String> parts = body.split('{}');
      if (parts.length - 1 != actions.length) {
        throw Exception('Actions missing for text spans');
      }

      for (int i = 0; i != parts.length; i++) {
        final String part = parts[i];
        final TextSpan mainSpan = TextSpan(text: part, style: actualBaseStyle);
        spans.add(mainSpan);

        if (i == actions.length) {
          continue;
        }

        final String action = actions[i];
        final TextSpan actionSpan = TextSpan(
          text: action,
          style: actualBaseLinkStyle.copyWith(color: actionColor),
          recognizer: TapGestureRecognizer()..onTap = () => handleTap(context, i),
        );

        spans.add(actionSpan);
      }
    }

    if (actions.isEmpty) {
      final TextSpan mainSpan = TextSpan(text: body);
      spans.add(mainSpan);
    }

    return Container(
      padding: padding,
      child: RichText(
        text: TextSpan(
          style: actualBaseStyle,
          children: spans,
        ),
      ),
    );
  }
}
