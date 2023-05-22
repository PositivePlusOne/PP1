// Flutter imports:
import 'dart:math';

import 'package:app/constants/design_constants.dart';
import 'package:app/dtos/system/design_colors_model.dart';
import 'package:app/helpers/brand_helpers.dart';
import 'package:app/providers/content/connections_controller.dart';
import 'package:app/providers/system/design_controller.dart';
import 'package:app/widgets/atoms/buttons/enumerations/positive_button_layout.dart';
import 'package:app/widgets/atoms/buttons/enumerations/positive_button_size.dart';
import 'package:app/widgets/atoms/buttons/enumerations/positive_button_style.dart';
import 'package:app/widgets/atoms/buttons/positive_button.dart';
import 'package:app/widgets/atoms/input/positive_search_field.dart';
import 'package:app/widgets/molecules/scaffolds/positive_scaffold.dart';
import 'package:app/widgets/organisms/chat/components/connections_list.dart';
import 'package:app/widgets/organisms/chat/components/empty_connections_list.dart';
import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

// Package imports:
import 'package:auto_route/auto_route.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:sliver_tools/sliver_tools.dart';
import 'package:unicons/unicons.dart';

@RoutePage()
class ConnectionsListPage extends ConsumerWidget {
  const ConnectionsListPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final DesignColorsModel colors = ref.watch(designControllerProvider.select((value) => value.colors));
    final locale = AppLocalizations.of(context)!;
    final double decorationBoxSize = min(MediaQuery.of(context).size.height / 2, 400);

    return PositiveScaffold(
      headingWidgets: [
        SliverPadding(
          padding: EdgeInsets.only(
            top: MediaQuery.of(context).padding.top + kPaddingSmall,
            // bottom: kPaddingSmall,
            left: kPaddingMedium,
            right: kPaddingMedium,
          ),
          sliver: SliverToBoxAdapter(
            child: Row(
              children: [
                PositiveButton(
                  colors: colors,
                  onTapped: () => context.router.pop(),
                  icon: UniconsLine.angle_left,
                  layout: PositiveButtonLayout.iconOnly,
                  size: PositiveButtonSize.medium,
                  primaryColor: colors.white,
                ),
                const SizedBox(width: kPaddingMedium),
                Expanded(
                  child: PositiveSearchField(
                    hintText: locale.shared_search_people_hint,
                    onSubmitted: (val) async => {},
                  ),
                ),
              ],
            ),
          ),
        ),
        Consumer(
          builder: (BuildContext context, WidgetRef ref, Widget? child) {
            final Widget? child = ref.watch(getConnectedUsersProvider).when(
              data: (data) {
                if (data.isNotEmpty) {
                  return ConnectionsList(connectedUsers: data);
                }
                return null;
              },
              loading: () {
                print('loading');
                return null;
              },
              error: (err, stack) {
                return null;
              },
            );
            if (child != null) {
              return child;
            }
            return const SliverToBoxAdapter(
              child: EmptyConnectionsList(),
            );
          },
        ),
      ],
      staticBackgroundWidget: Align(
        alignment: Alignment.bottomCenter,
        child: ConstrainedBox(
          constraints: BoxConstraints(
            maxHeight: decorationBoxSize,
          ),
          child: Stack(
            children: <Widget>[
              ...buildType3ScaffoldDecorations(colors),
            ],
          ),
        ),
      ),
      footerWidgets: [
        PositiveButton(
          isDisabled: true,
          colors: colors,
          style: PositiveButtonStyle.primary,
          label: locale.page_chat_action_start_conversation,
          onTapped: () => context.router.pop(),
          size: PositiveButtonSize.large,
          primaryColor: colors.black,
        ),
      ],
    );
  }
}
// class _ConversationItem extends ConsumerWidget {
//   final Channel channel;
//   const _ConversationItem({Key? key, required this.channel}) : super(key: key);
//
//   @override
//   Widget build(BuildContext context, WidgetRef ref) {
//     final DesignColorsModel colors = ref.watch(designControllerProvider.select((value) => value.colors));
//     final DesignTypographyModel typeography = ref.watch(designControllerProvider.select((value) => value.typography));
//     final String? currentUseId = ref.watch(userControllerProvider.select((value) => value.user?.uid));
//
//     return FutureBuilder<QueryMembersResponse>(
//         future: channel.queryMembers(),
//         builder: (context, snapshot) {
//           const maxImages = 2;
//           const maxNames = 3;
//
//           final members = snapshot.data?.members.where((member) => member.user?.id != currentUseId) ?? [];
//           final names = members.map((e) => "@${e.user?.name}");
//           final images = members.map((e) => e.user?.image);
//
//           return GestureDetector(
//             onTap: () => ref.read(chatViewModelProvider.notifier).onChatChannelSelected(channel),
//             child: Container(
//               height: 70,
//               margin: const EdgeInsets.symmetric(horizontal: kPaddingMedium, vertical: kPaddingExtraSmall),
//               padding: const EdgeInsets.all(kPaddingSmall),
//               decoration: BoxDecoration(
//                 color: colors.white,
//                 borderRadius: BorderRadius.circular(kBorderRadiusMassive),
//               ),
//               child: Row(
//                 children: [
//                   Stack(
//                     children: [
//                       ...images.take(maxImages).mapIndexed(
//                             (index, image) => Padding(
//                           padding: EdgeInsets.only(left: index * 25),
//                           child: PositiveProfileCircularIndicator(
//                             profile: Profile(profileImage: image ?? ""),
//                             size: 50,
//                           ),
//                         ),
//                       ),
//                       if (images.length > maxImages)
//                         Padding(
//                           padding: const EdgeInsets.only(left: maxImages * 25),
//                           child: PositiveCircularIndicator(
//                             ringColor: colors.black,
//                             borderThickness: kBorderThicknessSmall,
//                             size: 50,
//                             child: Center(
//                               child: Text(
//                                 "+${images.length - maxImages}",
//                                 style: const TextStyle(color: Colors.white),
//                               ),
//                             ),
//                           ),
//                         ),
//                     ],
//                   ),
//                   const SizedBox(width: kPaddingSmall),
//                   Expanded(
//                     child: Column(
//                       mainAxisAlignment: MainAxisAlignment.center,
//                       children: [
//                         FittedBox(
//                           fit: BoxFit.scaleDown,
//                           child: SizedBox(
//                             width: MediaQuery.of(context).size.width,
//                             child: Text(
//                               names.take(maxNames).join(", ") + (names.length > maxNames ? ", +${names.length - maxNames} More" : ""),
//                               style: typeography.styleTitle.copyWith(color: colors.colorGray7),
//                             ),
//                           ),
//                         ),
//                         const SizedBox(height: kPaddingExtraSmall),
//                         FutureBuilder<ChannelState>(
//                           future: channel.query(messagesPagination: const PaginationParams(limit: 1)),
//                           builder: (context, snapshot) {
//                             final messages = snapshot.data?.messages;
//
//                             if (messages != null && messages.isEmpty) {
//                               return const SizedBox();
//                             }
//
//                             final sender = messages?.first.user;
//                             final senderName = sender?.id != currentUseId ? "You" : sender?.name ?? "";
//                             final message = messages?.first.text?.replaceAll("\n", " ") ?? "";
//
//                             return Row(
//                               mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                               children: [
//                                 Expanded(
//                                   child: Text(
//                                     "$senderName: $message",
//                                     overflow: TextOverflow.ellipsis,
//                                     style: typeography.styleSubtext.copyWith(color: colors.colorGray3),
//                                   ),
//                                 ),
//                                 const SizedBox(width: kPaddingSmall),
//                                 ChannelLastMessageDate(
//                                   channel: channel,
//                                   textStyle: typeography.styleSubtext.copyWith(color: colors.colorGray3),
//                                 )
//                               ],
//                             );
//                           },
//                         ),
//                       ],
//                     ),
//                   ),
//                   const SizedBox(width: kPaddingSmall),
//                 ],
//               ),
//             ),
//           );
//         });
//   }
// }
