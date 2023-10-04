import 'package:happiness_club_merchant/utils/extensions/extensions.dart';
import 'package:happiness_club_merchant/utils/router/ui_pages.dart';
import 'package:dartz/dartz.dart';
import 'package:flutter/material.dart';

import '../../../../../app/validator/text_field_validator.dart';
import '../../../../../services/error/failure.dart';
import '../../../../../utils/router/app_state.dart';
import '../../../../../utils/router/models/page_action.dart';
import '../../../../../utils/router/models/page_config.dart';
import '../../signin_screen/usecases/send_forget_password_otp.dart';
import '../usecases/forget_password_verify_otp.dart';

class ForgetPasswordViewModel extends ChangeNotifier {
  final AppState _appState;
  final SendForgetPasswordVerifyOtp _sendForgetPasswordVerifyOtp;
  final SendForgetPasswordOtp _sendForgetPasswordOtp;

  ForgetPasswordViewModel(
      {required AppState appState,
      required SendForgetPasswordVerifyOtp sendForgetPasswordVerifyOtp,
      required SendForgetPasswordOtp sendForgetPasswordOtp})
      : _appState = appState,
        _sendForgetPasswordVerifyOtp = sendForgetPasswordVerifyOtp,
        _sendForgetPasswordOtp = sendForgetPasswordOtp;

  bool isLoading = false;
  String email = '';
  ValueNotifier<bool> isLoadingNotifier = ValueNotifier(false);
  bool isButtonEnabled = false;
  ValueChanged<String>? errorMessages;
  ValueChanged<String>? successMessage;
  TextEditingController otpController = TextEditingController();
  VoidCallback? toggleShowLoader;
  TextEditingController emailController = TextEditingController();
  ValueNotifier<String> emailErrorText = ValueNotifier('');

  void handleError(Either<Failure, dynamic> either) {
    isLoadingNotifier.value = false;
    either.fold((l) {
      l.checkAndTakeAction(onError: errorMessages);
    }, (r) => null);
  }

  Future<void> init() async {
    otpController.clear();
    isButtonEnabled = false;
    emailController.clear();
    notifyListeners();
  }

  void validateTextFieldsNotEmpty() {
    if (emailController.text.isNotEmpty || otpController.text.isNotEmpty) {
      isButtonEnabled = true;
      notifyListeners();
      return;
    }
    isButtonEnabled = false;
    notifyListeners();
  }

  void verifyOtp(context) async {
    isLoadingNotifier.value = true;
    var params = SendForgetPasswordVerifyOtpParams(
        email: email, code: otpController.text);
    var sendOtpEither = await _sendForgetPasswordVerifyOtp.call(params);
    if (sendOtpEither.isLeft()) {
      handleError(sendOtpEither);
      return;
    }

    //

    _appState.currentAction = PageAction(
        state: PageState.replace,
        page: PageConfiguration.withArguments(
            ResetPasswordScreenConfig, {'email': email}));
    // Navigator.popUntil(context, (route) {
    //   // Return true when you reach the route that you want to keep

    //   return route.isFirst;
    // });
    isLoadingNotifier.value = false;
  }

  Future<void> sendForgetPasswordOtp() async {
    toggleShowLoader?.call();
    var sendForgetOtpEither = await _sendForgetPasswordOtp.call(email);
    if (sendForgetOtpEither.isLeft()) {
      handleError(sendForgetOtpEither);
      toggleShowLoader?.call();
      return;
    }

    toggleShowLoader?.call();
    successMessage?.call('code_sent_to_your_email'.ntr());
    return;
  }

  Future<bool> forgetPasswordOtp() async {
    isLoadingNotifier.value = true;
    var sendForgetOtpEither =
        await _sendForgetPasswordOtp.call(emailController.text);
    if (sendForgetOtpEither.isLeft()) {
      handleError(sendForgetOtpEither);
      isLoadingNotifier.value = false;
      return false;
    }
    isLoadingNotifier.value = false;
    return true;
  }

  void moveToForgotPasswordScreen() async {
    if (emailController.text.isNotEmpty &&
        TextFieldValidator.validateEmail(emailController.text) == null) {
      if (!(await forgetPasswordOtp())) {
        return;
      }

      _appState.currentAction = PageAction(
          state: PageState.addPage,
          page: PageConfiguration.withArguments(
              ForgotPasswordScreenConfig, {'email': emailController.text}));
      return;
    }
    emailErrorText.value =
        TextFieldValidator.validateEmail(emailController.text) ?? '';
  }
}
