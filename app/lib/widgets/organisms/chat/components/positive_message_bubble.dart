import 'package:flutter/widgets.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:stream_chat_flutter/stream_chat_flutter.dart';

class PositiveMessageBubble extends ConsumerWidget {
  const PositiveMessageBubble({
    required this.message,
  });

  final Message message;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Container();
  }
}
