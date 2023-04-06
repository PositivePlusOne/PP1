// Package imports:
import 'package:cloud_functions/cloud_functions.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:fluent_validation/fluent_validation.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:permission_handler/permission_handler.dart';

//* Used to pass some logic into when specific assets are used.
enum LocalizationContextFlags {
  form,
}

extension LocalizationExtensions on AppLocalizations {
  String fromObject(Object? error) {
    if (error == null) {
      return '';
    }

    final Type runtimeType = error.runtimeType;
    switch (runtimeType) {
      case PermissionStatus:
        return fromPermissionStatus(error as PermissionStatus);
      case FirebaseFunctionsException:
        return fromFirebaseFunctionsException(error as FirebaseFunctionsException);
      case FirebaseAuthException:
        return fromFirebaseAuthException(error as FirebaseAuthException);
      case ValidationError:
        return fromValidationError(error as ValidationError);
      default:
        return shared_errors_defaults_body;
    }
  }

  String fromPermissionStatus(PermissionStatus status) {
    return shared_errors_permissions;
  }

  String fromValidationErrorList(
    List<ValidationError> errors, {
    List<LocalizationContextFlags> contextFlags = const [],
  }) {
    if (errors.isEmpty) {
      return '';
    }

    // We only display the top error in the list.
    // Ordering is therefore important for which you wish to display.
    final ValidationError firstError = errors.first;

    return fromValidationError(firstError);
  }

  String fromValidationError(
    ValidationError error, {
    List<LocalizationContextFlags> contextFlags = const [],
  }) {
    switch (error.code) {
      case 'password-complexity':
        return shared_errors_password_complexity;
      default:
        return shared_errors_defaults_body;
    }
  }

  String fromFirebaseAuthException(FirebaseAuthException error) {
    switch (error.code) {
      case 'invalid-email':
        return shared_errors_invalid_email;
      case 'user-disabled':
        return shared_errors_user_disabled;
      case 'user-not-found':
        return shared_errors_user_not_found;
      case 'wrong-password':
        return shared_errors_wrong_password;
      case 'credential-already-in-use':
        return shared_errors_phone_number_already_in_use;
      case 'email-already-in-use':
        return shared_errors_email_already_in_use;
      case 'operation-not-allowed':
        return shared_errors_operation_not_allowed;
      case 'weak-password':
        return shared_errors_weak_password;
      case 'provider-already-linked':
        return shared_errors_provider_already_linked;
      case 'password-complexity':
        return shared_errors_password_complexity;
      default:
        return shared_errors_defaults_body;
    }
  }

  String fromFirebaseFunctionsException(FirebaseFunctionsException error) {
    switch (error.code) {
      case 'already-exists':
        return shared_errors_display_name_already_in_use;
      case 'invalid-argument':
        return shared_errors_invalid_argument;
      case 'unauthenticated':
        return shared_errors_unauthenticated;
      case 'permission-denied':
        return shared_errors_permission_denied;
      case 'resource-exhausted':
        return shared_errors_resource_exhausted;
      case 'failed-precondition':
        return shared_errors_failed_precondition;
      case 'aborted':
        return shared_errors_aborted;
      case 'out-of-range':
        return shared_errors_out_of_range;
      case 'unimplemented':
        return shared_errors_unimplemented;
      case 'unavailable':
        return shared_errors_unavailable;
      case 'data-loss':
        return shared_errors_data_loss;
      case 'internal':
      default:
        return shared_errors_defaults_body;
    }
  }
}
