import 'package:app/extensions/color_extensions.dart';
import 'package:flutter/material.dart';

import '../../../constants/design_constants.dart';
import '../../../dtos/database/content/topic.dart';
import '../../../dtos/system/design_colors_model.dart';
import '../../../dtos/system/design_typography_model.dart';

class PositiveTopicTile extends StatelessWidget {
  const PositiveTopicTile({
    super.key,
    required this.colors,
    required this.typography,
    required this.topic,
  });

  final DesignColorsModel colors;
  final DesignTypographyModel typography;
  final Topic topic;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(20.0),
        color: colors.yellow,
      ),
      padding: const EdgeInsets.all(kPaddingMedium),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Text(
            '#',
            style: typography.styleTopic.copyWith(
              color: colors.yellow.complimentTextColor.withOpacity(0.15),
            ),
          ),
          const SizedBox(height: kPaddingSmall),
          Text(
            topic.name,
            overflow: TextOverflow.ellipsis,
            maxLines: 2,
            style: typography.styleTopic.copyWith(color: colors.yellow.complimentTextColor),
          ),
        ],
      ),
    );
  }
}
