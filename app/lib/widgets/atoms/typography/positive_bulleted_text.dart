// Flutter imports:
import 'package:flutter/material.dart';

class PositiveBulletedText extends StatelessWidget {
  const PositiveBulletedText({
    required this.text,
    super.key,
  });

  final Text text;

  @override
  Widget build(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        Text('• ', style: text.style),
        Flexible(child: text),
      ],
    );
  }
}
