import 'package:happiness_club_merchant/utils/extensions/extensions.dart';
import 'package:dartz/dartz.dart';
import 'package:flutter/material.dart';

import '../../../../../app/validator/text_field_validator.dart';
import '../../../../../services/error/failure.dart';
import '../../../../../utils/router/app_state.dart';
import '../usecases/send_reset_password.dart';

class ResetPasswordViewModel extends ChangeNotifier {
  final AppState _appState;
  final SendResetPassword _sendResetPassword;

  ResetPasswordViewModel(
      {required AppState appState,
      required SendResetPassword sendResetPassword})
      : _appState = appState,
        _sendResetPassword = sendResetPassword;

  bool isLoading = false;
  String email = '';
  ValueNotifier<bool> isLoadingNotifier = ValueNotifier(false);
  bool isButtonEnabled = false;
  ValueChanged<String>? errorMessages;
  ValueChanged<String>? successMessage;
  TextEditingController newPassController = TextEditingController();
  TextEditingController confirmPassController = TextEditingController();
  VoidCallback? toggleShowLoader;
  ValueNotifier<bool> isHidden = ValueNotifier(true);

  void handleError(Either<Failure, dynamic> either) {
    isLoadingNotifier.value = false;
    either.fold((l) {
      l.checkAndTakeAction(onError: errorMessages);
    }, (r) => null);
  }

  void init() {
    newPassController.clear();
    confirmPassController.clear();
    isButtonEnabled = false;
    notifyListeners();
  }

  void validateTextFieldsNotEmpty() {
    if (newPassController.text.isNotEmpty &&
        confirmPassController.text.isNotEmpty &&
        TextFieldValidator.isPasswordCompliant(newPassController.text) ==
            null &&
        TextFieldValidator.validateConfirmPassword(
                confirmPassController.text, newPassController.text) ==
            null) {
      isButtonEnabled = true;
      notifyListeners();
      return;
    }
    isButtonEnabled = false;
    notifyListeners();
  }

  Future<void> sendResetPassword(context) async {
    isLoadingNotifier.value = true;
    var params = SendResetPasswordParams(
        email: email,
        password: newPassController.text,
        confirmPassword: confirmPassController.text);
    var sendOtpEither = await _sendResetPassword.call(params);
    if (sendOtpEither.isLeft()) {
      handleError(sendOtpEither);
      return;
    }
    isButtonEnabled = false;
    notifyListeners();

    successMessage?.call('Reset password successfully');

    Future.delayed(const Duration(seconds: 1), () {
      //

      Navigator.popUntil(context, (route) {
        return route.isFirst;
      });
    });

    isLoadingNotifier.value = false;
    return;
  }
}
