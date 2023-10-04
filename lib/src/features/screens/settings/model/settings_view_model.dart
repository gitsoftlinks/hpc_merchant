import 'package:happiness_club_merchant/app/providers/account_provider.dart';
import 'package:happiness_club_merchant/src/features/screens/signin_screen/usecases/send_login.dart';
import 'package:happiness_club_merchant/utils/constants/user_types_enum.dart';
import 'package:happiness_club_merchant/utils/extensions/extensions.dart';
import 'package:dartz/dartz.dart';
import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';

import '../../../../../app/app_usecase/clear_secure_storage.dart';
import '../../../../../app/models/user_runtime_config.dart';
import '../../../../../services/error/failure.dart';
import '../../../../../services/usecases/usecase.dart';
import '../../../../../utils/router/app_state.dart';
import '../../../../../utils/router/models/page_action.dart';
import '../../../../../utils/router/models/page_config.dart';
import '../../../drawer/usecases/send_logout.dart';
import '../../../splash_screen/usecases/clear_shared_preferences.dart';
import '../usecases/send_settings.dart';

class SettingsViewModel extends ChangeNotifier {
  final SendSettings _sendSettings;
  final SendLogout _sendLogout;
  final AppState _appState;
  final ClearSecureStorage _clearSecureStorage;


  SettingsViewModel({required SendSettings sendSettings, required SendLogout sendLogout, required AppState appState, required ClearSecureStorage clearSecureStorage,})
      : _sendSettings = sendSettings,
        _sendLogout = sendLogout,
        _appState = appState,
  _clearSecureStorage = clearSecureStorage;


  ValueChanged<String>? errorMessages;
  ValueChanged<String>? successMessage;
  bool allowNotifications = false;
  bool allowPageVisibility = false;
  bool isAccountActive = true;
  VoidCallback? toggleShowLoader;
  UserData get userData => GetIt.I.get<AccountProvider>().user;
  VoidCallback? closeBottomSheet;
  VoidCallback? closeDeleteBottomSheet;
  VoidCallback? refreshState;
  VoidCallback? refreshDeleteBottomSheetState;
  ValueNotifier<bool> isLoadingNotifier = ValueNotifier(false);
  ClearSharedPreferences get clearSharedPreferences => GetIt.I.get<ClearSharedPreferences>();


  void handleError(Either<Failure, dynamic> either) {
    isLoadingNotifier.value = false;
    either.fold((l) {
      l.checkAndTakeAction(onError: errorMessages);
    }, (r) => null);
  }

  void init() {
   // allowNotifications = userData.notificationsAllowed == 0 ? false : true;
   // allowPageVisibility = userData.isVisible == 0 ? false : true;
  //  isAccountActive = userData.status == StatusTypeEnum.active ? true : false;
  }

  void toggleAllowNotifications(bool value) async {
    allowNotifications = value;
    notifyListeners();

    if (await saveSettings(property: SettingOptionsEnum.is_notification_allowed, status: value ? 'yes' : 'no')) {
      var showNotifications = value ? 1 : 0;
      GetIt.I.get<AccountProvider>().updateShowNotifications(showNotifications);
    }
  }

  void toggleAllowProfileVisibility(bool value) async {
    allowPageVisibility = value;
    notifyListeners();
    if (await saveSettings(property: SettingOptionsEnum.is_visible, status: value ? 'yes' : 'no')) {
      var visibility = value ? 1 : 0;
      GetIt.I.get<AccountProvider>().updateVisibility(visibility);
    }
  }

  void toggleIsActiveOrInactiveAccount() async {
    isLoadingNotifier.value = true;
    refreshState?.call();
    var value = isAccountActive ? 'yes' : 'no';
    if (await saveSettings(property: SettingOptionsEnum.is_deactivate_account, status: value)) {
      var status = value == 'yes' ? StatusTypeEnum.inactive : StatusTypeEnum.active;
      GetIt.I.get<AccountProvider>().upDateUserStatus(status);
      if (value == 'no') {
        isAccountActive = true;
        successMessage?.call('account_activated_successfully'.ntr());
        refreshState?.call();
        notifyListeners();
        closeBottomSheet?.call();
        isLoadingNotifier.value = false;
      } else {
        isAccountActive = false;
        refreshState?.call();
        notifyListeners();
        closeBottomSheet?.call();
        isLoadingNotifier.value = false;
        successMessage?.call('account_deactivated_successfully'.ntr());

        await logUserOutOfApp();
        return;
      }

    }
  }

  void deleteAccount() async{
    isLoadingNotifier.value = true;
    refreshDeleteBottomSheetState?.call();
    if (await saveSettings(property: SettingOptionsEnum.is_deleted, status: 'yes')) {
      isLoadingNotifier.value = false;
      refreshDeleteBottomSheetState?.call();
      notifyListeners();
      closeDeleteBottomSheet?.call();
      await logUserOutOfApp();

    }
  }

  Future<void> logUserOutOfApp() async{
    var logoutEither = await _sendLogout.call(NoParams());
    if (logoutEither.isLeft()) {
      handleError(logoutEither);
      return;
    }

    var clearSharePreferencesEither = await clearSharedPreferences.call(NoParams());
    if (clearSharePreferencesEither.isLeft()) {
      return;
    }

    var clearSecureStorageEither = await _clearSecureStorage.call(NoParams());
    if (clearSecureStorageEither.isLeft()) {
      handleError(clearSecureStorageEither);
      return;
    }
    GetIt.I.get<UserRuntimeConfig>().isLogin = false;
    _appState.currentAction = PageAction(state: PageState.replaceAll, page: LoginRegisterConfig);

  }


  Future<bool> saveSettings({required SettingOptionsEnum property, required String status}) async {
    if (property == SettingOptionsEnum.is_deactivate_account || property == SettingOptionsEnum.is_deleted) {
    } else {
      toggleShowLoader?.call();
    }

    var params = SendSettingsParams(accessToken: '', property: property, status: status);
    var saveSettingsEither = await _sendSettings.call(params);
    if (saveSettingsEither.isLeft()) {
      handleError(saveSettingsEither);
      if (property == SettingOptionsEnum.is_deactivate_account || property == SettingOptionsEnum.is_deleted) {
      } else {
        toggleShowLoader?.call();
      }
      return false;
    }
    if (property == SettingOptionsEnum.is_deactivate_account || property == SettingOptionsEnum.is_deleted) {
    } else {
      toggleShowLoader?.call();
    }
    notifyListeners();
    return true;
  }

}
