// Flutter imports:
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

// Package imports:
import 'package:hooks_riverpod/hooks_riverpod.dart';

// Project imports:
import 'package:app/constants/design_constants.dart';
import 'package:app/dtos/system/design_colors_model.dart';
import 'package:app/dtos/system/design_typography_model.dart';
import '../../../providers/system/design_controller.dart';
import '../../behaviours/positive_custom_color_handle.dart';

// TODO(ryan): Move a lot of properties to constants and domain models
class PositivePinEntry extends ConsumerStatefulWidget implements PreferredSizeWidget {
  const PositivePinEntry({
    required this.pinLength,
    required this.onPinChanged,
    required this.tintColor,
    this.isEnabled = true,
    this.autofocus = true,
    super.key,
  });

  final int pinLength;
  final void Function(String pin) onPinChanged;

  final Color tintColor;
  final bool isEnabled;
  final bool autofocus;

  @override
  PositivePinEntryState createState() => PositivePinEntryState();

  @override
  Size get preferredSize => Size(((45.0 * pinLength) + pinLength > 1 ? (kPaddingExtraSmall * pinLength - 1) : 0).toDouble(), 45);
}

class PositivePinEntryState extends ConsumerState<PositivePinEntry> {
  late final TextEditingController _textEditingController;
  late final FocusNode _focusNode;

  String pin = '';

  @override
  void initState() {
    super.initState();

    _focusNode = FocusNode();

    _textEditingController = TextEditingController();
    _textEditingController.addListener(onTextControllerChanged);
  }

  @override
  void dispose() {
    _textEditingController.removeListener(onTextControllerChanged);
    super.dispose();
  }

  void onTextControllerChanged() {
    if (!mounted) {
      return;
    }

    if (_textEditingController.text.length > widget.pinLength) {
      _textEditingController.text = _textEditingController.text.substring(0, widget.pinLength);
    }

    if (pin != _textEditingController.text) {
      pin = _textEditingController.text;

      widget.onPinChanged(pin);

      // Remove focus if the pin is complete
      if (pin.length == widget.pinLength) {
        _focusNode.unfocus();
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final DesignColorsModel colors = ref.watch(designControllerProvider.select((value) => value.colors));
    final DesignTypographyModel typography = ref.watch(designControllerProvider.select((value) => value.typography));

    return SizedBox(
      width: double.infinity,
      height: widget.preferredSize.height,
      child: Stack(
        children: <Widget>[
          Positioned.fill(
            child: FittedBox(
              fit: BoxFit.scaleDown,
              child: IgnorePointer(
                ignoring: true,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: <Widget>[
                    for (int i = 0; i != widget.pinLength; i++) ...<Widget>[
                      if (pin.length <= i) ...<Widget>[
                        SizedBox(
                          width: 45,
                          height: 45,
                          child: Center(
                            child: Container(
                              height: 5.0,
                              width: 5.0,
                              decoration: BoxDecoration(
                                color: colors.black.withOpacity(0.2),
                                borderRadius: BorderRadius.circular(5.0),
                              ),
                            ),
                          ),
                        ),
                      ] else ...<Widget>[
                        SizedBox(
                          width: 45,
                          height: 45,
                          child: FittedBox(
                            fit: BoxFit.contain,
                            child: Text(
                              pin.characters.elementAt(i),
                              style: typography.styleHero.copyWith(color: widget.tintColor),
                            ),
                          ),
                        ),
                      ],
                      if (i != widget.pinLength - 1) ...<Widget>[
                        const SizedBox(width: kPaddingExtraSmall),
                      ],
                    ],
                  ],
                ),
              ),
            ),
          ),
          Positioned.fill(
            child: TextFormField(
              autofocus: widget.autofocus,
              selectionControls: CustomColorSelectionHandle(Colors.transparent),
              enabled: widget.isEnabled,
              keyboardType: TextInputType.number,
              controller: _textEditingController,
              focusNode: _focusNode,
              style: const TextStyle(
                color: Colors.transparent,
                backgroundColor: Colors.transparent,
                decorationColor: Colors.transparent,
              ),
              inputFormatters: [FilteringTextInputFormatter.digitsOnly],
              decoration: const InputDecoration.collapsed(
                hintText: "",
                fillColor: Colors.transparent,
                hoverColor: Colors.transparent,
                focusColor: Colors.transparent,
              ),
              obscureText: true,
              obscuringCharacter: " ",
              showCursor: false,
            ),
          ),
        ],
      ),
    );
  }
}
