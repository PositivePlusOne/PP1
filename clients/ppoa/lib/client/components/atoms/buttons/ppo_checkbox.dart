import 'package:flutter/src/widgets/container.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:ppoa/business/state/design_system/models/design_system_brand.dart';
import 'package:ppoa/client/components/atoms/buttons/enumerations/ppo_checkbox_style.dart';

class PPOCheckbox extends StatefulWidget {
  const PPOCheckbox({
    required this.brand,
    required this.onCheckboxSelected,
    required this.tooltip,
    this.style = PPOCheckboxStyle.large,
    this.isChecked = true,
    this.isEnabled = true,
    super.key,
  });

  final DesignSystemBrand brand;
  final PPOCheckboxStyle style;

  final Future<void> Function() onCheckboxSelected;
  final bool isEnabled;
  final bool isChecked;

  final String tooltip;

  @override
  State<PPOCheckbox> createState() => _PPOCheckboxState();
}

class _PPOCheckboxState extends State<PPOCheckbox> {
  Future<void> _onCheckboxTapped() async {
    if (!mounted) {
      return;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container();
  }
}
