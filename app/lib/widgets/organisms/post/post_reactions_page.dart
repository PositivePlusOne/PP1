import 'package:app/dtos/database/activities/activities.dart';
import 'package:app/dtos/system/design_colors_model.dart';
import 'package:app/dtos/system/design_typography_model.dart';
import 'package:app/providers/system/design_controller.dart';
import 'package:app/widgets/atoms/buttons/positive_close_button.dart';
import 'package:app/widgets/atoms/buttons/positive_invisible_icon_button.dart';
import 'package:app/widgets/molecules/navigation/positive_app_bar.dart';
import 'package:app/widgets/molecules/scaffolds/positive_scaffold.dart';
import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

@RoutePage()
class PostReactionsPage extends StatefulHookConsumerWidget {
  const PostReactionsPage({
    required this.activity,
    required this.reactionType,
    super.key,
  });

  final Activity activity;
  final String reactionType;

  @override
  ConsumerState<PostReactionsPage> createState() => _PostReactionsPageState();
}

class _PostReactionsPageState extends ConsumerState<PostReactionsPage> {
  @override
  Widget build(BuildContext context) {
    final MediaQueryData mediaData = MediaQuery.of(context);
    final DesignTypographyModel typography = ref.read(designControllerProvider.select((value) => value.typography));
    final DesignColorsModel colors = ref.read(designControllerProvider.select((value) => value.colors));

    return PositiveScaffold(
      appBar: PositiveAppBar(
        safeAreaQueryData: mediaData,
        applyLeadingandTrailingPadding: true,
        leading: const PositiveCloseButton(),
        trailing: const <Widget>[
          PositiveInvisibleButton(),
        ],
        centerTitle: true,
        title: 'Liked by',
        titleStyle: typography.styleHeroMedium,
      ),
      headingWidgets: <Widget>[],
    );
  }
}
