import 'package:app/dtos/database/profile/profile.dart';
import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:stream_chat_flutter/stream_chat_flutter.dart';

class PositiveSelectableChannelTile extends ConsumerWidget {
  const PositiveSelectableChannelTile({
    this.channel,
    this.isSelected,
    this.onTap,
    this.isEnabled = true,
    this.includeChannelInformation = false,
    super.key,
  });

  final Channel? channel;
  final bool? isSelected;

  final Future<void> Function()? onTap;
  final bool isEnabled;

  final bool includeChannelInformation;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Container();
  }
}
