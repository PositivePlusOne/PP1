// Package imports:
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

// Project imports:
part 'hiv_status_view_model.freezed.dart';

part 'hiv_status_view_model.g.dart';

@freezed
class HivStatus with _$HivStatus {
  const factory HivStatus({
    required String label,
    List<HivStatus>? children,
  }) = _HivStatus;
}

@freezed
class HivStatusViewModelState with _$HivStatusViewModelState {
  const factory HivStatusViewModelState({
    @Default(<HivStatus>[]) List<HivStatus> options,
    HivStatus? selectedStatus,
    HivStatus? selectedSecondaryStatus,
    @Default(true) bool displayInApp,
  }) = _HivStatusViewModelState;

  factory HivStatusViewModelState.initialState() =>
      const HivStatusViewModelState();
}

@riverpod
class HivStatusViewModel extends _$HivStatusViewModel {
  @override
  HivStatusViewModelState build() {
    return const HivStatusViewModelState(options: tempData);
  }

  void toggleDisplayInApp() {
    state = state.copyWith(
      displayInApp: !state.displayInApp,
    );
  }

  void updateSelectedStatus(HivStatus status) {
    state = state.copyWith(
      selectedStatus: status,
    );
  }

  void updateSelectedSecondaryStatus(HivStatus status) {
    state = state.copyWith(
      selectedSecondaryStatus: status,
    );
  }
}

const tempData = <HivStatus>[
  HivStatus(
    label: 'Living With HIV',
    children: <HivStatus>[
      HivStatus(label: 'Positive'),
      HivStatus(label: 'Undetectable'),
      HivStatus(label: 'Negative'),
      HivStatus(label: 'Negative on PrEP'),
      HivStatus(label: 'Unsure'),
      HivStatus(label: 'Rather Not Say'),
    ],
  ),
  HivStatus(
    label: 'Affected by HIV',
    children: <HivStatus>[
      HivStatus(label: 'Parent of'),
      HivStatus(label: 'Sibling of'),
      HivStatus(label: 'Relative'),
      HivStatus(label: 'Friend'),
      HivStatus(label: 'Other'),
    ],
  ),
];
