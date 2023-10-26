// Dart imports:
import 'dart:async';

// Package imports:
import 'package:app_links/app_links.dart';
import 'package:auto_route/auto_route.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:logger/logger.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

// Project imports:
import 'package:app/dtos/database/activities/reactions.dart';
import 'package:app/dtos/database/activities/tags.dart';
import 'package:app/gen/app_router.dart';
import 'package:app/providers/content/activities_controller.dart';
import 'package:app/providers/system/system_controller.dart';
import 'package:app/services/third_party.dart';

part 'universal_links_controller.freezed.dart';
part 'universal_links_controller.g.dart';

@freezed
class UniversalLinksState with _$UniversalLinksState {
  const factory UniversalLinksState({
    @Default('pp1') String expectedUniversalLinkScheme,
    Uri? latestUniversalLink,
    @Default(false) bool isUniversalLinkHandled,
  }) = _UniversalLinksState;

  factory UniversalLinksState.initialState() => const UniversalLinksState();
}

abstract class IUniversalLinksController {
  UniversalLinksState build();
  Future<HandleLinkResult> initialize({bool replaceRouteOnNavigate = false});
  Future<bool> canHandleLink(Uri? uri);
  Future<HandleLinkResult> handleLink(Uri? uri, {bool replaceRouteOnNavigate = false});
  Future<HandleLinkResult> handlePostRouteLink(UniversalPostRouteDetails routeDetails, {bool replaceRouteOnNavigate = false});
  Future<HandleLinkResult> handleTagRouteLink(UniversalTagRouteDetails routeDetails, {bool replaceRouteOnNavigate = false});
  Future<UniversalPostRouteDetails?> getRouteLinkDetails(Uri? uri);
  Future<UniversalTagRouteDetails?> getTagRouteLinkDetails(Uri? uri);
  Uri buildPostRouteLink(String activityId, String reactionId, String origin);
  Uri buildTagRouteLink(String tagId);
}

enum HandleLinkResult {
  handledWithNavigation,
  handledWithoutNavigation,
  notHandled,
}

typedef UniversalPostRouteDetails = ({String? activityId, String? reactionId, String? origin, Uri? source});
typedef UniversalTagRouteDetails = ({String? tagId});

@Riverpod(keepAlive: true)
class UniversalLinksController extends _$UniversalLinksController implements IUniversalLinksController {
  StreamSubscription<Uri?>? _allUriLinkStreamSubscription;

  @override
  UniversalLinksState build() {
    return UniversalLinksState.initialState();
  }

  @override
  Future<HandleLinkResult> initialize({bool replaceRouteOnNavigate = false}) async {
    final AppLinks appLinks = ref.read(appLinksProvider);
    final Logger logger = ref.read(loggerProvider);

    await _allUriLinkStreamSubscription?.cancel();
    _allUriLinkStreamSubscription = appLinks.uriLinkStream.listen(handleLink);
    logger.i('Universal links listeners setup');

    final Uri? initialUri = await appLinks.getInitialAppLink();
    if (initialUri == null) {
      logger.i('No initial universal link to handle');
      return HandleLinkResult.notHandled;
    }

    logger.i('Handling initial universal link: $initialUri');
    // await sharedPreferences.setString(kLatestUniversalLinkKey, actualLatestUniversalLink);
    return await handleLink(initialUri, replaceRouteOnNavigate: replaceRouteOnNavigate);
  }

  @override
  Future<bool> canHandleLink(Uri? uri) async {
    if (uri == null) {
      return false;
    }

    final UniversalPostRouteDetails? routeDetails = await getRouteLinkDetails(uri);
    final UniversalTagRouteDetails? tagRouteDetails = await getTagRouteLinkDetails(uri);

    return routeDetails != null || tagRouteDetails != null;
  }

  @override
  Future<UniversalPostRouteDetails?> getRouteLinkDetails(Uri? uri) async {
    final String activityId = uri?.queryParameters['activityId'] ?? '';
    final String reactionId = uri?.queryParameters['reactionId'] ?? '';
    final String origin = uri?.queryParameters['origin'] ?? '';
    final String scheme = uri?.scheme ?? '';

    bool canBuildRouteLink = scheme == state.expectedUniversalLinkScheme;
    if (activityId.isEmpty && reactionId.isEmpty) {
      canBuildRouteLink = false;
    }

    return canBuildRouteLink ? (activityId: activityId, reactionId: reactionId, origin: origin, source: uri) : null;
  }

  @override
  Future<UniversalTagRouteDetails?> getTagRouteLinkDetails(Uri? uri) async {
    final String tagId = uri?.queryParameters['tagId'] ?? '';
    final String scheme = uri?.scheme ?? '';

    bool canBuildRouteLink = scheme == state.expectedUniversalLinkScheme;
    if (tagId.isEmpty) {
      canBuildRouteLink = false;
    }

    return canBuildRouteLink ? (tagId: tagId) : null;
  }

  @override
  Future<HandleLinkResult> handleLink(Uri? uri, {bool replaceRouteOnNavigate = false}) async {
    final Logger logger = ref.read(loggerProvider);
    logger.i('Handling universal link: $uri');

    state = state.copyWith(latestUniversalLink: uri, isUniversalLinkHandled: false);

    final bool canHandle = await canHandleLink(uri);
    if (!canHandle) {
      logger.i('Cannot handle universal link');
      return HandleLinkResult.notHandled;
    }

    final UniversalPostRouteDetails? routeDetails = await getRouteLinkDetails(uri);
    if (routeDetails != null) {
      logger.i('Handling post route link: $routeDetails');
      return await handlePostRouteLink(routeDetails, replaceRouteOnNavigate: replaceRouteOnNavigate);
    }

    final UniversalTagRouteDetails? tagRouteDetails = await getTagRouteLinkDetails(uri);
    if (tagRouteDetails != null) {
      logger.i('Handling tag route link: $tagRouteDetails');
      return await handleTagRouteLink(tagRouteDetails, replaceRouteOnNavigate: replaceRouteOnNavigate);
    }

    logger.w('Unknown universal link');
    return HandleLinkResult.notHandled;
  }

  @override
  Future<HandleLinkResult> handlePostRouteLink(UniversalPostRouteDetails routeDetails, {bool replaceRouteOnNavigate = false}) async {
    final Logger logger = ref.read(loggerProvider);
    final AppRouter appRouter = ref.read(appRouterProvider);
    final ActivitiesController activitiesController = ref.read(activitiesControllerProvider.notifier);
    final SystemController systemController = ref.read(systemControllerProvider.notifier);

    // Check that we have completed the initial bootstrap
    if (!systemController.state.hasPerformedInitialSetup) {
      logger.e('Cannot handle universal link before initial setup');
      return HandleLinkResult.notHandled;
    }

    final bool isActivity = routeDetails.activityId?.isNotEmpty ?? false;

    PageRouteInfo<dynamic>? route;

    if (!isActivity) {
      logger.e('Unknown universal link');
      return HandleLinkResult.notHandled;
    }

    try {
      await activitiesController.getActivity(routeDetails.activityId!);
    } catch (e) {
      logger.e('Failed to get activity from database: $e');
    }

    final TargetFeed feed = TargetFeed.fromOrigin(routeDetails.origin ?? '');
    route = PostRoute(feed: feed, activityId: routeDetails.activityId!);

    // Check if already on the route
    bool isOnRoute = appRouter.current.name == route.routeName;

    // If it is a tag feed, we want to check we do not have that tag already in the route stack
    // if (isTagFeed) {
    //   final List<AutoRoutePage<dynamic>> routes = appRouter.stack;
    //   isOnRoute = routes.any((AutoRoutePage<dynamic> route) => route.name == TagFeedRoute.name && (route.routeData.args as TagFeedRouteArgs).tag.key == routeDetails.tagId);
    // }

    if (isOnRoute) {
      logger.i('Already on route: $route');
      return HandleLinkResult.handledWithoutNavigation;
    }

    if (replaceRouteOnNavigate) {
      logger.d('Removing all routes before navigating to post route');
      await appRouter.replaceAll([route]);
    } else {
      await appRouter.push(route);
    }

    logger.i('Handling route link: $routeDetails');
    state = state.copyWith(isUniversalLinkHandled: true);
    return HandleLinkResult.handledWithNavigation;
  }

  @override
  Uri buildPostRouteLink(String activityId, String reactionId, String origin) {
    final String scheme = state.expectedUniversalLinkScheme;
    const String host = 'positiveplusone.com';
    const String path = '/post';

    final Map<String, String> query = <String, String>{
      'activityId': activityId,
      'reactionId': reactionId,
      'origin': origin,
    };

    final String encodedQuery = query.entries.map((e) => '${e.key}=${Uri.encodeQueryComponent(e.value)}').join('&');
    return Uri(scheme: scheme, host: host, path: path, query: encodedQuery);
  }

  @override
  Future<HandleLinkResult> handleTagRouteLink(UniversalTagRouteDetails routeDetails, {bool replaceRouteOnNavigate = false}) async {
    final Logger logger = ref.read(loggerProvider);
    final AppRouter appRouter = ref.read(appRouterProvider);
    final SystemController systemController = ref.read(systemControllerProvider.notifier);

    // Check that we have completed the initial bootstrap
    if (!systemController.state.hasPerformedInitialSetup) {
      logger.e('Cannot handle universal link before initial setup');
      return HandleLinkResult.notHandled;
    }

    final bool isTag = routeDetails.tagId?.isNotEmpty ?? false;

    if (!isTag) {
      logger.e('Unknown universal link');
      return HandleLinkResult.notHandled;
    }

    PageRouteInfo<dynamic>? route;
    route = TagFeedRoute(tag: Tag(key: routeDetails.tagId!));

    // Check if already on the route
    bool isOnRoute = appRouter.current.name == route.routeName;

    final List<AutoRoutePage<dynamic>> routes = appRouter.stack;
    isOnRoute = routes.any((AutoRoutePage<dynamic> route) => route.name == TagFeedRoute.name && (route.routeData.args as TagFeedRouteArgs).tag.key == routeDetails.tagId);

    if (isOnRoute) {
      logger.i('Already on route: $route');
      return HandleLinkResult.handledWithoutNavigation;
    }

    if (replaceRouteOnNavigate) {
      logger.d('Removing all routes before navigating to post route');
      await appRouter.replaceAll([route]);
    } else {
      await appRouter.push(route);
    }

    logger.i('Handling route link: $routeDetails');
    state = state.copyWith(isUniversalLinkHandled: true);
    return HandleLinkResult.handledWithNavigation;
  }

  @override
  Uri buildTagRouteLink(String tagId) {
    final String scheme = state.expectedUniversalLinkScheme;
    const String host = 'positiveplusone.com';
    const String path = '/tag';

    final Map<String, String> query = <String, String>{
      'tagId': tagId,
    };

    final String encodedQuery = query.entries.map((e) => '${e.key}=${Uri.encodeQueryComponent(e.value)}').join('&');
    return Uri(scheme: scheme, host: host, path: path, query: encodedQuery);
  }
}
