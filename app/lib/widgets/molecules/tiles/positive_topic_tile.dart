// Flutter imports:
import 'package:flutter/material.dart';

// Project imports:
import 'package:app/dtos/database/activities/tags.dart';
import 'package:app/extensions/color_extensions.dart';
import 'package:app/widgets/behaviours/positive_tap_behaviour.dart';
import '../../../constants/design_constants.dart';
import '../../../dtos/system/design_colors_model.dart';
import '../../../dtos/system/design_typography_model.dart';

class PositiveTopicTile extends StatelessWidget {
  const PositiveTopicTile({
    super.key,
    required this.colors,
    required this.typography,
    required this.tag,
    required this.onTap,
    this.isDense = false,
  });

  final DesignColorsModel colors;
  final DesignTypographyModel typography;
  final Tag tag;

  final void Function(BuildContext context) onTap;
  final bool isDense;

  @override
  Widget build(BuildContext context) {
    final List<Widget> nonDenseChildren = <Widget>[
      Text(
        '#',
        style: typography.styleTopic.copyWith(
          color: colors.white.complimentTextColor.withOpacity(0.15),
        ),
      ),
      const SizedBox(height: kPaddingSmall),
      Text(
        tag.topic == null || tag.topic?.fallback.isEmpty == true ? tag.fallback : tag.topic!.fallback,
        overflow: TextOverflow.ellipsis,
        maxLines: 4,
        style: typography.styleTopic.copyWith(color: colors.white.complimentTextColor),
      ),
    ];

    final List<Widget> denseChildren = <Widget>[
      Row(
        mainAxisSize: MainAxisSize.min,
        children: <Widget>[
          Text(
            '#',
            style: typography.styleTopic.copyWith(
              color: colors.white.complimentTextColor,
            ),
          ),
          const SizedBox(width: kPaddingExtraSmall),
          Expanded(
            child: Text(
              tag.topic == null || tag.topic?.fallback.isEmpty == true ? tag.fallback : tag.topic!.fallback,
              overflow: TextOverflow.ellipsis,
              maxLines: 4,
              style: typography.styleTopic.copyWith(color: colors.white.complimentTextColor),
            ),
          ),
        ],
      ),
    ];

    return PositiveTapBehaviour(
      onTap: onTap,
      child: Container(
        width: double.infinity,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(20.0),
          color: colors.white,
        ),
        padding: EdgeInsets.all(isDense ? kPaddingSmall : kPaddingMedium),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: isDense ? denseChildren : nonDenseChildren,
        ),
      ),
    );
  }
}
