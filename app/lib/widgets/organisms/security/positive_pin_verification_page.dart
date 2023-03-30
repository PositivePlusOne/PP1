import 'package:app/widgets/molecules/scaffolds/positive_scaffold.dart';
import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

class PositivePinVerificationPage extends ConsumerWidget {
  const PositivePinVerificationPage({
    super.key,
    required this.nextPage,
  });

  final PageRouteInfo nextPage;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return PositiveScaffold();
  }
}
