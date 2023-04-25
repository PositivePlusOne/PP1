// Dart imports:
import 'dart:convert';

// Package imports:
import 'package:cloud_functions/cloud_functions.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:logger/logger.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

// Project imports:
import 'package:app/services/third_party.dart';
import '../../dtos/database/activities/activities.dart';

part 'events_controller.freezed.dart';
part 'events_controller.g.dart';

@freezed
class EventsControllerState with _$EventsControllerState {
  const EventsControllerState._();

  const factory EventsControllerState({
    @Default([]) List<Activity> events,
  }) = _EventsControllerState;

  factory EventsControllerState.initialState() => const EventsControllerState();
}

@Riverpod(keepAlive: true)
class EventsController extends _$EventsController {
  @override
  EventsControllerState build() {
    return EventsControllerState.initialState();
  }

  Future<void> updateEvents() async {
    final Logger logger = ref.read(loggerProvider);
    logger.d('updateEvents()');

    final FirebaseFunctions functions = ref.read(firebaseFunctionsProvider);
    final HttpsCallable callable = functions.httpsCallable('activities-getEventActivities');
    final HttpsCallableResult result = await callable.call();

    logger.d('updateEvents() - result: ${result.data}');
    final List<dynamic> events = (json.decode(result.data) as Map<String, dynamic>).values.toList();
    final List<Activity> activities = events.map((dynamic e) => Activity.fromJson(e as Map<String, dynamic>)).toList();

    state = state.copyWith(events: activities);
  }
}
