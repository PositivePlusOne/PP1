// Flutter imports:
import 'package:flutter/material.dart';

// Package imports:
import 'package:hooks_riverpod/hooks_riverpod.dart';

// Project imports:
import 'package:ppoa/business/services/service_mixin.dart';
import 'package:ppoa/business/state/design_system/models/design_system_brand.dart';
import 'package:ppoa/client/components/atoms/page_indicator/ppo_page_indicator.dart';
import 'package:smooth_page_indicator/smooth_page_indicator.dart';

class PPOPageIndicatorTestView extends StatefulHookConsumerWidget {
  const PPOPageIndicatorTestView({
    this.initialPage = 0,
    super.key,
  });

  final int initialPage;

  @override
  ConsumerState<ConsumerStatefulWidget> createState() => _PPOPageIndicatorTestViewState();
}

class _PPOPageIndicatorTestViewState extends ConsumerState<PPOPageIndicatorTestView> with ServiceMixin, SingleTickerProviderStateMixin {
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
        backgroundColor: brand.colors.secondaryColor,
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
            child: SmoothIndicator(
              offset: animation.value,
              count: 5,
              effect: ScaleEffect(
                dotColor: Colors.black.withAlpha(50),
                activeDotColor: Colors.black,
                scale: 2.0,
                dotHeight: 5.0,
                dotWidth: 5.0,
                spacing: 10.0,
              ),
            ),
          ),
          // const SizedBox(
          //   height: 10.0,
          // ),
          // Align(
          //   alignment: Alignment.center,
          //   child: SmoothIndicator(
          //     offset: animation.value,
          //     count: 5,
          //     effect: const WormEffect(),
          //   ),
          // ),
          // const SizedBox(
          //   height: 10.0,
          // ),
          // Align(
          //   alignment: Alignment.center,
          //   child: SmoothIndicator(
          //     offset: animation.value,
          //     count: 5,
          //     effect: SwapEffect(),
          //   ),
          // ),
          // Align(
          //   alignment: Alignment.center,
          //   child: SmoothIndicator(
          //     offset: animation.value,
          //     count: 5,
          //     effect: const ColorTransitionEffect(),
          //   ),
          // ),
          // const SizedBox(
          //   height: 10.0,
          // ),
          // Align(
          //   alignment: Alignment.center,
          //   child: PPOPageIndicate(
          //     circleInactiveColour: Colors.grey,
          //     circleInactiveColourHighlight: Colors.white,
          //     circleInactiveColourShadow: Colors.black,
          //     circleActiveColour: Colors.blue,
          //     circleActiveColourHighlight: Colors.lightBlue,
          //     circleActiveColourShadow: Colors.blue[900]!,
          //     size: 15.0,
          //   ),
          // ),
        ],
      ),
    );
  }
}
