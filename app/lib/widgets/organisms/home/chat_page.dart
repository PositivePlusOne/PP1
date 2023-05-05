// Flutter imports:
import 'package:app/constants/design_constants.dart';
import 'package:app/dtos/database/profile/profile.dart';
import 'package:app/dtos/system/design_colors_model.dart';
import 'package:app/providers/system/design_controller.dart';
import 'package:app/widgets/atoms/buttons/enumerations/positive_button_layout.dart';
import 'package:app/widgets/atoms/buttons/enumerations/positive_button_size.dart';
import 'package:app/widgets/atoms/buttons/enumerations/positive_button_style.dart';
import 'package:app/widgets/atoms/buttons/positive_button.dart';
import 'package:app/widgets/atoms/indicators/positive_profile_circular_indicator.dart';
import 'package:flutter/material.dart';

// Package imports:
import 'package:auto_route/auto_route.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:stream_chat_flutter/stream_chat_flutter.dart';
import 'package:unicons/unicons.dart';

// Project imports:
import '../../../dtos/system/design_typography_model.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'components/stream_chat_wrapper.dart';

@RoutePage()
class ChatPage extends ConsumerWidget with StreamChatWrapper {
  const ChatPage({super.key});

  @override
  Widget get child => this;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final DesignColorsModel colors = ref.watch(designControllerProvider.select((value) => value.colors));
    final DesignTypographyModel typography = ref.watch(designControllerProvider.select((value) => value.typography));
    final locale = AppLocalizations.of(context)!;
    return Theme(
      data: ThemeData(
        textSelectionTheme: TextSelectionThemeData(
          cursorColor: colors.black,
        ),
      ),
      child: StreamChatTheme(
        data: StreamChatThemeData(
          colorTheme: StreamColorTheme.light(
            borders: colors.colorGray2,
            appBg: colors.colorGray2,
          ),
          messageListViewTheme: StreamMessageListViewThemeData(backgroundColor: colors.colorGray1),
          messageInputTheme: StreamMessageInputThemeData(
            borderRadius: BorderRadius.circular(kBorderRadiusMassive),
            inputTextStyle: typography.styleButtonRegular.copyWith(color: colors.black),
            activeBorderGradient: LinearGradient(colors: [colors.colorGray2, colors.colorGray2]),
            idleBorderGradient: LinearGradient(colors: [colors.colorGray2, colors.colorGray2]),
            inputDecoration: InputDecoration(
              border: InputBorder.none,
              enabledBorder: InputBorder.none,
              disabledBorder: InputBorder.none,
              focusedBorder: InputBorder.none,
              contentPadding: const EdgeInsets.symmetric(horizontal: kPaddingMedium, vertical: kPaddingSmallMedium),
              suffixIconConstraints: const BoxConstraints(maxHeight: double.infinity, maxWidth: double.infinity),
              hintText: locale.page_chat_message_hint,
              hintStyle: typography.styleButtonRegular.copyWith(color: colors.black),
            ),
            // borderRadius: BorderRadius.circular(kBorderRadiusMassive),
            elevation: 0,
            enableSafeArea: false,
          ),
        ),
        child: Scaffold(
          extendBody: true,
          backgroundColor: colors.colorGray1,
          appBar: AppBar(
            backgroundColor: colors.colorGray1,
            elevation: 0,
            leadingWidth: double.infinity,
            leading: Row(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Padding(
                  padding: const EdgeInsets.only(left: kPaddingMedium),
                  child: PositiveButton(
                    colors: colors,
                    onTapped: () => context.router.pop(),
                    icon: UniconsLine.angle_left,
                    layout: PositiveButtonLayout.iconOnly,
                    size: PositiveButtonSize.medium,
                    primaryColor: colors.white,
                  ),
                ),
                const SizedBox(width: kPaddingSmall),
                const Expanded(
                  child: const _AvatarList(
                    memberImageUrls: [
                      "https://images.unsplash.com/photo-1494790108377-be9c29b29330?ixlib=rb-4.0.3&ixid=MnwxMjA3fDB8MHxwaG90by1wYWdlfHx8fGVufDB8fHx8&auto=format&fit=crop&w=2487&q=80",
                      "https://images.unsplash.com/photo-1494790108377-be9c29b29330?ixlib=rb-4.0.3&ixid=MnwxMjA3fDB8MHxwaG90by1wYWdlfHx8fGVufDB8fHx8&auto=format&fit=crop&w=2487&q=80",
                      "https://images.unsplash.com/photo-1494790108377-be9c29b29330?ixlib=rb-4.0.3&ixid=MnwxMjA3fDB8MHxwaG90by1wYWdlfHx8fGVufDB8fHx8&auto=format&fit=crop&w=2487&q=80",
                    ],
                  ),
                ),
                const Spacer(),
                PositiveButton(
                  colors: colors,
                  primaryColor: colors.teal,
                  onTapped: () async {},
                  icon: UniconsLine.ellipsis_h,
                  size: PositiveButtonSize.medium,
                  layout: PositiveButtonLayout.iconOnly,
                ),
                const SizedBox(width: kPaddingMedium),
              ],
            ),
          ),
          body: Column(
            children: <Widget>[
              Expanded(
                child: StreamMessageListView(),
              ),
              Container(
                margin: const EdgeInsets.symmetric(horizontal: kPaddingSmall),
                padding: const EdgeInsets.all(kPaddingExtraSmall),
                clipBehavior: Clip.hardEdge,
                decoration: BoxDecoration(
                  color: colors.white,
                  borderRadius: BorderRadius.circular(kBorderRadiusMassive),
                ),
                child: StreamMessageInput(
                  attachmentButtonBuilder: (context, attachmentButton) => PositiveButton(
                    colors: colors,
                    primaryColor: colors.black,
                    onTapped: () async => attachmentButton.onPressed(),
                    label: 'Add attachment',
                    tooltip: 'Add an attachment',
                    icon: UniconsLine.plus_circle,
                    style: PositiveButtonStyle.primary,
                    layout: PositiveButtonLayout.iconOnly,
                    size: PositiveButtonSize.large,
                  ),
                  enableActionAnimation: false,
                  sendButtonLocation: SendButtonLocation.inside,
                  activeSendButton: const _SendButton(),
                  idleSendButton: const _SendButton(),
                  commandButtonBuilder: (context, commandButton) => const SizedBox(),
                ),
              ),
              SizedBox(height: MediaQuery.of(context).viewPadding.bottom)
            ],
          ),
        ),
      ),
    );
  }
}

class _SendButton extends ConsumerWidget {
  const _SendButton({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final DesignColorsModel colors = ref.watch(designControllerProvider.select((value) => value.colors));
    return Container(
      height: 40,
      width: 40,
      margin: const EdgeInsets.only(right: kPaddingExtraSmall),
      alignment: Alignment.center,
      decoration: BoxDecoration(shape: BoxShape.circle, color: colors.black),
      child: Icon(UniconsLine.message, color: colors.white, size: PositiveButton.kButtonIconRadiusRegular),
    );
  }
}

class _AvatarList extends StatelessWidget {
  final List<String> memberImageUrls;

  const _AvatarList({Key? key, required this.memberImageUrls}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        for (var i = 0; i < memberImageUrls.length; i++)
          Align(
            alignment: Alignment.centerLeft,
            child: Padding(
              padding: EdgeInsets.only(left: kPaddingMedium * i),
              child: SizedBox(
                height: 40,
                width: 40,
                child: PositiveProfileCircularIndicator(
                  profile: Profile(
                    profileImage: memberImageUrls[i],
                  ),
                  size: 20,
                ),
              ),
            ),
          ),
      ],
    );
  }
}
