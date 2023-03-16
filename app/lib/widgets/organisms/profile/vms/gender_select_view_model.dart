// Package imports:
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

// Project imports:
part 'gender_select_view_model.freezed.dart';

part 'gender_select_view_model.g.dart';

@freezed
class GenderOption with _$GenderOption {
  const factory GenderOption({
    required String label,
    required String id,
  }) = _GenderOption;
}

@freezed
class GenderSelectState with _$GenderSelectState {
  const factory GenderSelectState({
    String? searchQuery,
    GenderOption? selectedOption,
    @Default(<GenderOption>[]) List<GenderOption> options,
  }) = _GenderSelectState;
}

@riverpod
class GenderSelectViewModel extends _$GenderSelectViewModel {
  List<GenderOption> allOptions = [];

  @override
  FutureOr<GenderSelectState> build() async {
    final options = await _fetchOptions();
    allOptions = options;
    return GenderSelectState(options: options);
  }

  void updateSearchQuery(String query) {
    // only update the state if the options have been fetched
    if (state.hasValue) {
      state = AsyncData(
        state.value!.copyWith(
          searchQuery: query,
          options: allOptions.where((option) => option.label.toLowerCase().contains(query.toLowerCase())).toList(),
        ),
      );
    }
  }

  void updateSelectedOption(GenderOption option) {
    // only update the state if the options have been fetched
    if (state.hasValue) {
      state = AsyncData(
        state.value!.copyWith(
          selectedOption: option,
        ),
      );
    }
  }

  Future<List<GenderOption>> _fetchOptions() async {
    await Future.delayed(const Duration(milliseconds: 5000));
    return tempData;
  }
}

const tempData = <GenderOption>[
  GenderOption(id: "Femme", label: "Femme"),
  GenderOption(id: "Genderqueer", label: "Genderqueer"),
  GenderOption(id: "Genderfluid", label: "Genderfluid"),
  GenderOption(id: "Intersex", label: "Intersex"),
  GenderOption(id: "Masculine", label: "Masculine"),
  GenderOption(id: "Neutrois", label: "Neutrois"),
  GenderOption(id: "Nonbinary", label: "Nonbinary"),
  GenderOption(id: "Gender Other", label: "Gender Other"),
  GenderOption(id: "Pangender", label: "Pangender"),
  GenderOption(id: "Third", label: "Third"),
  GenderOption(id: "Gender", label: "Gender"),
  GenderOption(id: "Transgender", label: "Transgender"),
  GenderOption(id: "Trans Man", label: "Trans Man"),
  GenderOption(id: "Trans", label: "Trans"),
  GenderOption(id: "Woman", label: "Woman"),
  GenderOption(id: "Man", label: "Man"),
  GenderOption(id: "Woman", label: "Woman"),
  GenderOption(id: "Androgynous", label: "Man"),
  GenderOption(id: "Bigender", label: "Bigender"),
  GenderOption(id: "Demigirl", label: "Demigirl"),
  GenderOption(id: "Demiguy", label: "Demiguy"),
  GenderOption(id: "Feminine", label: "Feminine"),
];
