import 'dart:async';
import 'package:happiness_club_merchant/app/providers/account_provider.dart';
import 'package:happiness_club_merchant/utils/extensions/extensions.dart';
import 'package:happiness_club_merchant/utils/router/models/page_action.dart';
import 'package:dartz/dartz.dart';
import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';
import '../../../../../app/app_usecase/save_access_token.dart';
import '../../../../../services/error/failure.dart';
import '../../../../../utils/router/app_state.dart';
import '../../../../../utils/router/models/page_config.dart';
import '../../../home/model/home_view_model.dart';
import '../usecases/send_forget_password_otp.dart';
import '../usecases/send_login.dart';

class SignInViewModel extends ChangeNotifier {
  //

  final AppState _appState;
  final SendLogin _sendLogin;

  final SaveAccessToken _saveLoginToken;
  final SendForgetPasswordOtp _sendForgetPasswordOtp;

  SignInViewModel({
    required AppState appState,
    required SendLogin sendLogin,
    required SaveAccessToken saveLoginToken,
    required SendForgetPasswordOtp sendForgetPasswordOtp,
  })  : _appState = appState,
        _sendLogin = sendLogin,
        _saveLoginToken = saveLoginToken,
        _sendForgetPasswordOtp = sendForgetPasswordOtp;

  TextEditingController passwordController = TextEditingController();
  TextEditingController emailController = TextEditingController();
  ValueNotifier<bool> isLoadingNotifier = ValueNotifier(false);

  ValueNotifier<bool> isHidden = ValueNotifier(true);
  bool isButtonEnabled = false;
  ValueChanged<String>? errorMessages;
  ValueNotifier<String> emailErrorText = ValueNotifier('');
  VoidCallback? toggleShowLoader;
  bool invalidUserNameError = false;
  final signInFormKey = GlobalKey<FormState>();

  bool isLoading = false;

  void handleError(Either<Failure, dynamic> either) {
    isLoadingNotifier.value = false;
    isLoading = false;
    notifyListeners();
    either.fold((l) {
      if (l is NotFoundFailure) {
        invalidUserNameError = true;
        notifyListeners();
        return;
      }
      l.checkAndTakeAction(onError: errorMessages);
    }, (r) => null);
  }

  Future<void> init() async {
    // clearData();
  }

  void clearData() {
    emailErrorText.value = '';
    invalidUserNameError = false;
    emailController.clear();
    passwordController.clear();
    notifyListeners();
  }

  /// This method check requirements for the api call
  void validateTextFieldsNotEmpty() {
    if (passwordController.text.isNotEmpty && emailController.text.isNotEmpty) {
      isButtonEnabled = true;
      invalidUserNameError = false;
      notifyListeners();
      return;
    }

    isButtonEnabled = false;
    invalidUserNameError = false;
    notifyListeners();
  }

  void signInUser() async {
    isLoadingNotifier.value = true;

    notifyListeners();

    var params = SendLoginParams(
        email: emailController.text, password: passwordController.text);

    var sendLoginEither = await _sendLogin.call(params);

    if (sendLoginEither.isLeft()) {
      handleError(sendLoginEither);
      return;
    }

    var user = sendLoginEither.toOption().toNullable()!;

    await saveLoginResponseData(user);
  }

  Future<void> saveLoginResponseData(UserDetailResponse user) async {
    GetIt.I.get<AccountProvider>().cacheRegisteredUserData(user.user);

    await saveLoginToken(user.token);

    isLoadingNotifier.value = false;

    GetIt.I.get<HomeViewModel>().controller.index = 0;

    _appState.currentAction =
        PageAction(state: PageState.replaceAll, page: HomeScreenConfig);
    notifyListeners();
    signInFormKey.currentState?.reset();
    isLoading = false;
    notifyListeners();
    clearData();
  }

  Future<void> saveLoginToken(String token) async {
    var saveTokenEither = await _saveLoginToken.call(token);

    if (saveTokenEither.isLeft()) {
      handleError(saveTokenEither);
      return;
    }
  }

  void moveToSignUpScreen() {
    _appState.currentAction =
        PageAction(state: PageState.addPage, page: SignUpScreenConfig);
  }

  Future<bool> sendForgetPasswordOtp() async {
    toggleShowLoader?.call();
    var sendForgetOtpEither =
        await _sendForgetPasswordOtp.call(emailController.text);
    if (sendForgetOtpEither.isLeft()) {
      handleError(sendForgetOtpEither);
      toggleShowLoader?.call();
      return false;
    }
    toggleShowLoader?.call();
    return true;
  }

  void moveToForgotPasswordScreen() async {
    _appState.currentAction = PageAction(
        state: PageState.addPage, page: InsertEmailPasswordScreenConfig);
  }
}
