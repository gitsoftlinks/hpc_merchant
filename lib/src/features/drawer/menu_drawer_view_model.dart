import 'package:happiness_club_merchant/src/features/drawer/usecases/send_logout.dart';
import 'package:happiness_club_merchant/utils/constants/string_constants.dart';
import 'package:dartz/dartz.dart';
import 'package:flutter/cupertino.dart';
import 'package:get_it/get_it.dart';
import 'package:happiness_club_merchant/app/providers/account_provider.dart';
import 'package:happiness_club_merchant/utils/extensions/extensions.dart';

import '../../../app/app_usecase/clear_secure_storage.dart';
import '../../../app/models/user_runtime_config.dart';
import '../../../services/error/failure.dart';
import '../../../services/usecases/usecase.dart';
import '../../../utils/router/app_state.dart';
import '../../../utils/router/models/page_action.dart';
import '../../../utils/router/models/page_config.dart';
import '../screens/signin_screen/usecases/send_login.dart';
import '../splash_screen/usecases/clear_shared_preferences.dart';

class MenuDrawerViewModel extends ChangeNotifier {
  final AppState _appState;
  final ClearSecureStorage _clearSecureStorage;
  final SendLogout _sendLogout;

  MenuDrawerViewModel(
      {required AppState appState,
      required ClearSecureStorage clearSecureStorage,
      required SendLogout sendLogout})
      : _appState = appState,
        _clearSecureStorage = clearSecureStorage,
        _sendLogout = sendLogout;

  UserData get userDetail => GetIt.I.get<AccountProvider>().user;
  ValueChanged<String>? errorMessages;
  VoidCallback? toggleShowLoader;
  ClearSharedPreferences get clearSharedPreferences =>
      GetIt.I.get<ClearSharedPreferences>();

  void handleError(Either<Failure, dynamic> either) {
    either.fold((l) {
      l.checkAndTakeAction(onError: errorMessages);
    }, (r) => null);
  }

  void logout() async {
    var logoutEither = await _sendLogout.call(NoParams());
    if (logoutEither.isLeft()) {
      handleError(logoutEither);
      return;
    }

    var clearSharePreferencesEither =
        await clearSharedPreferences.call(NoParams());
    if (clearSharePreferencesEither.isLeft()) {
      return;
    }

    var clearSecureStorageEither = await _clearSecureStorage.call(NoParams());
    if (clearSecureStorageEither.isLeft()) {
      handleError(clearSecureStorageEither);
      return;
    }
    GetIt.I.get<UserRuntimeConfig>().isLogin = false;

    _appState.currentAction =
        PageAction(state: PageState.replaceAll, page: LoginRegisterConfig);
  }

  void moveToLoginRegisterScreen() {
    _appState.currentAction =
        PageAction(state: PageState.replaceAll, page: LoginRegisterConfig);
  }

  void onPressPersonalInfoButton() {
    _appState.currentAction =
        PageAction(state: PageState.addPage, page: PersonalInfoScreenConfig);
  }

  void onPressBusinesses() {
    _appState.currentAction =
        PageAction(state: PageState.addPage, page: AllBusinessesScreenConfig);
  }
}
