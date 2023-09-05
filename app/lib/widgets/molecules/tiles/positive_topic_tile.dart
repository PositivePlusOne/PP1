// Flutter imports:
import 'package:flutter/material.dart';

// Project imports:
import 'package:app/dtos/database/activities/tags.dart';
import 'package:app/extensions/color_extensions.dart';
import '../../../constants/design_constants.dart';
import '../../../dtos/system/design_colors_model.dart';
import '../../../dtos/system/design_typography_model.dart';

class PositiveTopicTile extends StatelessWidget {
  const PositiveTopicTile({
    super.key,
    required this.colors,
    required this.typography,
    required this.tag,
  });

  final DesignColorsModel colors;
  final DesignTypographyModel typography;
  final Tag tag;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(20.0),
        color: colors.white,
      ),
      padding: const EdgeInsets.all(kPaddingMedium),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Text(
            '#',
            style: typography.styleTopic.copyWith(
              color: colors.white.complimentTextColor.withOpacity(0.15),
            ),
          ),
          const SizedBox(height: kPaddingSmall),
          Text(
            tag.topic?.fallback ?? tag.fallback,
            overflow: TextOverflow.ellipsis,
            maxLines: 4,
            style: typography.styleTopic.copyWith(color: colors.white.complimentTextColor),
          ),
        ],
      ),
    );
  }
}
