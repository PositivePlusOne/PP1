// Flutter imports:
import 'package:flutter/material.dart';

// Package imports:
import 'package:hooks_riverpod/hooks_riverpod.dart';

// Project imports:
import 'package:ppoa/business/services/service_mixin.dart';
import 'package:ppoa/business/state/design_system/models/design_system_brand.dart';
import 'package:ppoa/client/components/atoms/page_indicator/ppo_page_indicator.dart';

class PPOPageIndicatorTestPage extends StatefulHookConsumerWidget {
  const PPOPageIndicatorTestPage({
    this.initialPage = 0,
    super.key,
  });

  final int initialPage;

  @override
  ConsumerState<ConsumerStatefulWidget> createState() => _PPOPageIndicatorTestPageState();
}

class _PPOPageIndicatorTestPageState extends ConsumerState<PPOPageIndicatorTestPage> with ServiceMixin, SingleTickerProviderStateMixin {
  late AnimationController animationController;
  late Animation<double> animation;

  @override
  void initState() {
    //TODO: standarise duration
    animationController = AnimationController(vsync: this, duration: const Duration(seconds: 3));
    animation = Tween<double>(begin: 0.0, end: 5.0).animate(animationController);
    animationController.addListener(() {
      if (animationController.isCompleted) {
        animationController.repeat();
      }
      if (!mounted) {
        return;
      }
      setState(() {});
    });
    animationController.forward();
    super.initState();
  }

  @override
  void dispose() {
    animationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final DesignSystemBrand brand = ref.watch(stateProvider.select((value) => value.designSystem.brand));

    return Scaffold(
      appBar: AppBar(
        backgroundColor: brand.colors.purple,
        title: const Text('Page Indicators'),
      ),
      body: ListView(
        controller: ScrollController(),
        padding: const EdgeInsets.symmetric(horizontal: 10.0),
        children: [
          const SizedBox(
            height: 10.0,
          ),
          Align(
            alignment: Alignment.center,
            child: PPOPageIndicator(
              currentPage: animation.value,
              pagesNum: 5,
              branding: brand,
            ),
          ),
        ],
      ),
    );
  }
}
