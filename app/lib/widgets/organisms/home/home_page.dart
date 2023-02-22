import 'package:app/widgets/molecules/layouts/positive_basic_sliver_list.dart';
import 'package:app/widgets/molecules/scaffolds/positive_scaffold.dart';
import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

class HomePage extends ConsumerWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return const PositiveScaffold(
      children: <Widget>[
        PositiveBasicSliverList(
          children: <Widget>[
            Text('Home Page!\nReset the app and delete your user to go again!'),
          ],
        ),
      ],
    );
  }
}
