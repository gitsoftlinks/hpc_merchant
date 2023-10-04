import 'package:happiness_club_merchant/utils/constants/user_types_enum.dart';
import 'package:happiness_club_merchant/utils/extensions/extensions.dart';
import 'package:happiness_club_merchant/utils/router/ui_pages.dart';
import 'package:dartz/dartz.dart';
import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';

import '../../../../../app/providers/account_provider.dart';
import '../../../../../app/validator/text_field_validator.dart';
import '../../../../../services/error/failure.dart';
import '../../../../../utils/router/app_state.dart';
import '../../../../../utils/router/models/page_action.dart';
import '../../../../../utils/router/models/page_config.dart';
import '../usecases/activate_account_verify_otp.dart';
import '../usecases/send_activate_account_otp.dart';

class ActivateAccountViewModel extends ChangeNotifier {
  final AppState _appState;
  final SendActivateAccountVerifyOtp _sendActivateAccountVerifyOtp;
  final SendActivateAccountOtp _sendActivateAccountOtp;

  ActivateAccountViewModel(
      {required AppState appState,
      required SendActivateAccountVerifyOtp sendActivateAccountVerifyOtp,
      required SendActivateAccountOtp sendActivateAccountOtp})
      : _appState = appState,
        _sendActivateAccountVerifyOtp = sendActivateAccountVerifyOtp,
        _sendActivateAccountOtp = sendActivateAccountOtp;

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

  void verifyOtp() async {
    isLoadingNotifier.value = true;
    var params = SendActivateAccountVerifyOtpParams(
        email: email, code: otpController.text);
    var sendOtpEither = await _sendActivateAccountVerifyOtp.call(params);
    if (sendOtpEither.isLeft()) {
      handleError(sendOtpEither);
      return;
    }
    GetIt.I.get<AccountProvider>().upDateUserStatus(StatusTypeEnum.active);
    isLoadingNotifier.value = false;
    _appState.currentAction =
        PageAction(state: PageState.replaceAll, page: HomeScreenConfig);
  }

  Future<void> sendActivateAccountOtp() async {
    toggleShowLoader?.call();
    var sendForgetOtpEither = await _sendActivateAccountOtp.call(email);
    if (sendForgetOtpEither.isLeft()) {
      handleError(sendForgetOtpEither);
      toggleShowLoader?.call();
      return;
    }

    toggleShowLoader?.call();
    successMessage?.call('code_sent_to_your_email'.ntr());
    return;
  }

  Future<bool> activateAccountSendOtpToEmail() async {
    isLoadingNotifier.value = true;
    var sendForgetOtpEither =
        await _sendActivateAccountOtp.call(emailController.text);
    if (sendForgetOtpEither.isLeft()) {
      handleError(sendForgetOtpEither);
      isLoadingNotifier.value = false;
      return false;
    }
    isLoadingNotifier.value = false;
    return true;
  }

  void moveToActivateAccountScreen() async {
    if (emailController.text.isNotEmpty &&
        TextFieldValidator.validateEmail(emailController.text) == null) {
      if (!(await activateAccountSendOtpToEmail())) {
        return;
      }

      // _appState.currentAction = PageAction(state: PageState.addPage, page: PageConfiguration.withArguments(ActivateAccountScreenConfig, {'email': emailController.text}));
      return;
    }
    emailErrorText.value =
        TextFieldValidator.validateEmail(emailController.text) ?? '';
  }
}
