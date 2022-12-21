import '../actions/onboarding/preload_onboarding_steps_action.dart';
import '../actions/system/system_busy_toggle_action.dart';
import '../actions/system/update_app_check_token_action.dart';
import '../actions/system/update_current_exception_action.dart';
import '../actions/user/firebase_create_account_action.dart';
import '../actions/user/google_sign_in_request_action.dart';
import '../state/mutators/base_mutator.dart';

final Iterable<BaseMutator> mutators = <BaseMutator>[
  ...environmentMutators,
  ...systemMutators,
  ...designSystemMutators,
  ...userMutators,
];

final Iterable<BaseMutator> environmentMutators = <BaseMutator>[
  PreloadOnboardingStepsAction(),
];

final Iterable<BaseMutator> systemMutators = <BaseMutator>[
  SystemBusyToggleAction(),
  UpdateCurrentExceptionAction(),
  UpdateAppCheckTokenAction(),
];

final Iterable<BaseMutator> designSystemMutators = <BaseMutator>[];

final Iterable<BaseMutator> userMutators = <BaseMutator>[
  GoogleSignInRequestAction(),
  FirebaseCreateAccountAction(),
];
