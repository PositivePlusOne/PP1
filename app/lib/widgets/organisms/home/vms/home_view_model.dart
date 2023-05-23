// Dart imports:
import 'dart:async';
import 'dart:convert';

// Package imports:
import 'package:cloud_functions/cloud_functions.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:infinite_scroll_pagination/infinite_scroll_pagination.dart';
import 'package:logger/logger.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

// Project imports:
import 'package:app/extensions/future_extensions.dart';
import 'package:app/extensions/json_extensions.dart';
import 'package:app/gen/app_router.dart';
import 'package:app/hooks/lifecycle_hook.dart';
import 'package:app/widgets/organisms/login/vms/login_view_model.dart';
import '../../../../services/third_party.dart';

part 'home_view_model.freezed.dart';
part 'home_view_model.g.dart';

@freezed
class HomeViewModelState with _$HomeViewModelState {
  const factory HomeViewModelState({
    @Default(false) bool isRefreshing,
    @Default(0) currentTabIndex,
  }) = _HomeViewModelState;

  factory HomeViewModelState.initialState() => const HomeViewModelState();
}

@Riverpod(keepAlive: true)
class HomeViewModel extends _$HomeViewModel with LifecycleMixin {
  static const int windowSize = 10;
  final PagingController<String, dynamic> userTimelinePagingController = PagingController<String, dynamic>(firstPageKey: '');

  @override
  HomeViewModelState build() {
    userTimelinePagingController.addPageRequestListener(requestNextTimelinePage);
    return HomeViewModelState.initialState();
  }

  Future<void> requestNextTimelinePage(String pageKey) => runWithBackoff(ref, () async {
        final Logger logger = ref.read(loggerProvider);
        final FirebaseAuth auth = ref.read(firebaseAuthProvider);
        final FirebaseFunctions functions = ref.read(firebaseFunctionsProvider);

        if (auth.currentUser == null) {
          logger.d('requestNextTimelinePage() - user is not logged in, returning');
          userTimelinePagingController.error = 'User is not logged in';
          return;
        }

        try {
          final HttpsCallableResult response = await functions.httpsCallable('stream-getFeedWindow').call({
            'feed': 'timeline',
            'options': {
              'slug': auth.currentUser!.uid,
              'windowLastActivityId': pageKey,
            },
          });

          final Map<String, dynamic> data = json.decodeSafe(response.data);

          logger.d('requestNextTimelinePage() - data: $data');
          final String next = data['next'];
          final List<dynamic> activities = data['activities'].map((dynamic activity) => activity as Map<String, dynamic>).toList();
          final bool hasNext = next.isNotEmpty && next != pageKey;

          logger.d('requestNextTimelinePage() - hasNext: $hasNext');
          final newActivities = activities.map((e) => json.encode(e)).toList();

          if (!hasNext) {
            userTimelinePagingController.appendLastPage(newActivities);
          } else {
            userTimelinePagingController.appendPage(newActivities, next);
          }
        } catch (ex) {
          logger.e('requestNextTimelinePage() - ex: $ex');
          userTimelinePagingController.error = ex;
        }
      }, key: 'requestNextTimelinePage');

  Future<bool> onWillPopScope() async {
    if (state.currentTabIndex != 0) {
      state = state.copyWith(currentTabIndex: 0);
    }

    return false;
  }

  Future<void> onTabSelected(int index) async {
    final Logger logger = ref.read(loggerProvider);
    logger.d('onTabSelected() - index: $index');

    state = state.copyWith(currentTabIndex: index);
  }

  Future<void> onSignInSelected() async {
    final Logger logger = ref.read(loggerProvider);
    final AppRouter appRouter = ref.read(appRouterProvider);
    final LoginViewModel loginViewModel = ref.read(loginViewModelProvider.notifier);

    logger.d('onSignInRequested()');
    loginViewModel.resetState();
    await appRouter.push(LoginRoute(senderRoute: HomeRoute));
  }
}
