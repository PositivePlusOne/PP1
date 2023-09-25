// Package imports:
import 'package:riverpod_annotation/riverpod_annotation.dart';

// Project imports:
import 'package:app/constants/pagination_constants.dart';
import 'package:app/dtos/database/pagination/pagination.dart';
import '../dtos/database/common/endpoint_response.dart';
import 'api.dart';

part 'notification_api_service.g.dart';

@Riverpod(keepAlive: true)
FutureOr<NotificationApiService> notificationApiService(NotificationApiServiceRef ref) async {
  return NotificationApiService();
}

class NotificationApiService {
  FutureOr<EndpointResponse> listNotifications({
    String cursor = '',
    String targetUid = '',
  }) async {
    return await getHttpsCallableResult<EndpointResponse>(
      name: 'notifications-listNotifications',
      targetUid: targetUid,
      pagination: Pagination(cursor: cursor, limit: kStandardFeedWindowSize),
    );
  }

  FutureOr<EndpointResponse> markNotificationsAsReadAndSeen() async {
    return await getHttpsCallableResult<EndpointResponse>(name: 'notifications-markNotificationsAsReadAndSeen');
  }
}
